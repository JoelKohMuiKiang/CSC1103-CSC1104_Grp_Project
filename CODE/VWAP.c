#include <stdio.h>
#include "trade_io.h"

int main(void) {
    double sum_pq = 0.0;
    double sum_q = 0.0;
    double ohlc_open = 0.0, ohlc_high = 0.0, ohlc_low = 0.0, ohlc_close = 0.0;
    long current_sec = -1;
    int ohlc_count = 0;

    if (!open_trades("test20 - Copy (2).csv")) {
        if (!open_trades("dev_1M - Copy (2).csv")) {
            fprintf(stderr, "Error: Could not open trade data files.\n");
            return 1;
        }
    }

    while (next_trade()) {
        double p = trade_price();
        double q = trade_qty();
        long long raw_sec = trade_time(); 
        long long trade_sec = raw_sec / 1000000LL;

        sum_pq += p * q;
        sum_q += q;

        double vwap = 0.0;
        if (sum_q > 0.0) {
            vwap = sum_pq / sum_q;
        }

        printf("Trade Price: %.3f, Qty: %.6f, Current VWAP: %.10f\n", p, q, vwap);

        if (trade_sec != current_sec) {
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
            ohlc_count++;   // <--- MUST INCREMENT HERE for trades in the same second
        }
    }
    
    if (current_sec != -1) {
        printf("One-second OHLC bars (second = time / 1,000,000)\n");
        printf("%-14s%-19s%-19s%-19s%-19s%-10s\n", 
            "second", "open", "high", "low", "close", "trades");
        printf("%-14lld%-19.8f%-19.8f%-19.8f%-19.8f%-10d\n",
            current_sec, ohlc_open, ohlc_high, ohlc_low, ohlc_close, ohlc_count);
    }
    
    close_trades();
    return 0;
}