/*
 * StageC.c - Real-time replay, signals and latency (Stage C), Group 21
 *
 * Loads the whole file into a malloc'd array sized to fit the data, then
 * replays the trades one at a time in timestamp order. Trade i is released
 * (ts_i - ts_0) / speed after the start. For every trade the program measures
 *   - processing time : time spent in the engine for that trade
 *   - latency         : time from the trade's scheduled release to the signal
 *                       decision (includes any time spent running behind)
 *   - lag             : how far behind the replay clock the program is
 * Signals can be shown on a coloured terminal (-c) and on the Pi LED (-l).
 * Every signal is also written to signals_log.csv for the rival bot (next step).
 *
 * Build : gcc -O3 -pthread temp_StageC.c StageA+.c rival.c -o StageC_O3 -lm
 *
 * Benchmark additions (default behavior remains fast parser + malloc):
 *   --parser old|fast       select original sscanf or custom Stage A+ parser
 *   --memory fixed|malloc  select Stage B's 10M static array or exact-fit malloc
 *   --threads N            number of worker threads for chunked CSV loading
 *   Benchmark time includes loading and replay (use this for V0-V4 comparisons).
 *
 * Usage : ./StageC [-f test|dev|stress] [-s SPEED] [-m MINUTES] [-n] [-c] [-l] [-q] [-o FILE] [-r US] [-p]
 *                  [--parser old|fast] [--memory fixed|malloc] [--threads N]
 */
/* Use MinGW's C99 scanf implementation for %lld in the original parser. */
#ifndef __USE_MINGW_ANSI_STDIO
#define __USE_MINGW_ANSI_STDIO 1
#endif
#define _FILE_OFFSET_BITS 64
#include "timing.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <math.h>     /* llround for original floating-point CSV parser */
#include <pthread.h>
#include "StageA+.h"
#include "led.h"
#include "rival.h"

#ifdef _WIN32
#include <windows.h>
#endif

/* ---------- Windows and files ---------- */
#define GROUP_SHORT 40          /* Group 21 */
#define GROUP_LONG  200
#define TEST_SHORT  3
#define TEST_LONG   5
#define TEST_PATH   "../DATABASE/test20.csv"
#define DEV_PATH    "../DATABASE/dev_1M.csv"
#define STRESS_PATH "../DATABASE/stress_full.csv"

/* ---------- Fixed-point scales (see Stage B) ---------- */
#define SCALE_P 100LL           /* price x 100 */
#define SCALE_Q 100000LL        /* qty x 100000 */

/* Stage B fixed-array capacity used by --memory fixed. */
#define STAGE_B_MAX_TRADES 10000000

/* Sleep only when more than this much waiting is left, then spin. */
#ifdef _WIN32
#define SLEEP_MARGIN_NS 20000000ULL
#else
#define SLEEP_MARGIN_NS 3000000ULL
#endif

typedef struct {
    long long ts_us;     /* timestamp, microseconds since 1970 */
    long long price;     /* price x SCALE_P */
    long long qty;       /* qty x SCALE_Q */
    int is_buy;          /* 1 = buy, 0 = sell */
} Trade;

/* One record per signal, for the rival bot. */
typedef struct {
    long long trade_index;   /* 0-based index of the triggering trade */
    int side;                /* 1 = BUY, -1 = SELL */
    unsigned long long proc_ns;     /* processing time of the triggering trade */
    unsigned long long latency_ns;  /* release-to-decision latency */
} SignalRecord;

typedef struct {
    const char *path;
    long long start_off;
    long long end_off;
    Trade *buf;
    long long capacity;
    long long count;
    int fast_mode;
    int failed;
} ParseChunkArg;

/* ---------- Data ---------- */
/* Static array: actual Stage B storage when fixed mode is selected. */
static Trade fixed_trades[STAGE_B_MAX_TRADES];
static Trade *trades = NULL;
static long long trade_count = 0;
static int use_fast_parser = 1;  /* preserve the original Stage C defaults */
static int use_malloc = 1;
static int num_threads = 1;
static int want_pct = 0;         /* -p: report percentile latency */
static size_t storage_bytes = 0;

/* ---------- Engine state ---------- */
static int short_win = GROUP_SHORT;
static int long_win = GROUP_LONG;
static int naive_mode = 0;
static long long short_sum = 0, long_sum = 0;
static long long prev_d = 0;
static int have_prev = 0;
static long long total_pq = 0, total_q = 0;

