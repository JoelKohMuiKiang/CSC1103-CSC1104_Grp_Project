/*
 * StageB.c - In-memory engine (Stage B), Group 21
 *
 * Loads every trade into a global array of structs (fixed-point integers),
 * then computes VWAP, short/long SMA and BUY/SELL crossover signals.
 *
 * Build : gcc -O2 StageB.c StageA+.c -o StageB
 *
 * Usage : ./StageB test  [naive]    20 trades, windows 3/5, prints the table
 *         ./StageB dev   [naive]    dev_1M.csv, group windows
 *         ./StageB stress [naive]   stress_full.csv, group windows (benchmark)
 *         ./StageB plot [start]     2000-trade slice of dev_1M.csv -> signals.dat
 *
 * Run from the CODE folder (data is read from ../DATABASE).
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <time.h>
#include "StageA+.h"

/* ---------- Window sizes ---------- */
#define GROUP_SHORT 40          /* Group 21 */
#define GROUP_LONG  200
#define TEST_SHORT  3           /* test20.csv always uses 3 / 5 */
#define TEST_LONG   5
#define PLOT_TRADES 2000

/* ---------- Data files ---------- */
#define TEST_PATH   "../DATABASE/test20.csv"
#define DEV_PATH    "../DATABASE/dev_1M.csv"
#define STRESS_PATH "../DATABASE/stress_full.csv"

/* ---------- Capacity ----------
 * stress_full.csv has 8,928,944 trades, so the array must be larger than that. */
#define MAX_TRADES 10000000

/* ---------- Fixed-point scales ----------
 * Price has 2 significant decimals -> x100.
 * Qty has 5 significant decimals   -> x100000.
 * price*qty therefore carries a scale of 10^7.
 * Worst case: whole-day traded value is about 3.4e9 USDT, which becomes
 * 3.4e16 and fits in a long long (max about 9.2e18). */
#define SCALE_P 100LL
#define SCALE_Q 100000LL
#define SCALE_PQ (SCALE_P * SCALE_Q)

/* One trade. Fixed-point integers instead of doubles. */
typedef struct {
    long long ts_us;     /* real timestamp, microseconds since 1970 */
    long long price;     /* price x SCALE_P */
    long long qty;       /* qty x SCALE_Q */
    int is_buy;          /* 1 = buy (isBuyerMaker False), 0 = sell */
} Trade;

/* Global array: lives outside the stack so millions of trades fit. */
static Trade trades[MAX_TRADES];
static long long trade_count = 0;

/* Wall-clock helper for timing. */
static double get_time_sec(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec + ts.tv_nsec * 1e-9;
}

/*
 * load_trades: read the whole file into trades[] using our own fixed-point parser.
 * Returns the number of trades, or -1 on error.
 * Also checks (once, outside the processing loop) that the VWAP accumulators
 * cannot overflow a long long.
 */
static long long load_trades(const char *path)
{
    FILE *fp = fopen(path, "r");
    if (fp == NULL) {
        printf("Could not open %s\n", path);
        return -1;
    }

    long long ts, price, qty;
    int is_buy;
    long long n = 0;
    __int128 pq_total = 0;          /* wide accumulator used only for this check */
    __int128 q_total = 0;

    while (read_trade_fixed(fp, &ts, &price, &qty, &is_buy)) {
        if (n >= MAX_TRADES) {
            printf("Error: file has more than MAX_TRADES (%d) trades\n", MAX_TRADES);
            fclose(fp);
            return -1;
        }
        trades[n].ts_us = ts;
        trades[n].price = price;
        trades[n].qty = qty;
        trades[n].is_buy = is_buy;
        pq_total += (__int128)price * qty;
        q_total += qty;
        n++;
    }
    fclose(fp);

    if (pq_total > LLONG_MAX || q_total > LLONG_MAX) {
        printf("Error: fixed-point scales are too large, VWAP sums would overflow\n");
        return -1;
    }
    return n;
}

