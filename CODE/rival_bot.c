/*
 * rival_bot.c - Rival bot simulation and R sweep (Stage C, step 6).
 *
 * Reads two signal logs written by StageC (-o option): one for Version 0 and
 * one for the fastest version. Both versions raise exactly the same signals,
 * so any P&L difference comes only from reaction time.
 *
 *   money lost = P&L(fastest version) - P&L(Version 0)
 *
 * The rival's reaction time R is swept from 0.1 us to 100 us (log spaced).
 *
 * Build : gcc -O2 rival_bot.c rival.c StageA+.c -o rival_bot
 * Usage : ./rival_bot DATA.csv LOG_V0.csv LOG_FAST.csv [SWEEP_OUT.csv]
 *         e.g. ./rival_bot ../DATABASE/stress_full.csv log_v0.csv log_fast.csv
 * Then  : gnuplot plot_rival     (draws money_lost.png from rival_sweep.csv)
 *
 * Log format (header line first):
 *   trade_index,ts_us,price_fx,side,proc_ns,latency_ns
 * trade_index is the 0-based index of the triggering trade in the data file.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "StageA+.h"
#include "rival.h"

typedef struct {
    long long idx;          /* triggering trade, 0-based */
    int side;               /* 1 BUY, -1 SELL */
    unsigned long long proc_ns;
} Sig;

typedef struct {
    Sig *s;
    long long n;
} SigLog;

/* Load every trade's price (fixed-point) into a malloc'd array. */
static long long *load_prices(const char *path, long long *count)
{
    FILE *fp = fopen(path, "r");
    if (fp == NULL) { perror(path); return NULL; }

    long long cap = 1 << 20, n = 0;
    long long *p = malloc((size_t)cap * sizeof *p);
    long long ts, price, qty;
    int is_buy;

    while (p != NULL && read_trade_fixed(fp, &ts, &price, &qty, &is_buy)) {
        if (n == cap) {
            cap *= 2;
            long long *bigger = realloc(p, (size_t)cap * sizeof *p);
            if (bigger == NULL) { free(p); p = NULL; break; }
            p = bigger;
        }
        p[n++] = price;
    }
    fclose(fp);
    if (p == NULL) { printf("Out of memory loading prices\n"); return NULL; }
    *count = n;
    return p;
}

/* Load a signal log written by StageC. Returns 0 on success. */
static int load_log(const char *path, SigLog *log)
{
    FILE *fp = fopen(path, "r");
    if (fp == NULL) { perror(path); return 1; }

    char line[256];
    long long cap = 4096;
    log->s = malloc((size_t)cap * sizeof *log->s);
    log->n = 0;
    if (log->s == NULL) { fclose(fp); return 1; }

    if (fgets(line, sizeof line, fp) == NULL) { fclose(fp); return 1; }  /* header */

    while (fgets(line, sizeof line, fp) != NULL) {
        long long idx, ts, price_fx, lat;
        int side;
        unsigned long long proc;
        if (sscanf(line, "%lld,%lld,%lld,%d,%llu,%lld",
                   &idx, &ts, &price_fx, &side, &proc, &lat) != 6) continue;
        if (log->n == cap) {
            cap *= 2;
            Sig *bigger = realloc(log->s, (size_t)cap * sizeof *log->s);
            if (bigger == NULL) { fclose(fp); return 1; }
            log->s = bigger;
        }
        log->s[log->n].idx = idx;
        log->s[log->n].side = side;
        log->s[log->n].proc_ns = proc;
        log->n++;
    }
    fclose(fp);
    return 0;
}

static int cmp_u64(const void *a, const void *b)
{
    unsigned long long x = *(const unsigned long long *)a;
    unsigned long long y = *(const unsigned long long *)b;
    return (x > y) - (x < y);
}

