/*
 * vwap_bench.c - harness for the hand-written assembly stretch goal, Group 21
 *
 * Compares three implementations of the VWAP sums (sum of price*qty, sum of qty):
 *   C plain      : the simple loop (what the compiler optimises)
 *   C unrolled   : the same loop unrolled 4x by hand with 4 accumulators
 *   asm (AArch64): vwap_kernel_a64.S      (Pi only)
 * and checks that all give the identical integer result.
 *
 * Build on the Pi :  gcc -O3 -mcpu=cortex-a76 vwap_bench.c StageA+.c vwap_kernel_a64.S -o vwap_bench
 * Build on laptop :  gcc -O3 vwap_bench.c StageA+.c -o vwap_bench        (asm row is skipped)
 * Run             :  taskset -c 3 ./vwap_bench stress        (or: dev)
 */
#ifndef __USE_MINGW_ANSI_STDIO
#define __USE_MINGW_ANSI_STDIO 1
#endif
#include "timing.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include "StageA+.h"

#define REPS 7

typedef struct {
    long long ts_us;
    long long price;
    long long qty;
    int is_buy;
} Trade;

/* The assembly hard-codes these offsets, so fail the build if they ever change. */
_Static_assert(sizeof(Trade) == 32, "asm expects a 32-byte Trade");
_Static_assert(offsetof(Trade, price) == 8, "asm expects price at offset 8");
_Static_assert(offsetof(Trade, qty) == 16, "asm expects qty at offset 16");

#define BARRIER() __asm__ volatile("" ::: "memory")

#ifdef __aarch64__
extern void vwap_sums_a64(const Trade *t, long long n, long long *out_pq, long long *out_q);
#endif

static __attribute__((noinline)) void vwap_c_plain(const Trade *t, long long n,
                                                   long long *out_pq, long long *out_q)
{
    long long pq = 0, q = 0;
    for (long long i = 0; i < n; i++) {
        pq += t[i].price * t[i].qty;
        q += t[i].qty;
    }
    *out_pq = pq;
    *out_q = q;
}

static __attribute__((noinline)) void vwap_c_unrolled(const Trade *t, long long n,
                                                      long long *out_pq, long long *out_q)
{
    long long pq0 = 0, pq1 = 0, pq2 = 0, pq3 = 0, q = 0;
    long long i = 0;
    for (; i + 4 <= n; i += 4) {
        pq0 += t[i].price * t[i].qty;
        pq1 += t[i + 1].price * t[i + 1].qty;
        pq2 += t[i + 2].price * t[i + 2].qty;
        pq3 += t[i + 3].price * t[i + 3].qty;
        q += t[i].qty + t[i + 1].qty + t[i + 2].qty + t[i + 3].qty;
    }
    for (; i < n; i++) {
        pq0 += t[i].price * t[i].qty;
        q += t[i].qty;
    }
    *out_pq = pq0 + pq1 + pq2 + pq3;
    *out_q = q;
}

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

typedef void (*kernel_fn)(const Trade *, long long, long long *, long long *);

/* Run one kernel REPS times; return the median time in ms and its result. */
static double bench(kernel_fn fn, const Trade *t, long long n, long long *pq, long long *q)
{
    double ms[REPS];
    for (int r = 0; r < REPS; r++) {
        BARRIER();
        uint64_t t0 = now_ns();
        fn(t, n, pq, q);
        uint64_t t1 = now_ns();
        BARRIER();
        ms[r] = (t1 - t0) / 1e6;
    }
    qsort(ms, REPS, sizeof ms[0], cmp_double);
    return ms[REPS / 2];
}

int main(int argc, char *argv[])
{
    const char *path = "../DATABASE/stress_full.csv";
    if (argc >= 2 && strcmp(argv[1], "dev") == 0) path = "../DATABASE/dev_1M.csv";

    long long lines = count_lines(path);
    if (lines <= 0) { printf("Could not read %s\n", path); return 1; }
    Trade *t = malloc((size_t)lines * sizeof(Trade));
    if (!t) { printf("Out of memory\n"); return 1; }

    FILE *fp = fopen(path, "r");
    if (!fp) { printf("Could not open %s\n", path); return 1; }
    long long n = 0, ts, p, q;
    int is_buy;
    while (n < lines && read_trade_fixed(fp, &ts, &p, &q, &is_buy)) {
        t[n].ts_us = ts; t[n].price = p; t[n].qty = q; t[n].is_buy = is_buy;
        n++;
    }
    fclose(fp);

    printf("VWAP sums over %lld trades (%.1f MiB array), median of %d runs\n\n",
           n, n * sizeof(Trade) / 1048576.0, REPS);
    printf("%-16s %10s %10s %14s  %s\n", "Version", "ms", "ns/trade", "array GB/s", "matches C plain");

    long long ref_pq = 0, ref_q = 0;
    double ms = bench(vwap_c_plain, t, n, &ref_pq, &ref_q);
    printf("%-16s %10.3f %10.3f %14.2f  reference\n", "C plain", ms, ms * 1e6 / n,
           n * sizeof(Trade) / (ms * 1e6));
    double base_ms = ms;

    long long pq = 0, qq = 0;
    ms = bench(vwap_c_unrolled, t, n, &pq, &qq);
    printf("%-16s %10.3f %10.3f %14.2f  %s   (%.2fx vs C plain)\n", "C unrolled x4", ms, ms * 1e6 / n,
           n * sizeof(Trade) / (ms * 1e6), (pq == ref_pq && qq == ref_q) ? "yes" : "NO - BUG",
           base_ms / ms);

#ifdef __aarch64__
    ms = bench(vwap_sums_a64, t, n, &pq, &qq);
    printf("%-16s %10.3f %10.3f %14.2f  %s   (%.2fx vs C plain)\n", "asm AArch64", ms, ms * 1e6 / n,
           n * sizeof(Trade) / (ms * 1e6), (pq == ref_pq && qq == ref_q) ? "yes" : "NO - BUG",
           base_ms / ms);
#else
    printf("%-16s (not built: the assembly kernel only exists for AArch64 / the Pi)\n", "asm AArch64");
#endif

    printf("\nVWAP = %.8f USDT\n", (double)ref_pq / (double)ref_q / 100.0);
    free(t);
    return 0;
}