/* ---------- Rival bot (live P&L, see rival.h) ---------- */
static RivalState rival;
static uint64_t rival_ns = 1000;             /* standard R = 1 us */
static const char *log_path = "signals_log.csv";

/* ---------- Signal log ---------- */
static SignalRecord *sig_log = NULL;
static long long sig_count = 0, sig_cap = 0;
static long long buy_count = 0, sell_count = 0;

/* ------------------------------------------------------------------ */
/* Loading                                                             */
/* ------------------------------------------------------------------ */

/* Count the lines in the file (fast, no parsing) so we can malloc exactly. */
static long long count_lines(const char *path)
{
    FILE *fp = fopen(path, "rb");
    if (fp == NULL) return -1;

    static char buf[1 << 20];
    long long lines = 0;
    size_t n;
    int last = '\n';
    while ((n = fread(buf, 1, sizeof buf, fp)) > 0) {
        for (size_t k = 0; k < n; k++) {
            if (buf[k] == '\n') lines++;
        }
        last = (unsigned char)buf[n - 1];
    }
    fclose(fp);
    if (last != '\n') lines++;      /* final line without a newline */
    return lines;
}

static long long get_file_size_ll(const char *path)
{
    FILE *fp = fopen(path, "rb");
    if (fp == NULL) return -1;
#if defined(_WIN32) && defined(__MINGW32__)
    if (_fseeki64(fp, 0, SEEK_END) != 0) { fclose(fp); return -1; }
    long long sz = _ftelli64(fp);
#elif defined(_POSIX_C_SOURCE) || defined(__linux__) || defined(__APPLE__)
    if (fseeko(fp, 0, SEEK_END) != 0) { fclose(fp); return -1; }
    long long sz = (long long)ftello(fp);
#else
    if (fseek(fp, 0, SEEK_END) != 0) { fclose(fp); return -1; }
    long long sz = (long long)ftell(fp);
#endif
    fclose(fp);
    return sz;
}

static int seek_file_ll(FILE *fp, long long off)
{
#if defined(_WIN32) && defined(__MINGW32__)
    return _fseeki64(fp, off, SEEK_SET);
#elif defined(_POSIX_C_SOURCE) || defined(__linux__) || defined(__APPLE__)
    return fseeko(fp, (off_t)off, SEEK_SET);
#else
    return fseek(fp, (long)off, SEEK_SET);
#endif
}

static long long tell_file_ll(FILE *fp)
{
#if defined(_WIN32) && defined(__MINGW32__)
    return _ftelli64(fp);
#elif defined(_POSIX_C_SOURCE) || defined(__linux__) || defined(__APPLE__)
    return (long long)ftello(fp);
#else
    return (long long)ftell(fp);
#endif
}

/* Original Stage A helper's sscanf approach, adapted to return the same
 * fixed-point Trade representation as the custom Stage A+ reader.
 * Identical fields and math are used after loading, regardless of parser.
 * This assumes the project's price/quantity precision (2/5 decimals). */
static int read_trade_original_fixed(FILE *fp, long long *ts,
                                     long long *price_fx, long long *qty_fx,
                                     int *is_buy)
{
    char line[256], maker[16], best[16];
    long long trade_id, timestamp;
    double price, qty, quote_qty;

    while (fgets(line, sizeof line, fp)) {
        if (sscanf(line, "%lld,%lf,%lf,%lf,%lld,%15[^,],%15s",
                   &trade_id, &price, &qty, &quote_qty, &timestamp,
                   maker, best) != 7) continue;
        *ts = timestamp;
        *price_fx = llround(price * SCALE_P);
        *qty_fx = llround(qty * SCALE_Q);
        *is_buy = (maker[0] == 'F' || maker[0] == 'f');
        return 1;
    }
    return 0;
}

