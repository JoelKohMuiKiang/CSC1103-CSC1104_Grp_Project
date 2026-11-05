#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "trade_io.h"
#include "timing.h"
#include "StageA+.h"

// #define SHORT_WINDOW 40
// #define LONG_WINDOW  200
#define GROUP_LONG   200
#define GROUP_SHORT  40
#define TEST_SHORT   3
#define TEST_LONG    5
#define MAX_WINDOW   200
#define PLOT_TRADES  2000

#define TEST_PATH "../DATABASE/test20.csv"
#define DEV_PATH  "../DATABASE/dev_1M.csv"

/* ---------- One-second OHLC bar state ---------- */
double ohlc_open = 0.0, ohlc_high = 0.0, ohlc_low = 0.0, ohlc_close = 0.0;
long long current_sec = -1;
int ohlc_count = 0;            /* trades in the current bar */

/* Update the bar with one trade; print the finished bar when the second changes. */
static void update_ohlc(long long ts, double p, int print_bars)
{     
    long long trade_sec = ts / 1000000LL;  /* integer division drops the microseconds */

    if (trade_sec != current_sec) {
        if (current_sec != -1 && print_bars) {
            printf("%-14lld%-19.8f%-19.8f%-19.8f%-19.8f%-10d\n",
                   current_sec, ohlc_open, ohlc_high, ohlc_low,
                   ohlc_close, ohlc_count);
        }
        current_sec = trade_sec;
        ohlc_open = p;
        ohlc_high = p;
        ohlc_low = p;
        ohlc_close = p;
        ohlc_count = 1; // 1st trade of the new second
    } else {
        if (p > ohlc_high) ohlc_high = p;
        if (p < ohlc_low)  ohlc_low = p;
        ohlc_close = p;
        ohlc_count++;
    }
}

static int benchmark_reader(int use_fast)
{
    const char *path = "../DATABASE/stress_full.csv";
    FILE *fp = NULL;
    long long trades = 0;
    long long buys = 0;
    double total_qty = 0.0;
    double total_value = 0.0;

    if (use_fast) {
        fp = fopen(path, "r");
        if (fp == NULL) {
            perror(path);
            return 1;
        }
    } else if (!open_trades(path)) {
        return 1;
    }

    uint64_t start = now_ns();

    if (use_fast) {
        long long ts;
        double price, qty;
        int is_buy;

        while (read_trade(fp, &ts, &price, &qty, &is_buy)) {
            trades++;
            buys += is_buy;
            total_qty += qty;
            total_value += price * qty;
        }
    } else {
        while (next_trade()) {
            double price = trade_price();
            double qty = trade_qty();

            trades++;
            buys += trade_is_buy();
            total_qty += qty;
            total_value += price * qty;
        }
    }

    uint64_t elapsed = now_ns() - start;

    if (use_fast) {
        fclose(fp);
    } else {
        close_trades();
    }

    printf("Reader: %s\n", use_fast ? "Manual parser" : "sscanf");
    printf("Trades: %lld\n", trades);
    printf("Buyer-initiated trades: %lld\n", buys);
    printf("Total quantity: %.8f\n", total_qty);
    printf("Total price x quantity: %.6f\n", total_value);
    printf("Time: %.6f seconds\n", elapsed / 1e9);

    return trades == 0 ? 1 : 0;
}

