#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "StageA+.h"

static char *next_field(char *p) {
    char *comma = strchr(p, ',');
    if (comma == NULL) return NULL;
    return comma + 1;
}

int read_trade(FILE *fp, long long *ts, double *price, double *qty, int *is_buy) {
    char line[256];

    while (fgets(line, sizeof line, fp) != NULL) {
        char *p = line;
        char *end;

        p = next_field(p);
        if (p == NULL) continue;

        *price = strtod(p, &end);
        if (end == p) continue;

        p = next_field(p);
        if (p == NULL) continue;
        *qty = strtod(p, &end);
        if (end == p) continue;

        p = next_field(p);
        if (p == NULL) continue;
        p = next_field(p);
        if (p == NULL) continue;

        *ts = strtoll(p, &end, 10);
        if (end == p) continue;

        p = next_field(p);
        if (p == NULL) continue;

        *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;

        return 1;
    }
    
    return 0;
}