/* Print median and worst reaction time of one log. Returns the max in ns. */
static unsigned long long describe(const char *name, const SigLog *log)
{
    unsigned long long *tmp = malloc((size_t)(log->n ? log->n : 1) * sizeof *tmp);
    unsigned long long max = 0;
    if (tmp == NULL) return 0;
    for (long long i = 0; i < log->n; i++) tmp[i] = log->s[i].proc_ns;
    qsort(tmp, (size_t)log->n, sizeof *tmp, cmp_u64);
    if (log->n > 0) max = tmp[log->n - 1];
    printf("%-10s signals %lld | reaction time: median %.3f us, worst %.3f us\n",
           name, log->n, log->n ? tmp[log->n / 2] / 1000.0 : 0.0, max / 1000.0);
    free(tmp);
    return max;
}

/* Run one version's signals against a rival with reaction time rival_ns. */
static RivalState simulate(const SigLog *log, const long long *prices,
                           long long n_prices, uint64_t rival_ns)
{
    RivalState r;
    rival_init(&r);
    for (long long k = 0; k < log->n; k++) {
        long long i = log->s[k].idx;
        if (i < 0 || i >= n_prices) continue;
        long long now = prices[i];
        long long next = (i + 1 < n_prices) ? prices[i + 1] : now;
        rival_on_signal(&r, log->s[k].side, now, next,
                        log->s[k].proc_ns, rival_ns);
    }
    return r;
}

int main(int argc, char *argv[])
{
    if (argc < 4) {
        printf("Usage: %s DATA.csv LOG_V0.csv LOG_FAST.csv [SWEEP_OUT.csv]\n", argv[0]);
        return 1;
    }
    const char *out_path = (argc >= 5) ? argv[4] : "rival_sweep.csv";

    long long n_prices = 0;
    long long *prices = load_prices(argv[1], &n_prices);
    if (prices == NULL) return 1;

    SigLog v0 = {0}, fast = {0};
    if (load_log(argv[2], &v0) || load_log(argv[3], &fast)) {
        printf("Could not read a signal log\n");
        return 1;
    }
    if (v0.n != fast.n) {
        printf("Warning: the logs hold different signal counts (%lld vs %lld).\n"
               "Both versions must raise the same signals.\n", v0.n, fast.n);
    }

    printf("Trades in data file: %lld\n", n_prices);
    unsigned long long max_v0 = describe("Version 0", &v0);
    unsigned long long max_fast = describe("Fastest", &fast);

    FILE *out = fopen(out_path, "w");
    if (out == NULL) { perror(out_path); return 1; }
    fprintf(out, "R_us,pnl_v0,pnl_fast,money_lost,lost_races_v0,lost_races_fast\n");

    printf("\n%8s %14s %14s %14s %10s %10s\n", "R (us)", "P&L V0", "P&L fast",
           "money lost", "V0 lost", "fast lost");

    /* 0.1 us .. 100 us, 10 points per decade (31 points). */
    for (int k = 0; k <= 30; k++) {
        double r_us = 0.1 * pow(10.0, k / 10.0);
        uint64_t rival_ns = (uint64_t)(r_us * 1000.0 + 0.5);

        RivalState a = simulate(&v0, prices, n_prices, rival_ns);
        RivalState b = simulate(&fast, prices, n_prices, rival_ns);
        double lost = rival_pnl(&b) - rival_pnl(&a);

        fprintf(out, "%.4f,%.2f,%.2f,%.2f,%lld,%lld\n", r_us, rival_pnl(&a),
                rival_pnl(&b), lost, a.races_lost, b.races_lost);
        printf("%8.3f %14.2f %14.2f %14.2f %10lld %10lld\n", r_us, rival_pnl(&a),
               rival_pnl(&b), lost, a.races_lost, b.races_lost);
    }
    fclose(out);

    /* A version beats the rival on every signal once R exceeds its worst
     * reaction time; below its median it loses at least half the races. */
    printf("\nVersion 0 wins every race once R > %.3f us; fastest once R > %.3f us.\n",
           max_v0 / 1000.0, max_fast / 1000.0);
    printf("Note: P&L is sells - buys, so an open position at the end counts as a cost.\n");
    printf("Sweep written to %s (plot with: gnuplot plot_rival)\n", out_path);

    free(v0.s);
    free(fast.s);
    free(prices);
    return 0;
}