/* Parse one CSV trade line into fixed-point fields for chunk workers. */
static int parse_csv_line_fixed(const char *line, long long *ts,
                                long long *price_fx, long long *qty_fx,
                                int *is_buy, int fast_mode)
{
    if (fast_mode) {
        const char *p = strchr(line, ',');
        if (!p) return 0;
        p++; /* price */

        const char *end = p;
        long long whole = 0, frac_val = 0;
        int digits = 0, frac_digits = 0;
        while (*end >= '0' && *end <= '9') {
            whole = whole * 10 + (*end - '0');
            end++;
            digits++;
        }
        if (*end == '.') {
            end++;
            while (*end >= '0' && *end <= '9') {
                if (frac_digits < PRICE_DECIMALS) {
                    frac_val = frac_val * 10 + (*end - '0');
                    frac_digits++;
                }
                end++;
                digits++;
            }
        }
        if (digits == 0 || *end != ',') return 0;
        while (frac_digits < PRICE_DECIMALS) { frac_val *= 10; frac_digits++; }
        long long p_scale = 1;
        for (int d = 0; d < PRICE_DECIMALS; d++) p_scale *= 10;
        *price_fx = whole * p_scale + frac_val;

        p = end + 1; /* qty */
        end = p;
        whole = 0; frac_val = 0; digits = 0; frac_digits = 0;
        while (*end >= '0' && *end <= '9') {
            whole = whole * 10 + (*end - '0');
            end++;
            digits++;
        }
        if (*end == '.') {
            end++;
            while (*end >= '0' && *end <= '9') {
                if (frac_digits < QTY_DECIMALS) {
                    frac_val = frac_val * 10 + (*end - '0');
                    frac_digits++;
                }
                end++;
                digits++;
            }
        }
        if (digits == 0 || *end != ',') return 0;
        while (frac_digits < QTY_DECIMALS) { frac_val *= 10; frac_digits++; }
        long long q_scale = 1;
        for (int d = 0; d < QTY_DECIMALS; d++) q_scale *= 10;
        *qty_fx = whole * q_scale + frac_val;

        p = strchr(end + 1, ','); /* skip quoteQty */
        if (!p) return 0;
        p = strchr(p + 1, ',');   /* skip next field */
        if (!p) return 0;
        p++;                      /* ts */

        long long t_val = 0;
        if (*p < '0' || *p > '9') return 0;
        while (*p >= '0' && *p <= '9') {
            t_val = t_val * 10 + (*p - '0');
            p++;
        }
        if (*p != ',') return 0;
        *ts = t_val;

        p++;
        *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
        return 1;
    } else {
        char maker[16], best[16];
        long long trade_id, timestamp;
        double price, qty, quote_qty;
        if (sscanf(line, "%lld,%lf,%lf,%lf,%lld,%15[^,],%15s",
                   &trade_id, &price, &qty, &quote_qty, &timestamp,
                   maker, best) != 7) {
            return 0;
        }
        *ts = timestamp;
        *price_fx = llround(price * SCALE_P);
        *qty_fx = llround(qty * SCALE_Q);
        *is_buy = (maker[0] == 'F' || maker[0] == 'f') ? 1 : 0;
        return 1;
    }
}

static int ensure_chunk_capacity(ParseChunkArg *job, long long needed)
{
    if (needed <= job->capacity) return 0;
    long long new_cap = job->capacity > 0 ? job->capacity * 2 : 4096;
    while (new_cap < needed) new_cap *= 2;
    Trade *bigger = realloc(job->buf, (size_t)new_cap * sizeof(Trade));
    if (!bigger) {
        job->failed = 1;
        return -1;
    }
    job->buf = bigger;
    job->capacity = new_cap;
    return 0;
}

static void *parse_chunk_worker(void *arg)
{
    ParseChunkArg *job = (ParseChunkArg *)arg;
    job->count = 0;
    job->failed = 0;

    FILE *fp = fopen(job->path, "rb");
    if (!fp) {
        job->failed = 1;
        return NULL;
    }

    if (seek_file_ll(fp, job->start_off) != 0) {
        fclose(fp);
        job->failed = 1;
        return NULL;
    }

    char line[512];
    if (job->start_off > 0) {
        if (!fgets(line, sizeof line, fp)) {
            fclose(fp);
            return NULL;
        }
    }

    while (tell_file_ll(fp) < job->end_off && fgets(line, sizeof line, fp) != NULL) {
        long long ts, price, qty;
        int is_buy;
        if (parse_csv_line_fixed(line, &ts, &price, &qty, &is_buy, job->fast_mode)) {
            if (ensure_chunk_capacity(job, job->count + 1) != 0) {
                break;
            }
            Trade *dst = &job->buf[job->count++];
            dst->ts_us = ts;
            dst->price = price;
            dst->qty = qty;
            dst->is_buy = is_buy;
        }
    }

    fclose(fp);
    return NULL;
}

