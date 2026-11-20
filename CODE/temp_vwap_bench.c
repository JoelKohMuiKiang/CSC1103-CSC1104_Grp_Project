/*
 * vwap_bench.c - harness for the hand-written assembly stretch goal, Group 21
   this is to be executed by Pi: 'gcc -O3 -mcpu=cortex=a76 vwap_bench.c StageA+.c vwap_kernel_a64.S -o vwap_bench'
 *
 * Compares three implementations of the VWAP sums (sum of price*qty, sum of qty):
 *   C plain      : the simple loop (what the compiler optimises)
 *   C unrolled   : the same loop unrolled 4x by hand with 4 accumulators
 *   asm (AArch64): vwap_kernel_a64.S      (Pi only)
 * across two regimes:
 *   1. Full dataset (out-of-cache / DRAM bandwidth bound)
 *   2. 4,096-trade slice x 100,000 iterations (in-cache / compute bound)
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
#define CACHE_SLICE_N 4096LL     /* 4096 * 32 B = 128 KiB (fits in Cortex-A76 512 KiB L2 cache) */
#define CACHE_ITERS   100000     /* Amplifies runtime to isolate CPU pipeline throughput */

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

/* Run one kernel 'iters' times per rep across REPS; return median time in ms. */
static double bench(kernel_fn fn, const Trade *t, long long n, int iters,
                    long long *pq, long long *q)
{
    double ms[REPS];
    long long tmp_pq = 0, tmp_q = 0;

    /* Warmup cache */
    fn(t, n, &tmp_pq, &tmp_q);

    for (int r = 0; r < REPS; r++) {
        long long sink_pq = 0, sink_q = 0;
        BARRIER();
        uint64_t t0 = now_ns();
        for (int it = 0; it < iters; it++) {
            fn(t, n, &tmp_pq, &tmp_q);
            sink_pq += tmp_pq;
            sink_q += tmp_q;
            BARRIER();
        }
        uint64_t t1 = now_ns();
        BARRIER();

        /* Keep sink live so GCC cannot optimize away the iteration loop */
        volatile long long keep = sink_pq ^ sink_q;
        (void)keep;

        ms[r] = (t1 - t0) / 1e6;
    }
    *pq = tmp_pq;
    *q = tmp_q;
    qsort(ms, REPS, sizeof ms[0], cmp_double);
    return ms[REPS / 2];
}

static void run_suite(const char *label, const Trade *t, long long n, int iters)
{
    double total_trades = (double)n * iters;
    double total_bytes  = total_trades * sizeof(Trade);

    printf("=== %s (%lld trades x %d iters = %.1f KiB working set, median of %d) ===\n",
           label, n, iters, (n * sizeof(Trade)) / 1024.0, REPS);
    printf("%-16s %10s %10s %14s  %s\n", "Version", "ms", "ns/trade", "eff. GB/s", "matches C plain");

    long long ref_pq = 0, ref_q = 0;
    double ms = bench(vwap_c_plain, t, n, iters, &ref_pq, &ref_q);
    printf("%-16s %10.3f %10.3f %14.2f  reference\n", "C plain", ms, (ms * 1e6) / total_trades,
           total_bytes / (ms * 1e6));
    double base_ms = ms;

    long long pq = 0, qq = 0;
    ms = bench(vwap_c_unrolled, t, n, iters, &pq, &qq);
    printf("%-16s %10.3f %10.3f %14.2f  %s   (%.2fx vs C plain)\n", "C unrolled x4",
           ms, (ms * 1e6) / total_trades, total_bytes / (ms * 1e6),
           (pq == ref_pq && qq == ref_q) ? "yes" : "NO - BUG", base_ms / ms);

#ifdef __aarch64__
    ms = bench(vwap_sums_a64, t, n, iters, &pq, &qq);
    printf("%-16s %10.3f %10.3f %14.2f  %s   (%.2fx vs C plain)\n", "asm AArch64",
           ms, (ms * 1e6) / total_trades, total_bytes / (ms * 1e6),
           (pq == ref_pq && qq == ref_q) ? "yes" : "NO - BUG", base_ms / ms);
#else
    printf("%-16s (not built: the assembly kernel only exists for AArch64 / the Pi)\n", "asm AArch64");
#endif
    printf("\n");
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

    /* 1. Out-of-Cache: Full dataset (DRAM bandwidth bound) */
    long long full_pq = 0, full_q = 0;
    vwap_c_plain(t, n, &full_pq, &full_q);
    run_suite("OUT-OF-CACHE (Full CSV)", t, n, 1);

    /* 2. In-Cache: First 4,096 trades repeated 100,000x (CPU pipeline bound) */
    long long slice_n = (n < CACHE_SLICE_N) ? n : CACHE_SLICE_N;
    run_suite("IN-CACHE (L1/L2 Hot Slice)", t, slice_n, CACHE_ITERS);

    printf("Full CSV VWAP = %.8f USDT\n", (double)full_pq / (double)full_q / 100.0);
    free(t);
    return 0;
}