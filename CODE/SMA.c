#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "trade_io.h"

#define SHORT_WINDOW 3
#define LONG_WINDOW 5
#define PLOT_TRADES 2000
#define MAX_TRADES 5000000 /* Adjust array size based on dataset capacity */

/* Trade struct definition */
typedef struct {
    long long trade_no;
    long long price;
    double qty;
    int is_buy;
} Trade;

/* Fixed-size global array to hold all trades in memory */
static Trade trades[MAX_TRADES];
static long long trade_count = 0;

/* Helper function to measure time in seconds */
double get_time_sec(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec + ts.tv_nsec * 1e-9;
}

int main(int argc, char *argv[])
{
    int plotting = 0;
    long long plot_start = 1;
    int naive_mode = 0;

    /* Parse CLI options: test, plot, naive */
    if (argc >= 2 && strcmp(argv[1], "plot") == 0) {
        plotting = 1;
        if (argc >= 3) {
            plot_start = atoll(argv[2]);
            if (plot_start < 1) {
                printf("Plot start trade must be at least 1.\n");
                return 1;
            }
        }
    } else if (argc >= 2 && strcmp(argv[1], "naive") == 0) {
        naive_mode = 1;
    } else if (argc >= 2 && strcmp(argv[1], "test") != 0) {
        printf("Usage: %s [test|naive]\n", argv[0]);
        printf("       %s plot [start_trade]\n", argv[0]);
        return 1;
    }

    /* Open dataset using trade_io library */
    if (!open_data(plotting ? DEV : TEST20)) {
        return 1;
    }

    /* ----------------------------------------------------
     * STEP 1: Load all trades into the in-memory array
     * ---------------------------------------------------- */
    double t_load_start = get_time_sec();
    while (next_trade()) {
        if (trade_count >= MAX_TRADES) {
            printf("Warning: Exceeded MAX_TRADES capacity (%d)\n", MAX_TRADES);
            break;
        }
        trades[trade_count].trade_no = trade_number();
        trades[trade_count].price = trade_price();
        trades[trade_count].qty = trade_qty();
        trades[trade_count].is_buy = trade_is_buy();
        trade_count++;
    }
    close_trades();
    double t_load_end = get_time_sec();

    FILE *out = NULL;
    if (plotting) {
        out = fopen("signals.dat", "w");
        if (out == NULL) {
            printf("Could not create signals.dat\n");
            return 1;
        }
    }

    /* Output header when in test/naive mode */
    if (!plotting) {
        printf("Expected answers for test20.csv (short window = %d, long window = %d) [%s SMA]\n", 
               SHORT_WINDOW, LONG_WINDOW, naive_mode ? "NAIVE" : "RUNNING-SUM");
        printf("is_buy = 1 when isBuyerMaker is False\n");
        printf("SMA values start once the window is full; signals start once both SMAs exist for two trades in a row\n\n");
        printf("%-6s %-15s %-12s %-6s %-15s %-15s %-15s %s\n", 
               "trade", "price", "qty", "is_buy", "VWAP", "SMA_3", "SMA_5", "signal");
    }

    /* Data tracking variables */
    double total_price_qty = 0.0;
    double total_qty = 0.0;

    /* Circular buffer variables for running sum */
    double short_prices[SHORT_WINDOW] = {0};
    double long_prices[LONG_WINDOW] = {0};
    int short_pos = 0;
    int long_pos = 0;
    int short_count = 0;
    int long_count = 0;
    double short_sum = 0.0;
    double long_sum = 0.0;

    /* Signal state tracking */
    double previous_diff = 0.0;
    int have_previous_diff = 0;
    long long buy_count = 0;
    long long sell_count = 0;

    long long plot_rows = 0;
    long long plot_buys = 0;
    long long plot_sells = 0;

    /* ----------------------------------------------------
     * STEP 2: Process engine processing in-memory
     * ---------------------------------------------------- */
    double t_proc_start = get_time_sec();

    for (long long i = 0; i < trade_count; i++) {
        long long t = trades[i].trade_no;
        double p = trades[i].price;
        double q = trades[i].qty;
        int is_buy = trades[i].is_buy;

        /* 1. VWAP Update */
        total_price_qty += p * q;
        total_qty += q;
        double vwap = (total_qty > 0.0) ? (total_price_qty / total_qty) : 0.0;

        double sma_short = 0.0;
        double sma_long = 0.0;
        int have_short_sma = 0;
        int have_long_sma = 0;

        /* 2 & 3. SMA Calculation (Naive vs Running Sum) */
        if (naive_mode) {
            /* Naive SMA: Re-add the entire window from array on each trade */
            if (i >= SHORT_WINDOW - 1) {
                have_short_sma = 1;
                double sum_s = 0.0;
                for (int k = 0; k < SHORT_WINDOW; k++) {
                    sum_s += trades[i - k].price;
                }
                sma_short = sum_s / SHORT_WINDOW;
            }

            if (i >= LONG_WINDOW - 1) {
                have_long_sma = 1;
                double sum_l = 0.0;
                for (int k = 0; k < LONG_WINDOW; k++) {
                    sum_l += trades[i - k].price;
                }
                sma_long = sum_l / LONG_WINDOW;
            }
        } else {
            /* Optimized Running Sum SMA via circular buffer */
            if (short_count == SHORT_WINDOW) {
                short_sum -= short_prices[short_pos];
            } else {
                short_count++;
            }
            short_prices[short_pos] = p;
            short_sum += p;
            short_pos = (short_pos + 1) % SHORT_WINDOW;

            if (long_count == LONG_WINDOW) {
                long_sum -= long_prices[long_pos];
            } else {
                long_count++;
            }
            long_prices[long_pos] = p;
            long_sum += p;
            long_pos = (long_pos + 1) % LONG_WINDOW;

            have_short_sma = (short_count == SHORT_WINDOW);
            have_long_sma = (long_count == LONG_WINDOW);

            if (have_short_sma) sma_short = short_sum / SHORT_WINDOW;
            if (have_long_sma) sma_long = long_sum / LONG_WINDOW;
        }

        /* 4. Detect Crossovers */
        int signal = 0;
        if (have_short_sma && have_long_sma) {
            double diff = sma_short - sma_long;

            if (have_previous_diff) {
                if (previous_diff <= 0.0 && diff > 0.0) {
                    signal = 1;
                    buy_count++;
                } else if (previous_diff >= 0.0 && diff < 0.0) {
                    signal = -1;
                    sell_count++;
                }
            }

            previous_diff = diff;
            have_previous_diff = 1;
        }

        /* 5. String Formatting for SMA Display */
        char sma3_str[32];
        if (have_short_sma) {
            sprintf(sma3_str, "%.8f", sma_short);
        } else {
            strcpy(sma3_str, "-");
        }

        char sma5_str[32];
        if (have_long_sma) {
            sprintf(sma5_str, "%.8f", sma_long);
        } else {
            strcpy(sma5_str, "-");
        }

        const char *sig_str = "";
        if (signal == 1) {
            sig_str = "BUY";
        } else if (signal == -1) {
            sig_str = "SELL";
        }

        /* 6. Console Printing */
        if (!plotting) {
            printf("%-6lld %-15.8f %-12.8f %-6d %-15.8f %-15s %-15s %s\n",
                   t, p, q, is_buy, vwap, sma3_str, sma5_str, sig_str);
        }

        /* 7. Plotting File Dump */
        if (plotting && t >= plot_start && t < plot_start + PLOT_TRADES) {
            fprintf(out, "%lld %.8f %.8f %.8f %d\n", t, p, sma_short, sma_long, signal);
            plot_rows++;
            if (signal == 1) {
                plot_buys++;
            } else if (signal == -1) {
                plot_sells++;
            }
        }
    }
    double t_proc_end = get_time_sec();

    if (out != NULL) {
        fclose(out);
    }

    /* Summary Output & Execution Times */
    if (!plotting) {
        if (total_qty > 0.0) {
            printf("\nFinal VWAP: %.8f\n", total_price_qty / total_qty);
        } else {
            printf("\nFinal VWAP: 0.00000000\n");
        }
        printf("Signals: %lld BUY, %lld SELL\n", buy_count, sell_count);
    } else {
        printf("\n--- Stage B In-Memory Summary ---\n");
        printf("Trades loaded into memory: %lld\n", trade_count);
        printf("BUY signals: %lld\n", buy_count);
        printf("SELL signals: %lld\n", sell_count);
        printf("Plot slice starts at trade: %lld\n", plot_start);
        printf("Rows written to signals.dat: %lld\n", plot_rows);
        printf("BUY signals in slice: %lld\n", plot_buys);
        printf("SELL signals in slice: %lld\n", plot_sells);
    }

    printf("\n--- Execution Timing ---\n");
    printf("File Loading Time    : %.6f sec\n", t_load_end - t_load_start);
    printf("Processing Time (%s): %.6f sec\n", naive_mode ? "Naive" : "Running-Sum", t_proc_end - t_proc_start);
    printf("Total Execution Time : %.6f sec\n", t_proc_end - t_load_start);

    return 0;
}