/* Load trades using either parser and either storage strategy. */
static long long load_trades(const char *path)
{
    long long lines = count_lines(path);
    if (lines < 0) {
        printf("Could not open %s\n", path);
        return -1;
    }
    if (lines == 0) {
        printf("The input file is empty\n");
        return -1;
    }

    if (use_malloc) {
        if ((unsigned long long)lines > SIZE_MAX / sizeof(Trade)) {
            printf("Dataset is too large to allocate\n");
            return -1;
        }
        storage_bytes = (size_t)lines * sizeof(Trade);
        trades = malloc(storage_bytes);
        if (!trades) {
            printf("malloc of %lld trades failed\n", lines);
            return -1;
        }
    } else {
        if (lines > STAGE_B_MAX_TRADES) {
            printf("Fixed array capacity exceeded (%lld > %d)\n",
                   lines, STAGE_B_MAX_TRADES);
            return -1;
        }
        trades = fixed_trades;
        storage_bytes = sizeof(fixed_trades);
    }

    FILE *fp = fopen(path, "r");
    if (!fp) {
        if (use_malloc) free(trades);
        trades = NULL;
        return -1;
    }

    long long n = 0;
    long long ts, price, qty;
    int is_buy;
    while (n < lines) {
        int ok = use_fast_parser
            ? read_trade_fixed(fp, &ts, &price, &qty, &is_buy)
            : read_trade_original_fixed(fp, &ts, &price, &qty, &is_buy);
        if (!ok) break;
        trades[n].ts_us = ts;
        trades[n].price = price;
        trades[n].qty = qty;
        trades[n].is_buy = is_buy;
        n++;
    }
    fclose(fp);
    return n;
}

static long long load_trades_mt(const char *path, int threads)
{
    if (threads <= 1) {
        return load_trades(path);
    }

    long long lines = count_lines(path);
    if (lines <= 0) {
        printf("Could not open or empty file: %s\n", path);
        return -1;
    }

    long long file_size = get_file_size_ll(path);
    if (file_size <= 0) {
        printf("Could not determine size of %s\n", path);
        return -1;
    }

    pthread_t *tids = calloc((size_t)threads, sizeof(pthread_t));
    ParseChunkArg *jobs = calloc((size_t)threads, sizeof(ParseChunkArg));
    if (!tids || !jobs) {
        free(tids);
        free(jobs);
        return -1;
    }

    long long approx_cap = (lines / threads) + 4096;
    if (approx_cap < 4096) approx_cap = 4096;
    long long chunk_span = file_size / threads;

    for (int t = 0; t < threads; t++) {
        jobs[t].path = path;
        jobs[t].start_off = (long long)t * chunk_span;
        jobs[t].end_off = (t == threads - 1) ? file_size : (long long)(t + 1) * chunk_span;
        jobs[t].capacity = approx_cap;
        jobs[t].buf = malloc((size_t)approx_cap * sizeof(Trade));
        jobs[t].count = 0;
        jobs[t].fast_mode = use_fast_parser;
        jobs[t].failed = 0;

        if (!jobs[t].buf) {
            for (int prev = 0; prev < t; prev++) {
                pthread_join(tids[prev], NULL);
                free(jobs[prev].buf);
            }
            free(jobs[t].buf);
            free(tids);
            free(jobs);
            return -1;
        }
        pthread_create(&tids[t], NULL, parse_chunk_worker, &jobs[t]);
    }

    long long total_loaded = 0;
    int any_failed = 0;
    for (int t = 0; t < threads; t++) {
        pthread_join(tids[t], NULL);
        if (jobs[t].failed) any_failed = 1;
        total_loaded += jobs[t].count;
    }

    if (any_failed || total_loaded <= 0) {
        for (int t = 0; t < threads; t++) free(jobs[t].buf);
        free(tids);
        free(jobs);
        return -1;
    }

    if (use_malloc) {
        if ((unsigned long long)total_loaded > SIZE_MAX / sizeof(Trade)) {
            for (int t = 0; t < threads; t++) free(jobs[t].buf);
            free(tids);
            free(jobs);
            return -1;
        }
        storage_bytes = (size_t)total_loaded * sizeof(Trade);
        trades = malloc(storage_bytes);
        if (!trades) {
            printf("malloc of %lld trades failed\n", total_loaded);
            for (int t = 0; t < threads; t++) free(jobs[t].buf);
            free(tids);
            free(jobs);
            return -1;
        }
    } else {
        if (total_loaded > STAGE_B_MAX_TRADES) {
            printf("Fixed array capacity exceeded (%lld > %d)\n",
                   total_loaded, STAGE_B_MAX_TRADES);
            for (int t = 0; t < threads; t++) free(jobs[t].buf);
            free(tids);
            free(jobs);
            return -1;
        }
        trades = fixed_trades;
        storage_bytes = sizeof(fixed_trades);
    }

    long long write_pos = 0;
    for (int t = 0; t < threads; t++) {
        if (jobs[t].count > 0) {
            memcpy(&trades[write_pos], jobs[t].buf,
                   (size_t)jobs[t].count * sizeof(Trade));
            write_pos += jobs[t].count;
        }
        free(jobs[t].buf);
    }

    free(tids);
    free(jobs);
    return write_pos;
}

