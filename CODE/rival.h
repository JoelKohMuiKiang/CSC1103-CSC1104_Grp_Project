/*
 * rival.h - Rival bot model ("why slow code loses money").
 *
 * The rival reacts to every signal in R microseconds. For each signal:
 *   - if OUR reaction time < R, we win and trade at the triggering trade's price;
 *   - otherwise the rival wins and we trade at the NEXT trade's price.
 * Position rules: start flat. BUY signal -> buy 1 BTC if we hold none.
 * SELL signal -> sell it if we hold one. Signals that do not fit are ignored.
 *
 * P&L = (sum of selling prices) - (sum of buying prices). Prices are kept as
 * fixed-point integers (price x RIVAL_PRICE_SCALE), so P&L is exact.
 * No fees; a simplified learning model, not trading advice.
 */
#ifndef RIVAL_H
#define RIVAL_H

#include <stdint.h>

#define RIVAL_PRICE_SCALE 100LL        /* must match SCALE_P in the engine */

typedef struct {
    long long pnl_fx;       /* sells - buys, scaled by RIVAL_PRICE_SCALE */
    int       holding;      /* 1 = we hold 1 BTC, 0 = flat */
    long long buys;         /* executed buys */
    long long sells;        /* executed sells */
    long long races_won;    /* executed trades where we beat the rival */
    long long races_lost;   /* executed trades where the rival beat us */
} RivalState;

/* Reset to "no Bitcoin, zero P&L". */
void rival_init(RivalState *r);

/*
 * Apply one signal.
 *   side          : 1 = BUY, -1 = SELL
 *   price_now_fx  : price of the triggering trade (fixed-point)
 *   price_next_fx : price of the next trade in the file (fixed-point);
 *                   pass price_now_fx again if there is no next trade
 *   reaction_ns   : our processing time for the triggering trade
 *   rival_ns      : the rival's reaction time R, in nanoseconds
 */
void rival_on_signal(RivalState *r, int side, long long price_now_fx,
                     long long price_next_fx, uint64_t reaction_ns,
                     uint64_t rival_ns);

/* P&L in USDT as a double (for printing only). */
double rival_pnl(const RivalState *r);

#endif /* RIVAL_H */