#ifndef STAGE_A_PLUS_H
#define STAGE_A_PLUS_H

#include <stdio.h>

/* Reads the next valid trade from fp.
   Returns 1 on success, 0 at end of file. */
int read_trade(FILE *fp, long long *ts, double *price,
               double *qty, int *is_buy);

#endif