/* ------------------------------------------------------------------ */
/* Percentile latency (stretch goal)                                   */
/* ------------------------------------------------------------------ */

static int cmp_u64(const void *a, const void *b)
{
    unsigned long long x = *(const unsigned long long *)a;
    unsigned long long y = *(const unsigned long long *)b;
    return (x > y) - (x < y);
}

/* Nearest-rank percentile of an ALREADY SORTED array:
 * the smallest value such that at least pct % of the values are <= it. */
static unsigned long long percentile_sorted(const unsigned long long *a, long long n, double pct)
{
    long long rank = (long long)((pct / 100.0) * (double)n + 0.999999999);  /* ceil */
    if (rank < 1) rank = 1;
    if (rank > n) rank = n;
    return a[rank - 1];
}

/* Sort a copy-free array in place and print p50 / p90 / p99 / p99.9 / max. */
static void print_percentiles(const char *label, unsigned long long *a, long long n)
{
    qsort(a, (size_t)n, sizeof a[0], cmp_u64);
    printf("%-22s: p50 %.3f us | p90 %.3f us | p99 %.3f us | p99.9 %.3f us | max %.3f us\n",
           label,
           percentile_sorted(a, n, 50.0)  / 1000.0,
           percentile_sorted(a, n, 90.0)  / 1000.0,
           percentile_sorted(a, n, 99.0)  / 1000.0,
           percentile_sorted(a, n, 99.9)  / 1000.0,
           a[n - 1] / 1000.0);
}

/* Print resident memory of this process (Linux/Pi only). */
static void print_memory(void)
{
#ifdef __linux__
    FILE *fp = fopen("/proc/self/status", "r");
    if (fp == NULL) return;
    char line[128];
    while (fgets(line, sizeof line, fp)) {
        if (strncmp(line, "VmRSS:", 6) == 0 || strncmp(line, "VmHWM:", 6) == 0) {
            printf("  %s", line);
        }
    }
    fclose(fp);
#endif
}

/* ------------------------------------------------------------------ */
/* Engine                                                              */
/* ------------------------------------------------------------------ */

/*
 * engine_step: update VWAP, both SMAs and the crossover for trade i.
 * Returns 1 for BUY, -1 for SELL, 0 for no signal.
 * Same maths as Stage B (exact integer crossover test).
 */
static inline int engine_step(long long i)
{
    long long p = trades[i].price;
    long long q = trades[i].qty;

    total_pq += p * q;
    total_q += q;

    if (naive_mode) {
        if (i >= short_win - 1) {
            long long s = 0;
            for (int k = 0; k < short_win; k++) s += trades[i - k].price;
            short_sum = s;
        }
        if (i >= long_win - 1) {
            long long s = 0;
            for (int k = 0; k < long_win; k++) s += trades[i - k].price;
            long_sum = s;
        }
    } else {
        short_sum += p;
        if (i >= short_win) short_sum -= trades[i - short_win].price;
        long_sum += p;
        if (i >= long_win) long_sum -= trades[i - long_win].price;
    }

    int signal = 0;
    if (i >= long_win - 1) {
        long long d = short_sum * long_win - long_sum * short_win;
        if (have_prev) {
            if (prev_d <= 0 && d > 0) signal = 1;
            else if (prev_d >= 0 && d < 0) signal = -1;
        }
        prev_d = d;
        have_prev = 1;
    }
    return signal;
}

/* ------------------------------------------------------------------ */
/* Replay helpers                                                      */
/* ------------------------------------------------------------------ */

/* Wait until now_ns() reaches target: sleep while far away, then spin. */
static inline void wait_until(uint64_t target)
{
    for (;;) {
        uint64_t now = now_ns();
        if (now >= target) return;
        uint64_t remaining = target - now;
        if (remaining > SLEEP_MARGIN_NS + 1000000ULL) {
            sleep_ms((int)((remaining - SLEEP_MARGIN_NS) / 1000000ULL));
        }
    }
}

