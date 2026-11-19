/* rival.c - rival bot model; see rival.h for the rules. */
#include "rival.h"

void rival_init(RivalState *r)
{
    r->pnl_fx = 0;
    r->holding = 0;
    r->buys = r->sells = 0;
    r->races_won = r->races_lost = 0;
}

void rival_on_signal(RivalState *r, int side, long long price_now_fx,
                     long long price_next_fx, uint64_t reaction_ns,
                     uint64_t rival_ns)
{
    /* Signals that cannot be acted on (BUY while holding, SELL while flat)
     * are skipped, so no race takes place. */
    if (side == 1 && r->holding) return;
    if (side == -1 && !r->holding) return;

    /* Strictly shorter than the rival wins the current price. */
    int we_win = (reaction_ns < rival_ns);
    long long fill = we_win ? price_now_fx : price_next_fx;

    if (we_win) r->races_won++; else r->races_lost++;

    if (side == 1) {            /* buy: money goes out */
        r->pnl_fx -= fill;
        r->holding = 1;
        r->buys++;
    } else {                    /* sell: money comes in */
        r->pnl_fx += fill;
        r->holding = 0;
        r->sells++;
    }
}

double rival_pnl(const RivalState *r)
{
    return (double)r->pnl_fx / (double)RIVAL_PRICE_SCALE;
}