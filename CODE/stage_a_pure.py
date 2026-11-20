#!/usr/bin/env python3
"""
stage_a_pure.py - Stage A in plain Python (stretch goal: C versus Python).

Same maths as the C engine: VWAP (two running sums), one-second OHLC bars,
short/long SMA with a circular window and running sums, BUY/SELL crossover.
Prices and quantities are fixed-point integers (price x100, qty x100000),
exactly as in Stage B, so the results match the C program digit for digit.

Usage (run from CODE/):  python3 stage_a_pure.py [test|dev|stress]
"""
import sys
import time

SCALE_P = 100          # price  x 100
SCALE_Q = 100000       # qty    x 100000
PATHS = {
    "test":   ("../DATABASE/test20.csv", 3, 5),        # test20 always uses 3 / 5
    "dev":    ("../DATABASE/dev_1M.csv", 40, 200),     # Group 21 windows
    "stress": ("../DATABASE/stress_full.csv", 40, 200),
}

def time_parse_only(path):
    """Second pass: read and convert every line but do no maths.
    Used to split the total time into load and calculation (approximate)."""
    t = time.perf_counter()
    with open(path, "r") as f:
        for line in f:
            fld = line.split(",")
            if len(fld) < 7:
                continue
            try:
                round(float(fld[1]) * SCALE_P)
                round(float(fld[2]) * SCALE_Q)
                int(fld[4])
            except ValueError:
                continue
    return time.perf_counter() - t

def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "dev"
    if mode not in PATHS:
        print("Usage: python3 stage_a_pure.py [test|dev|stress]")
        return 1
    path, short_win, long_win = PATHS[mode]

    # ---- state ----
    total_pq = 0                      # sum of price*qty (scale 10^7)
    total_q = 0                       # sum of qty       (scale 10^5)
    buf_s = [0] * short_win           # circular windows of the latest prices
    buf_l = [0] * long_win
    idx_s = idx_l = 0
    sum_s = sum_l = 0                 # running window sums
    prev_d = 0
    have_prev = False
    buys = sells = 0
    n = 0
    bars = 0                          # completed one-second OHLC bars
    cur_sec = -1
    o = h = l = c = cnt = 0
    last_bar = None

    t0 = time.perf_counter()
    with open(path, "r") as f:
        for line in f:
            fld = line.split(",")
            if len(fld) < 7:
                continue
            try:
                price = round(float(fld[1]) * SCALE_P)
                qty = round(float(fld[2]) * SCALE_Q)
                ts = int(fld[4])
            except ValueError:
                continue                       # header or bad line

            n += 1
            # VWAP
            total_pq += price * qty
            total_q += qty

            # SMA windows (running sum: add newest, subtract the one leaving)
            sum_s += price - buf_s[idx_s]
            buf_s[idx_s] = price
            idx_s = (idx_s + 1) % short_win
            sum_l += price - buf_l[idx_l]
            buf_l[idx_l] = price
            idx_l = (idx_l + 1) % long_win

            # Crossover (exact integer test, same as the C code)
            if n >= long_win:
                d = sum_s * long_win - sum_l * short_win
                if have_prev:
                    if prev_d <= 0 and d > 0:
                        buys += 1
                    elif prev_d >= 0 and d < 0:
                        sells += 1
                prev_d = d
                have_prev = True

            # One-second OHLC bar
            sec = ts // 1000000
            if sec != cur_sec:
                if cur_sec != -1:
                    bars += 1
                    last_bar = (cur_sec, o, h, l, c, cnt)
                cur_sec = sec
                o = h = l = c = price
                cnt = 1
            else:
                if price > h:
                    h = price
                if price < l:
                    l = price
                c = price
                cnt += 1
    if cur_sec != -1:
        bars += 1
        last_bar = (cur_sec, o, h, l, c, cnt)
    t1 = time.perf_counter()

    vwap = total_pq / total_q / SCALE_P if total_q else 0.0
    print(f"Python (pure) {mode}: windows {short_win}/{long_win}")
    print(f"Trades               : {n}")
    print(f"Final VWAP           : {vwap:.8f}")
    print(f"Signals              : {buys} BUY, {sells} SELL")
    print(f"OHLC bars            : {bars}")
    if last_bar:
        s, o, h, l, c, cnt = last_bar
        print(f"Last bar             : sec {s} O {o/SCALE_P:.2f} H {h/SCALE_P:.2f} "
              f"L {l/SCALE_P:.2f} C {c/SCALE_P:.2f} trades {cnt}")
    print(f"Total time (load+calc): {t1 - t0:.3f} s  ({n / (t1 - t0):.0f} trades/s)")
    load_s = time_parse_only(path)
    print(f"Load (parse only)     : {load_s:.3f} s")
    print(f"Calculation (approx)  : {max(t1 - t0 - load_s, 0.0):.3f} s")
    return 0


if __name__ == "__main__":
    sys.exit(main())