static void enable_ansi(void)
{
#ifdef _WIN32
    HANDLE h = GetStdHandle(STD_OUTPUT_HANDLE);
    DWORD mode = 0;
    if (h != INVALID_HANDLE_VALUE && GetConsoleMode(h, &mode)) {
        SetConsoleMode(h, mode | 0x0004);   /* ENABLE_VIRTUAL_TERMINAL_PROCESSING */
    }
#endif
}

static void log_signal(long long i, int side, uint64_t proc_ns, uint64_t latency_ns)
{
    if (sig_count == sig_cap) {
        sig_cap = sig_cap ? sig_cap * 2 : 65536;
        SignalRecord *bigger = realloc(sig_log, (size_t)sig_cap * sizeof(SignalRecord));
        if (bigger == NULL) {
            printf("Out of memory for the signal log\n");
            exit(1);
        }
        sig_log = bigger;
    }
    sig_log[sig_count].trade_index = i;
    sig_log[sig_count].side = side;
    sig_log[sig_count].proc_ns = proc_ns;
    sig_log[sig_count].latency_ns = latency_ns;
    sig_count++;
}

/* Show a signal on the terminal and/or the LED. Called AFTER the decision
 * time has been taken, so display cost never counts as processing time. */
static void show_signal(int side, long long i, uint64_t latency_ns,
                        int use_colour, int use_led)
{
    double price = (double)trades[i].price / SCALE_P;
    if (use_colour) {
        printf("%s%-4s trade %-8lld price %.2f  latency %.2f us%s\n",
               side == 1 ? "\033[32m" : "\033[31m", side == 1 ? "BUY" : "SELL",
               i + 1, price, latency_ns / 1000.0, "\033[0m");
    }
    if (use_led) {
        if (side == 1) { led_off(LED_RED);   led_on(LED_GREEN); }
        else           { led_off(LED_GREEN); led_on(LED_RED); }
    }
}

