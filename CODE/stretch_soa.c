/*
 * stretch_soa.c - Struct-of-Arrays versus Array-of-Structs (stretch goal), Group 21
 *
 * AoS  : Trade trades[N]   -> one 32-byte struct per trade (ts, price, qty, is_buy)
 * SoA  : long long price[N], qty[N]   -> one array per field
 *
 * The same three kernels run on both layouts, each REPS times (median reported):
 *   1. price sum   : reads ONE field   (price)       - AoS uses 8 of every 32 bytes
 *   2. VWAP sums   : reads TWO fields  (price, qty)  - AoS uses 16 of every 32 bytes
 *   3. full engine : VWAP + running-sum SMA + crossover (what Stage B/C do)
 * Results must be identical; the program checks that.
 *
 * Build : gcc -O3 stretch_soa.c StageA+.c -o stretch_soa          (add -mcpu=cortex-a76 on the Pi)
 * Run   : ./stretch_soa stress      (or: dev)       from the CODE folder
 * Pi    : taskset -c 3 perf stat -e cycles,instructions,cache-misses ./stretch_soa stress
 */
#ifndef __USE_MINGW_ANSI_STDIO
#define __USE_MINGW_ANSI_STDIO 1     /* Windows: reliable %lld */
#endif
#include "timing.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "StageA+.h"

#define SHORT_WIN 40                 /* Group 21 */
#define LONG_WIN  200
#define REPS      5

/* Array-of-structs layout (same as Stage B / C). 32 bytes: two trades per 64-byte cache line. */
typedef struct {
    long long ts_us;
    long long price;                 /* price x 100 */
    long long qty;                   /* qty x 100000 */
    int is_buy;
} Trade;

typedef struct { long long a, b, c, d; } Result;   /* kernel outputs, compared AoS vs SoA */

/* Compiler barrier: stops gcc from hoisting a repeated call out of the timing loop. */
#define BARRIER() __asm__ volatile("" ::: "memory")

/* ------------------------------------------------------------------ */
/* Kernel 1: sum of prices                                             */
/* ------------------------------------------------------------------ */
static __attribute__((noinline)) void k1_aos(const Trade *t, long long n, Result *r)
{
    long long s = 0;
    for (long long i = 0; i < n; i++) s += t[i].price;
    r->a = s;
}
static __attribute__((noinline)) void k1_soa(const long long *price, long long n, Result *r)
{
    long long s = 0;
    for (long long i = 0; i < n; i++) s += price[i];
    r->a = s;
}

/* ------------------------------------------------------------------ */
/* Kernel 2: VWAP sums (sum of price*qty, sum of qty)                  */
/* ------------------------------------------------------------------ */
static __attribute__((noinline)) void k2_aos(const Trade *t, long long n, Result *r)
{
    long long pq = 0, q = 0;
    for (long long i = 0; i < n; i++) { pq += t[i].price * t[i].qty; q += t[i].qty; }
    r->a = pq; r->b = q;
}
static __attribute__((noinline)) void k2_soa(const long long *price, const long long *qty,
                                             long long n, Result *r)
{
    long long pq = 0, q = 0;
    for (long long i = 0; i < n; i++) { pq += price[i] * qty[i]; q += qty[i]; }
    r->a = pq; r->b = q;
}

/* ------------------------------------------------------------------ */
/* Kernel 3: full engine (same maths as Stage B running-sum mode)      */
/* ------------------------------------------------------------------ */
static __attribute__((noinline)) void k3_aos(const Trade *t, long long n, Result *r)
{
    long long total_pq = 0, total_q = 0, ss = 0, ls = 0, prev_d = 0, buy = 0, sell = 0;
    int have_prev = 0;
    for (long long i = 0; i < n; i++) {
        long long p = t[i].price, q = t[i].qty;
        total_pq += p * q;
        total_q += q;
        ss += p; if (i >= SHORT_WIN) ss -= t[i - SHORT_WIN].price;
        ls += p; if (i >= LONG_WIN)  ls -= t[i - LONG_WIN].price;
        if (i >= LONG_WIN - 1) {                          /* both windows full */
            long long d = ss * LONG_WIN - ls * SHORT_WIN;
            if (have_prev) {
                if (prev_d <= 0 && d > 0) buy++;
                else if (prev_d >= 0 && d < 0) sell++;
            }
            prev_d = d; have_prev = 1;
        }
    }
    r->a = buy; r->b = sell; r->c = total_pq; r->d = total_q;
}
static __attribute__((noinline)) void k3_soa(const long long *price, const long long *qty,
                                             long long n, Result *r)
{
    long long total_pq = 0, total_q = 0, ss = 0, ls = 0, prev_d = 0, buy = 0, sell = 0;
    int have_prev = 0;
    for (long long i = 0; i < n; i++) {
        long long p = price[i], q = qty[i];
        total_pq += p * q;
        total_q += q;
        ss += p; if (i >= SHORT_WIN) ss -= price[i - SHORT_WIN];
        ls += p; if (i >= LONG_WIN)  ls -= price[i - LONG_WIN];
        if (i >= LONG_WIN - 1) {
            long long d = ss * LONG_WIN - ls * SHORT_WIN;
            if (have_prev) {
                if (prev_d <= 0 && d > 0) buy++;
                else if (prev_d >= 0 && d < 0) sell++;
            }
            prev_d = d; have_prev = 1;
        }
    }
    r->a = buy; r->b = sell; r->c = total_pq; r->d = total_q;
}

