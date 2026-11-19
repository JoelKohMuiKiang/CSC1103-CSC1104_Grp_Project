#include <stdio.h>
#include <limits.h>
#include <string.h>
#include "StageA+.h"

static char *next_field(char *p) {
    char *comma = strchr(p, ',');
    if (comma == NULL) return NULL;
    return comma + 1;
}

static int fast_parse_ll(const char **cursor, long long *result) {
    const char *p = *cursor;
    long long value = 0;

    if (*p < '0' || *p > '9') return 0;

    while (*p >= '0' && *p <= '9') {
        int digit = *p - '0';
        if (value > (LLONG_MAX - digit) / 10) return 0;

        value = value * 10 + digit;
        p++;
    }

    *result = value;
    *cursor = p;
    return 1;
}

static int fast_parse_double(const char **cursor, double *result) {
    const char *p = *cursor;
    double whole = 0.0;
    double fraction = 0.0;
    double scale = 1.0;
    int digits = 0;

    while (*p >= '0' && *p <= '9') {
        whole = whole * 10.0 + (*p - '0');
        p++;
        digits++;
    }

    if (*p == '.') {
        p++;
        while (*p >= '0' && *p <= '9') {
            fraction = fraction * 10.0 + (*p - '0');
            scale *= 10.0;
            p++;
            digits++;
        }
    }

    if (digits == 0) return 0;

    *result = whole + fraction / scale;
    *cursor = p;
    return 1;
}

int read_trade(FILE *fp, long long *ts, double *price, double *qty, int *is_buy) {
    char line[256];

    while (fgets(line, sizeof line, fp) != NULL) {
        char *p = line;
        const char *end;
        double parsed_price, parsed_qty;
        long long parsed_ts;

        p = next_field(p);
        if (p == NULL) continue;

        end = p;
        if (!fast_parse_double(&end, &parsed_price) || *end != ',') continue;

        p = next_field(p);
        if (p == NULL) continue;

        end = p;
        if (!fast_parse_double(&end, &parsed_qty) || *end != ',') continue;

        p = next_field(p);
        if (p == NULL) continue;
        p = next_field(p);
        if (p == NULL) continue;

        end = p;
        if (!fast_parse_ll(&end, &parsed_ts) || *end != ',') continue;

        p = next_field(p);
        if (p == NULL) continue;

        *price = parsed_price;
        *qty = parsed_qty;
        *ts = parsed_ts;
        *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;

        return 1;
    }

    return 0;
}

/* ------------------------------------------------------------------
 * Fixed-point reader (Stage B).
 * Converts price and qty straight from the text into scaled integers,
 * so no double and no rounding step is involved.
 * Example with 2 decimals: "73027.02000000" -> 7302702.
 * Digits beyond 'decimals' are dropped (they are all zeros in this
 * dataset: price has 2 significant decimals, qty has 5).
 * ------------------------------------------------------------------ */
static int fast_parse_fixed(const char **cursor, int decimals, long long *result) {
    const char *p = *cursor;
    long long value = 0;
    int digits = 0;
    int frac = 0;

    while (*p >= '0' && *p <= '9') {
        value = value * 10 + (*p - '0');
        p++;
        digits++;
    }

    if (*p == '.') {
        p++;
        while (*p >= '0' && *p <= '9') {
            if (frac < decimals) {          /* keep only 'decimals' digits */
                value = value * 10 + (*p - '0');
                frac++;
            }
            p++;
            digits++;
        }
    }

    if (digits == 0) return 0;

    while (frac < decimals) {               /* pad if fewer decimals were given */
        value *= 10;
        frac++;
    }

    *result = value;
    *cursor = p;
    return 1;
}

int read_trade_fixed(FILE *fp, long long *ts, long long *price_fx,
                     long long *qty_fx, int *is_buy) {
    char line[256];

    while (fgets(line, sizeof line, fp) != NULL) {
        char *p = line;
        const char *end;
        long long parsed_price, parsed_qty, parsed_ts;

        p = next_field(p);                         /* skip trade id */
        if (p == NULL) continue;

        end = p;
        if (!fast_parse_fixed(&end, PRICE_DECIMALS, &parsed_price) || *end != ',') continue;

        p = next_field(p);
        if (p == NULL) continue;

        end = p;
        if (!fast_parse_fixed(&end, QTY_DECIMALS, &parsed_qty) || *end != ',') continue;

        p = next_field(p);                         /* skip quoteQty */
        if (p == NULL) continue;
        p = next_field(p);
        if (p == NULL) continue;

        end = p;
        if (!fast_parse_ll(&end, &parsed_ts) || *end != ',') continue;

        p = next_field(p);
        if (p == NULL) continue;

        *price_fx = parsed_price;
        *qty_fx = parsed_qty;
        *ts = parsed_ts;
        *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
        return 1;
    }
    return 0;
}