int main(int argc, char *argv[])
{
    const char *path = STRESS_PATH;
    double speed = 1000.0;
    double max_minutes = 0.0;       /* 0 = whole file */
    int use_colour = 0, use_led = 0, quiet = 0;
    int is_test = 0;

    /* ---------- Command line ---------- */
    for (int a = 1; a < argc; a++) {
        if (strcmp(argv[a], "-f") == 0 && a + 1 < argc) {
            a++;
            if (strcmp(argv[a], "test") == 0) {
                path = TEST_PATH; is_test = 1;
            } else if (strcmp(argv[a], "dev") == 0) {
                path = DEV_PATH;
            } else if (strcmp(argv[a], "stress") == 0) {
                path = STRESS_PATH;
            } else {
                printf("Unknown file '%s' (use test, dev or stress)\n", argv[a]);
                return 1;
            }
        } else if (strcmp(argv[a], "-s") == 0 && a + 1 < argc) {
            speed = atof(argv[++a]);
            if (speed < 0.0) { printf("Speed must be >= 0\n"); return 1; }
        } else if (strcmp(argv[a], "-m") == 0 && a + 1 < argc) {
            max_minutes = atof(argv[++a]);
        } else if (strcmp(argv[a], "-n") == 0) {
            naive_mode = 1;
        } else if (strcmp(argv[a], "--parser") == 0 && a + 1 < argc) {
            const char *mode = argv[++a];
            if (strcmp(mode, "old") == 0) use_fast_parser = 0;
            else if (strcmp(mode, "fast") == 0) use_fast_parser = 1;
            else { printf("Parser must be old or fast\n"); return 1; }
        } else if (strcmp(argv[a], "--memory") == 0 && a + 1 < argc) {
            const char *mode = argv[++a];
            if (strcmp(mode, "fixed") == 0) use_malloc = 0;
            else if (strcmp(mode, "malloc") == 0) use_malloc = 1;
            else { printf("Memory must be fixed or malloc\n"); return 1; }
        } else if (strcmp(argv[a], "--threads") == 0 && a + 1 < argc) {
            num_threads = atoi(argv[++a]);
            if (num_threads < 1) { printf("Threads must be >= 1\n"); return 1; }
        } else if (strcmp(argv[a], "-c") == 0) {
            use_colour = 1;
        } else if (strcmp(argv[a], "-l") == 0) {
            use_led = 1;
        } else if (strcmp(argv[a], "-q") == 0) {
            quiet = 1;
        } else if (strcmp(argv[a], "-p") == 0) {
            want_pct = 1;
        } else if (strcmp(argv[a], "-o") == 0 && a + 1 < argc) {
            log_path = argv[++a];
        } else if (strcmp(argv[a], "-r") == 0 && a + 1 < argc) {
            double r_us = atof(argv[++a]);
            if (r_us <= 0.0) { printf("Rival time must be > 0\n"); return 1; }
            rival_ns = (uint64_t)(r_us * 1000.0 + 0.5);
        } else {
            printf("Usage: %s [-f test|dev|stress] [-s SPEED] [-m MINUTES] [-n] [-c] [-l] [-q] [-o FILE] [-r US] [-p] [--parser old|fast] [--memory fixed|malloc] [--threads N]\n", argv[0]);
            return 1;
        }
    }
    if (is_test) {
        short_win = TEST_SHORT;
        long_win = TEST_LONG;
    }
    enable_ansi();

    /* ---------- Benchmark includes BOTH file loading and replay. ---------- */
    uint64_t benchmark_start = now_ns();
    uint64_t load_start = benchmark_start;
    trade_count = load_trades_mt(path, num_threads);
    double load_s = (now_ns() - load_start) / 1e9;
    if (trade_count < 0) return 1;
    if (trade_count < long_win) {
        printf("Not enough trades (%lld) for the long window (%d)\n", trade_count, long_win);
        return 1;
    }

    /* How many trades to replay (for -m). */
    long long replay_n = trade_count;
    if (max_minutes > 0.0) {
        long long limit_us = (long long)(max_minutes * 60.0 * 1e6);
        long long k = 0;
        while (k < trade_count && trades[k].ts_us - trades[0].ts_us <= limit_us) k++;
        replay_n = k;
    }
    double market_span_s = (trades[replay_n - 1].ts_us - trades[0].ts_us) / 1e6;

    printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
           path, short_win, long_win, naive_mode ? "naive" : "running-sum",
           speed == 0.0 ? "unpaced" : "paced");
    printf("Parser: %s | Memory: %s | Threads: %d\n",
           use_fast_parser ? "custom" : "original sscanf",
           use_malloc ? "malloc" : "fixed array",
           num_threads);
    printf("Trades loaded: %lld (storage %.1f MiB)   load time %.3f s\n",
           trade_count, storage_bytes / 1048576.0, load_s);
    printf("Replaying %lld trades covering %.1f s of market time", replay_n, market_span_s);
    if (speed > 0.0) printf(" at %gx (about %.1f s)", speed, market_span_s / speed);
    printf("\n\n");

    if (use_led) led_init();
    rival_init(&rival);

    /* ---------- Replay ---------- */
    unsigned long long lat_sum = 0, lat_max = 0;
    unsigned long long proc_sum = 0, proc_max = 0;
    long long lag_max_ns = 0;
    long long lag_ns = 0;
    long long ts0 = trades[0].ts_us;

    /* -p only: one slot per replayed trade (allocated BEFORE the timed loop). */
    unsigned long long *lat_arr = NULL, *proc_arr = NULL;
    if (want_pct) {
        lat_arr = malloc((size_t)replay_n * sizeof *lat_arr);
        proc_arr = malloc((size_t)replay_n * sizeof *proc_arr);
        if (!lat_arr || !proc_arr) {
            printf("Could not allocate percentile arrays\n");
            return 1;
        }
    }

    uint64_t t_start = now_ns();
    uint64_t next_status = t_start + 1000000000ULL;

    for (long long i = 0; i < replay_n; i++) {
        /* 1. Scheduled release time of this trade. */
        uint64_t release;
        if (speed > 0.0) {
            long long gap_us = trades[i].ts_us - ts0;
            if (gap_us < 0) gap_us = 0;
            release = t_start + (uint64_t)((double)gap_us * 1000.0 / speed);
            wait_until(release);
        } else {
            release = now_ns();     /* unpaced: release = now */
        }

        /* 2. Process the trade; time only the engine. */
        uint64_t before = now_ns();
        int signal = engine_step(i);
        uint64_t decided = now_ns();

        uint64_t proc_ns = decided - before;
        uint64_t latency_ns = decided - release;
        lag_ns = (long long)(decided - release);

        lat_sum += latency_ns;
        if (latency_ns > lat_max) lat_max = latency_ns;
        proc_sum += proc_ns;
        if (proc_ns > proc_max) proc_max = proc_ns;
        if (lag_ns > lag_max_ns) lag_max_ns = lag_ns;
        if (lat_arr) { lat_arr[i] = latency_ns; proc_arr[i] = proc_ns; }

        /* 3. Signal: log it, then show it (outside the measured time). */
        if (signal != 0) {
            if (signal == 1) buy_count++; else sell_count++;
            log_signal(i, signal, proc_ns, latency_ns);
            /* Rival race: our reaction time is the processing time of this trade. */
            rival_on_signal(&rival, signal, trades[i].price,
                            (i + 1 < trade_count) ? trades[i + 1].price : trades[i].price,
                            proc_ns, rival_ns);
            if (use_colour || use_led) show_signal(signal, i, latency_ns, use_colour, use_led);
        }

        /* 4. Once-a-second status line with the lag counter. */
        if (!quiet && decided >= next_status) {
            printf("\r  replayed %5.1f%%  | lag %9.3f ms | BUY %lld SELL %lld | P&L %.2f   ",
                   100.0 * (i + 1) / replay_n, lag_ns / 1e6, buy_count, sell_count,
                   rival_pnl(&rival));
            fflush(stdout);
            next_status = decided + 1000000000ULL;
        }
    }

    uint64_t t_end = now_ns();
    /* Includes load, replay, and minimal fixed setup/summary overhead. */
    double benchmark_s = (t_end - benchmark_start) / 1e9;
    if (use_led) {
        led_off(LED_GREEN);
        led_off(LED_RED);
        led_cleanup();
    }
    if (!quiet) printf("\r%79s\r", "");

    /* ---------- Report ---------- */
    double wall_s = (t_end - t_start) / 1e9;
    double final_vwap = total_q > 0 ? (double)total_pq / (double)total_q / SCALE_P : 0.0;

    printf("\n--- Replay results ---\n");
    printf("Trades replayed      : %lld\n", replay_n);
    printf("Signals              : %lld BUY, %lld SELL\n", buy_count, sell_count);
    printf("Final VWAP           : %.8f\n", final_vwap);
    printf("Wall time            : %.3f s", wall_s);
    if (speed > 0.0) printf("   (ideal %.3f s)", market_span_s / speed);
    printf("\n");
    printf("Benchmark time       : %.6f s (load + replay; use for V0-V4)\n",
           benchmark_s);
    printf("Benchmark throughput : %.0f trades/s\n", replay_n / benchmark_s);
    printf("Processing per trade : avg %.1f ns, worst %.3f us\n",
           (double)proc_sum / replay_n, proc_max / 1000.0);
    printf("Latency per trade    : avg %.3f us, worst %.3f us\n",
           (double)lat_sum / replay_n / 1000.0, lat_max / 1000.0);
    printf("Lag behind replay    : worst %.3f ms, at end %.3f ms\n",
           lag_max_ns / 1e6, lag_ns / 1e6);
    printf("Rival bot (R = %.2f us): P&L %.2f USDT, races won %lld, lost %lld%s\n",
           rival_ns / 1000.0, rival_pnl(&rival), rival.races_won, rival.races_lost,
           rival.holding ? " (still holding 1 BTC)" : "");

    /* Percentiles: sorting happens here, after t_end, so it never affects the timings above. */
    if (want_pct) {
        printf("\n--- Percentile latency (%lld trades) ---\n", replay_n);
        print_percentiles("Processing per trade", proc_arr, replay_n);
        print_percentiles("Latency per trade", lat_arr, replay_n);
        free(proc_arr);
        free(lat_arr);
    }

    printf("\n--- Memory ---\n");
    printf("Selected storage (%s) : %.1f MiB for %lld trades\n",
           use_malloc ? "malloc" : "fixed", storage_bytes / 1048576.0, trade_count);
    printf("Stage B fixed array      : %.1f MiB reserved (MAX_TRADES = %d)\n",
           STAGE_B_MAX_TRADES * sizeof(Trade) / 1048576.0, STAGE_B_MAX_TRADES);
    print_memory();

    /* ---------- Signal log for the rival bot ---------- */
    FILE *log = fopen(log_path, "w");
    if (log != NULL) {
        fprintf(log, "trade_index,ts_us,price_fx,side,proc_ns,latency_ns\n");
        for (long long s = 0; s < sig_count; s++) {
            long long ti = sig_log[s].trade_index;
            fprintf(log, "%lld,%lld,%lld,%d,%llu,%llu\n", ti, trades[ti].ts_us,
                    trades[ti].price, sig_log[s].side, sig_log[s].proc_ns,
                    sig_log[s].latency_ns);
        }
        fclose(log);
        printf("\nWrote %lld signals to %s\n", sig_count, log_path);
    }

    free(sig_log);
    if (use_malloc) free(trades);
    return 0;
}