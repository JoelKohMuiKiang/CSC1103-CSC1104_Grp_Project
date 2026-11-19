#ifndef STAGE_A_PLUS_H
#define STAGE_A_PLUS_H

#include <stdio.h>

/* Reads the next valid trade from fp.
   Returns 1 on success, 0 at end of file. */
int read_trade(FILE *fp, long long *ts, double *price,
               double *qty, int *is_buy);

/* Fixed-point scales (decided from the data: price has 2 significant
   decimals, qty has 5; see report section on fixed-point choice). */
#define PRICE_DECIMALS 2
#define QTY_DECIMALS   5

/* Same as read_trade() but returns price and qty as scaled integers
   (price x 10^PRICE_DECIMALS, qty x 10^QTY_DECIMALS). */
int read_trade_fixed(FILE *fp, long long *ts, long long *price_fx,
                     long long *qty_fx, int *is_buy);

#endif