int main(int argc, char *argv[])
{

    if (argc == 2 && strcmp(argv[1], "bench-old") == 0) {
        return benchmark_reader(0);
    } 
    if (argc == 2 && strcmp(argv[1], "bench-fast") == 0) {
        return benchmark_reader(1);
    }

    int plotting = 0;
    long long plot_start = 1;

    /* Choose which dataset to process. */
    if (argc >= 2 && strcmp(argv[1], "plot") == 0) {
        plotting = 1;

        if (argc >= 3) {
            plot_start = atoll(argv[2]);
            if (plot_start < 1) {
                printf("Plot start trade must be at least 1.\n");
                return 1;
            }
        }
    } else if (argc >= 2 && strcmp(argv[1], "test") != 0) {
        printf("Usage: %s test\n", argv[0]);
        printf("       %s plot [start_trade]\n", argv[0]);
        return 1;
    }

    int short_window = plotting ? GROUP_SHORT : TEST_SHORT;
    int long_window  = plotting ? GROUP_LONG  : TEST_LONG;

    /* Open the dataset with fopen. */
    FILE *fp = fopen(plotting ? DEV_PATH : TEST_PATH, "r");
    if (fp == NULL) {
        printf("Could not open data file\n");
        return 1;
    }

    FILE *out = NULL;

    if (plotting) {
        out = fopen("signals.dat", "w");

        if (out == NULL) {
            printf("Could not create signals.dat\n");
            fclose(fp);
            return 1;
        }
    }

    /* VWAP running totals. */
    double total_price_qty = 0.0;
    double total_qty = 0.0;

    /* Circular SMA windows. */
    double short_prices[MAX_WINDOW] = {0};
    double long_prices[MAX_WINDOW] = {0};

    int short_pos = 0;
    int long_pos = 0;
    int short_count = 0;
    int long_count = 0;

    double short_sum = 0.0;
    double long_sum = 0.0;

    /* Signal state. */
    double previous_diff = 0.0;
    int have_previous_diff = 0;
    long long buy_count = 0;
    long long sell_count = 0;

    long long total_trades = 0;
    long long plot_rows = 0;
    long long plot_buys = 0;
    long long plot_sells = 0;

    long long ts;
    double p, q;
    int is_buy;
    long long t = 0;     

    /* Print structural headers matching your target layout */
    if (!plotting) {
        printf("Expected answers for test20.csv (short window = %d, long window = %d)\n", short_window, long_window);
        printf("is_buy = 1 when isBuyerMaker is False\n");
        printf("SMA values start once the window is full; signals start once both SMAs exist for two trades in a row\n");
        printf("OHLC lines appear when a one-second bar finishes (second = time / 1,000,000)\n\n");
        printf("%-6s %-15s %-12s %-6s %-15s %-15s %-15s %s\n",
               "trade", "price", "qty", "is_buy", "VWAP", "SMA_3", "SMA_5", "signal");
    }

    while (read_trade(fp, &ts, &p, &q, &is_buy)) {
        t++;

        total_trades++;

        /* 1. Update VWAP sums. */
        total_price_qty += p * q;
        total_qty += q;
        double vwap = (total_qty > 0.0) ? (total_price_qty / total_qty) : 0.0;

        /* 2. Update the one-second OHLC bar (printed only in test mode). */
        update_ohlc(ts, p, !plotting);

        /* 3. Update short circular window. */
        if (short_count == short_window) {
            short_sum -= short_prices[short_pos];
        } else {
            short_count++;
        }

        short_prices[short_pos] = p;
        short_sum += p;
        short_pos = (short_pos + 1) % short_window;

        /* 4. Update long circular window. */
        if (long_count == long_window) {
            long_sum -= long_prices[long_pos];
        } else {
            long_count++;
        }

        long_prices[long_pos] = p;
        long_sum += p;
        long_pos = (long_pos + 1) % long_window;

        /* 5. Calculate SMAs when their individual windows are full. */
        double sma_short = 0.0;
        double sma_long = 0.0;
        int have_short_sma = (short_count == short_window);
        int have_long_sma = (long_count == long_window);

        if (have_short_sma) {
            sma_short = short_sum / short_window;
        }

        if (have_long_sma) {
            sma_long = long_sum / long_window;
        }

        int signal = 0;

        /* Detect crossovers only when both SMAs exist. */
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

        /* 6. Safe character array string allocation for column placement */
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

        /* 7. Clean columnar format printing */
        if (!plotting) {
            printf("%-6lld %-15.8f %-12.8f %-6d %-15.8f %-15s %-15s %s\n",
                   t, p, q, is_buy, vwap, sma3_str, sma5_str, sig_str);
        }

        /* 8. Write data slice to file if in plotting mode. */
        if (plotting && have_short_sma && have_long_sma && t >= plot_start && t < plot_start + PLOT_TRADES) {
            fprintf(out, "%lld %.8f %.8f %.8f %d\n", t, p, sma_short, sma_long, signal);
            plot_rows++;
            if (signal == 1) {
                plot_buys++;
            } else if (signal == -1) {
                plot_sells++;
            }
        }
    }

    fclose(fp);

    if (out != NULL) {
        fclose(out);
    }

    /* Final bottom summary blocks */
    if (!plotting) {
        if (total_qty > 0.0) {
            printf("\nFinal VWAP: %.8f\n", total_price_qty / total_qty);
        } else {
            printf("\nFinal VWAP: 0.00000000\n");
        }
        printf("Signals: %lld BUY, %lld SELL\n\n", buy_count, sell_count);
        if (current_sec != -1) {
            printf("One-second OHLC bars (second = time / 1,000,000)\n");
            printf("%-14s%-19s%-19s%-19s%-19s%-10s\n", 
                "second", "open", "high", "low", "close", "trades");
            printf("%-14lld%-19.8f%-19.8f%-19.8f%-19.8f%-10d\n",
                current_sec, ohlc_open, ohlc_high, ohlc_low, ohlc_close, ohlc_count);
        }
    } else {
        printf("\n--- Stage A Summary ---\n");
        printf("Trades processed: %lld\n", total_trades);
        printf("BUY signals: %lld\n", buy_count);
        printf("SELL signals: %lld\n", sell_count);
        printf("Plot slice starts at trade: %lld\n", plot_start);
        printf("Rows written to signals.dat: %lld\n", plot_rows);
        printf("BUY signals in slice: %lld\n", plot_buys);
        printf("SELL signals in slice: %lld\n", plot_sells);
    }

    return 0;
}