int main(int argc, char *argv[])
{
    const char *path = TEST_PATH;
    int short_win = TEST_SHORT;
    int long_win = TEST_LONG;
    int plotting = 0;
    int naive_mode = 0;
    int print_table = 0;
    long long plot_start = 1;

    /* ---------- Command line ---------- */
    if (argc < 2) {
        printf("Usage: %s test|dev|stress [naive]\n       %s plot [start_trade]\n", argv[0], argv[0]);
        return 1;
    }
    if (strcmp(argv[1], "test") == 0) {
        print_table = 1;
    } else if (strcmp(argv[1], "dev") == 0) {
        path = DEV_PATH;
        short_win = GROUP_SHORT;
        long_win = GROUP_LONG;
    } else if (strcmp(argv[1], "stress") == 0) {
        path = STRESS_PATH;
        short_win = GROUP_SHORT;
        long_win = GROUP_LONG;
    } else if (strcmp(argv[1], "plot") == 0) {
        plotting = 1;
        path = DEV_PATH;
        short_win = GROUP_SHORT;
        long_win = GROUP_LONG;
        if (argc >= 3) {
            plot_start = atoll(argv[2]);
            if (plot_start < 1) {
                printf("Plot start trade must be at least 1.\n");
                return 1;
            }
        }
    } else {
        printf("Unknown mode '%s'\n", argv[1]);
        return 1;
    }
    if (argc >= 3 && strcmp(argv[2], "naive") == 0) {
        naive_mode = 1;
    }

    /* ---------- STEP 1: load into memory ---------- */
    double t_load_start = get_time_sec();
    trade_count = load_trades(path);
    double t_load_end = get_time_sec();
    if (trade_count < 0) {
        return 1;
    }
    if (trade_count < long_win) {
        printf("Not enough trades (%lld) for the long window (%d)\n", trade_count, long_win);
        return 1;
    }

    FILE *out = NULL;
    if (plotting) {
        out = fopen("signals.dat", "w");
        if (out == NULL) {
            printf("Could not create signals.dat\n");
            return 1;
        }
    }

    if (print_table) {
        printf("Stage B (fixed-point) test20.csv, short window = %d, long window = %d [%s SMA]\n",
               short_win, long_win, naive_mode ? "NAIVE" : "RUNNING-SUM");
        printf("is_buy = 1 when isBuyerMaker is False\n\n");
        printf("%-6s %-15s %-12s %-6s %-15s %-15s %-15s %s\n",
               "trade", "price", "qty", "is_buy", "VWAP", "SMA_short", "SMA_long", "signal");
    }

    /* ---------- State ---------- */
    long long total_pq = 0;         /* sum of price*qty, scale SCALE_PQ */
    long long total_q = 0;          /* sum of qty, scale SCALE_Q */
    long long short_sum = 0;        /* running window sums, scale SCALE_P */
    long long long_sum = 0;
    long long prev_d = 0;           /* previous (scaled) short-long difference */
    int have_prev = 0;
    long long buy_count = 0;
    long long sell_count = 0;
    long long plot_rows = 0, plot_buys = 0, plot_sells = 0;

    /* ---------- STEP 2: process from memory ---------- */
    double t_proc_start = get_time_sec();

    for (long long i = 0; i < trade_count; i++) {
        long long p = trades[i].price;
        long long q = trades[i].qty;

        /* 1. VWAP: two running integer sums, divide only when printing. */
        total_pq += p * q;
        total_q += q;

        /* 2. SMA window sums. */
        if (naive_mode) {
            /* Naive: re-add the whole window for every trade. */
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
            /* Running sum: one add, one subtract. The oldest price is still in
             * trades[], so no separate circular buffer is needed here. */
            short_sum += p;
            if (i >= short_win) short_sum -= trades[i - short_win].price;
            long_sum += p;
            if (i >= long_win) long_sum -= trades[i - long_win].price;
        }

        int have_short = (i >= short_win - 1);
        int have_long = (i >= long_win - 1);

        /* 3. Crossover. d = short_sum/short_win - long_sum/long_win.
         * Multiplying by short_win*long_win (positive) keeps the sign and avoids
         * integer division, so the comparison is exact (no truncation). */
        int signal = 0;
        if (have_short && have_long) {
            long long d = short_sum * long_win - long_sum * short_win;
            if (have_prev) {
                if (prev_d <= 0 && d > 0) {
                    signal = 1;
                    buy_count++;
                } else if (prev_d >= 0 && d < 0) {
                    signal = -1;
                    sell_count++;
                }
            }
            prev_d = d;
            have_prev = 1;
        }

        /* 4. Output (only in test and plot modes; never while benchmarking). */
        if (print_table) {
            double vwap = (double)total_pq / (double)total_q / SCALE_P;
            char s_str[32], l_str[32];
            if (have_short) sprintf(s_str, "%.8f", (double)short_sum / short_win / SCALE_P);
            else strcpy(s_str, "-");
            if (have_long) sprintf(l_str, "%.8f", (double)long_sum / long_win / SCALE_P);
            else strcpy(l_str, "-");
            printf("%-6lld %-15.8f %-12.8f %-6d %-15.8f %-15s %-15s %s\n",
                   i + 1, (double)p / SCALE_P, (double)q / SCALE_Q, trades[i].is_buy, vwap,
                   s_str, l_str, signal == 1 ? "BUY" : (signal == -1 ? "SELL" : ""));
        }

        if (plotting && have_long && i + 1 >= plot_start && i + 1 < plot_start + PLOT_TRADES) {
            fprintf(out, "%lld %.2f %.4f %.4f %d\n", i + 1, (double)p / SCALE_P,
                    (double)short_sum / short_win / SCALE_P,
                    (double)long_sum / long_win / SCALE_P, signal);
            plot_rows++;
            if (signal == 1) plot_buys++;
            else if (signal == -1) plot_sells++;
        }
    }

    double t_proc_end = get_time_sec();
    if (out != NULL) fclose(out);

    /* ---------- Summary ---------- */
    double final_vwap = (total_q > 0) ? (double)total_pq / (double)total_q / SCALE_P : 0.0;
    double load_s = t_load_end - t_load_start;
    double proc_s = t_proc_end - t_proc_start;

    printf("\nTrades loaded        : %lld\n", trade_count);
    printf("Windows (short/long) : %d / %d  [%s]\n", short_win, long_win,
           naive_mode ? "naive" : "running-sum");
    printf("Final VWAP           : %.8f\n", final_vwap);
    printf("Signals              : %lld BUY, %lld SELL\n", buy_count, sell_count);
    if (plotting) {
        printf("Rows in signals.dat  : %lld (BUY %lld, SELL %lld) starting at trade %lld\n",
               plot_rows, plot_buys, plot_sells, plot_start);
    }
    printf("\n--- Execution Timing ---\n");
    printf("Load time            : %.6f s\n", load_s);
    printf("Processing time      : %.6f s  (%.1f ns/trade, %.2f M trades/s)\n",
           proc_s, proc_s * 1e9 / trade_count, trade_count / proc_s / 1e6);
    printf("Total time           : %.6f s\n", t_proc_end - t_load_start);
    printf("Trade array memory   : %.1f MB static (%zu bytes/trade), %.1f MB used\n",
           sizeof(trades) / 1048576.0, sizeof(Trade), trade_count * sizeof(Trade) / 1048576.0);

    return 0;
}
