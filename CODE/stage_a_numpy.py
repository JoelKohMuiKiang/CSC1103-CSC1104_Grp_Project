#!/usr/bin/env python3
"""
stage_a_numpy.py - Stage A with NumPy (stretch goal: C versus Python).

Same results as stage_a_pure.py and the C engine, but the maths is done on
whole arrays at once (cumulative sums instead of a loop), so the heavy work
runs in NumPy's compiled C code. Load time and calculation time are reported
separately: loading the CSV is the slow part.

Needs:  pip install numpy      (Pi: sudo apt install python3-numpy)
Usage (run from CODE/):  python3 stage_a_numpy.py [test|dev|stress]
"""
import sys
import time
import numpy as np

SCALE_P = 100
SCALE_Q = 100000
PATHS = {
    "test":   ("../DATABASE/test20.csv", 3, 5),
    "dev":    ("../DATABASE/dev_1M.csv", 40, 200),
    "stress": ("../DATABASE/stress_full.csv", 40, 200),
}


def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "dev"
    if mode not in PATHS:
        print("Usage: python3 stage_a_numpy.py [test|dev|stress]")
        return 1
    path, sw, lw = PATHS[mode]

    # ---------------- load (columns: price, qty, time) ----------------
    t0 = time.perf_counter()
    # Timestamps (~1.8e15 us) are below 2^53, so float64 stores them exactly.
    raw = np.loadtxt(path, delimiter=",", usecols=(1, 2, 4), dtype=np.float64,
                     ndmin=2)
    t1 = time.perf_counter()

    # ---------------- calculate ----------------
    price = np.rint(raw[:, 0] * SCALE_P).astype(np.int64)
    qty = np.rint(raw[:, 1] * SCALE_Q).astype(np.int64)
    ts = raw[:, 2].astype(np.int64)
    n = price.size

    # VWAP: two sums (int64 is exact; the whole-day sum is about 3.4e16)
    total_pq = int(np.sum(price * qty))
    total_q = int(np.sum(qty))
    vwap = total_pq / total_q / SCALE_P

    # Running-sum SMA via a cumulative sum: S(t) = C(t) - C(t-N)
    c = np.concatenate(([0], np.cumsum(price)))          # c[k] = sum of first k prices
    sum_s = c[sw:] - c[:-sw]                             # window ending at trade sw-1 ...
    sum_l = c[lw:] - c[:-lw]                             # window ending at trade lw-1 ...
    # keep only trades where BOTH windows are full (trade index >= lw-1)
    sum_s = sum_s[lw - sw:]
    d = sum_s * lw - sum_l * sw                          # same sign as SMA_short - SMA_long
    prev, cur = d[:-1], d[1:]
    buys = int(np.count_nonzero((prev <= 0) & (cur > 0)))
    sells = int(np.count_nonzero((prev >= 0) & (cur < 0)))

    # One-second OHLC bars
    sec = ts // 1000000
    starts = np.concatenate(([0], np.flatnonzero(np.diff(sec)) + 1))
    ends = np.concatenate((starts[1:], [n])) - 1
    bar_open = price[starts]
    bar_close = price[ends]
    bar_high = np.maximum.reduceat(price, starts)
    bar_low = np.minimum.reduceat(price, starts)
    counts = ends - starts + 1
    t2 = time.perf_counter()

    print(f"Python (NumPy) {mode}: windows {sw}/{lw}")
    print(f"Trades               : {n}")
    print(f"Final VWAP           : {vwap:.8f}")
    print(f"Signals              : {buys} BUY, {sells} SELL")
    print(f"OHLC bars            : {starts.size}")
    k = starts.size - 1
    print(f"Last bar             : sec {int(sec[starts[k]])} O {bar_open[k]/SCALE_P:.2f} "
          f"H {bar_high[k]/SCALE_P:.2f} L {bar_low[k]/SCALE_P:.2f} "
          f"C {bar_close[k]/SCALE_P:.2f} trades {int(counts[k])}")
    print(f"Load time            : {t1 - t0:.3f} s")
    print(f"Calculation time     : {t2 - t1:.3f} s")
    print(f"Total time (load+calc): {t2 - t0:.3f} s  ({n / (t2 - t0):.0f} trades/s)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
