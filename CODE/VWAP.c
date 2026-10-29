#include <stdio.h>
#include "trade_io.h"

int main(void) {
    double sum_pq = 0.0;
    double sum_q = 0.0;

    open_trades("dev_1M - Copy (2).csv");
    while (next_trade()) {
        double p = trade_price();
        double q = trade_qty();

        sum_pq += p * q;
        sum_q += q;
    }
    close_trades();

    if (sum_q > 0.0) {
        double vwap = sum_pq / sum_q;
        printf("VWAP = %.8F\n", vwap);
    }
    return 0;
}