/* ------------------------------------------------------------------ */
/* Helpers                                                             */
/* ------------------------------------------------------------------ */
static long long count_lines(const char *path)
{
    FILE *fp = fopen(path, "rb");
    if (!fp) return -1;
    static char buf[1 << 20];
    long long lines = 0;
    size_t n, last = '\n';
    while ((n = fread(buf, 1, sizeof buf, fp)) > 0) {
        for (size_t k = 0; k < n; k++) if (buf[k] == '\n') lines++;
        last = (unsigned char)buf[n - 1];
    }
    fclose(fp);
    if (last != '\n') lines++;
    return lines;
}

static int cmp_double(const void *x, const void *y)
{
    double a = *(const double *)x, b = *(const double *)y;
    return (a > b) - (a < b);
}
static double median(double *v, int n)
{
    qsort(v, (size_t)n, sizeof v[0], cmp_double);
    return v[n / 2];
}
static int same(const Result *x, const Result *y, int fields)
{
    if (x->a != y->a) return 0;
    if (fields >= 2 && x->b != y->b) return 0;
    if (fields >= 3 && (x->c != y->c || x->d != y->d)) return 0;
    return 1;
}

int main(int argc, char *argv[])
{
    const char *path = "../DATABASE/stress_full.csv";
    if (argc >= 2 && strcmp(argv[1], "dev") == 0) path = "../DATABASE/dev_1M.csv";

    /* ---------- load once into the AoS array, then copy the fields into SoA ---------- */
    long long lines = count_lines(path);
    if (lines <= 0) { printf("Could not read %s\n", path); return 1; }
    Trade *aos = malloc((size_t)lines * sizeof(Trade));
    long long *price = malloc((size_t)lines * sizeof(long long));
    long long *qty = malloc((size_t)lines * sizeof(long long));
    if (!aos || !price || !qty) { printf("Out of memory\n"); return 1; }

    FILE *fp = fopen(path, "r");
    if (!fp) { printf("Could not open %s\n", path); return 1; }
    long long n = 0, ts, p, q;
    int is_buy;
    while (n < lines && read_trade_fixed(fp, &ts, &p, &q, &is_buy)) {
        aos[n].ts_us = ts; aos[n].price = p; aos[n].qty = q; aos[n].is_buy = is_buy;
        price[n] = p; qty[n] = q;                       /* SoA copy (not timed) */
        n++;
    }
    fclose(fp);
    if (n < LONG_WIN + 1) { printf("Not enough trades\n"); return 1; }

    printf("Stage B engine, AoS vs SoA on %s\n", path);
    printf("Trades: %lld | AoS array: %.1f MiB | SoA price+qty: %.1f MiB | windows %d/%d | %d runs, median\n\n",
           n, n * sizeof(Trade) / 1048576.0, 2.0 * n * sizeof(long long) / 1048576.0,
           SHORT_WIN, LONG_WIN, REPS);

    static const char *names[3] = { "price sum (1 field)", "VWAP sums (2 fields)", "full engine" };
    static const int fields[3] = { 1, 2, 3 };
    static const char *bytes_used[3] = { "8 of 32 B", "16 of 32 B", "16 of 32 B" };

    printf("%-22s %-11s %12s %12s %9s  %s\n", "Kernel", "AoS uses", "AoS (ms)", "SoA (ms)", "speedup", "same result");
    for (int k = 0; k < 3; k++) {
        double ta[REPS], ts_[REPS];
        Result ra = {0, 0, 0, 0}, rs = {0, 0, 0, 0};
        for (int run = 0; run < REPS; run++) {
            BARRIER();
            uint64_t t0 = now_ns();
            if (k == 0) k1_aos(aos, n, &ra);
            else if (k == 1) k2_aos(aos, n, &ra);
            else k3_aos(aos, n, &ra);
            uint64_t t1 = now_ns();
            BARRIER();
            if (k == 0) k1_soa(price, n, &rs);
            else if (k == 1) k2_soa(price, qty, n, &rs);
            else k3_soa(price, qty, n, &rs);
            uint64_t t2 = now_ns();
            BARRIER();
            ta[run] = (t1 - t0) / 1e6;
            ts_[run] = (t2 - t1) / 1e6;
        }
        double ma = median(ta, REPS), ms = median(ts_, REPS);
        printf("%-22s %-11s %12.3f %12.3f %8.2fx  %s\n", names[k], bytes_used[k], ma, ms,
               ma / ms, same(&ra, &rs, fields[k]) ? "yes" : "NO - BUG");
        if (k == 2)
            printf("\nfull engine result: %lld BUY, %lld SELL, VWAP %.8f\n",
                   ra.a, ra.b, (double)ra.c / (double)ra.d / 100.0);
    }

    free(aos); free(price); free(qty);
    return 0;
}