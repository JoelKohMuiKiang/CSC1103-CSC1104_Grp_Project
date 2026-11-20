# Tick-to-Trade on the Edge — Group 21

Low-latency market-data engine in C (CSC1103 / CSC1104 Mini Project 2026-27).
Group 21 windows: **short SMA = 40 trades, long SMA = 200 trades**
(`test20.csv` always uses 3 / 5).

## Folder layout

```
UoG-PMCOA_Group21/
├── README.md                this file
├── PMCOAReportGroup21.pdf   report (submitted with the zip)
├── CODE/                    all C source, Makefile, tests, plots, results
    └── results/             benchmark logs, perf output, signals.dat/png
└── DATABASE/
    └── test20.csv           (dev_1M.csv and stress_full.csv are NOT in the zip)
```

**Data files.** `dev_1M.csv` and `stress_full.csv` are too large to submit. To
run anything on them, copy them into `DATABASE/` next to `test20.csv`
(programs are always run from inside `CODE/` and read `../DATABASE/`).
If you have the official `test20_expected.txt`, put it in `DATABASE/` too and
`make test` will diff against it.

## Requirements

`gcc`, `make`, `gnuplot` (plots), and on the Pi also `perf` and `taskset`
(already installed). Works on Raspberry Pi OS 64-bit, Linux, macOS and
Windows (MSYS2 / MinGW). On a laptop the LED state is printed instead of
driving hardware, and `-mcpu=cortex-a76` is skipped automatically.

## Build

```sh
cd CODE
make            # builds every version on the efficiency ladder into build/
make clean
```

Binaries produced (in `build/`):

| Binary | What it is |
|---|---|
| `Stage0_loop_O0..O3`, `Stage0_sum_1N_O0..O3`, `Stage0_sum_recur_O0..O3` | Stage 0: sum 1..N and recursive vs iterative sum at each `-O` level (`_sum_1N` also drives the LED) |
| `StageA` | Stage A + A+: streaming engine with our own `read_trade()` and fast parser; also the parser benchmark |
| `StageA_Pi` | Stage A with the helper library and LED output on the Pi |
| `StageB_O0/O2/O3[/O3_a76]` | Stage B: structs in a fixed-size global array, fixed-point integers, running-sum or naive SMA |
| `StageC_O0/O2/O3[/O3_a76]` | Stage C: `malloc`'d array, timestamp-paced replay, latency, LED/colour signal, rival bot |
| `rival_bot` | Rival-bot sweep (money lost vs rival reaction time R) |
| `test_helpers`, `test_led` | Check `timing.h` and `led.h` on this machine |
| `stretch_soa` | Stretch: Array-of-Structs vs Struct-of-Arrays kernels |
| `vwap_bench` | Stretch: VWAP kernel in C vs unrolled C vs AArch64 assembly (assembly row Pi only) |
| `timer_res` | Prints the smallest step `now_ns()` can resolve on this machine |

`_O3_a76` is built only on the Pi (`-O3 -mcpu=cortex-a76`).

### Build on Windows (MinGW GCC, PowerShell, no make)

For Windows users who do not have `make` installed, compile the programs directly using GCC in PowerShell.

```powershell
cd CODE

foreach ($o in 'O0','O2','O3') {
    gcc -$o -Wall StageB.c StageA+.c -o StageB_$o
    gcc -$o -Wall StageC.c StageA+.c rival.c -o StageC_$o
}

gcc -O2 StageA.c trade_io.c StageA+.c -o StageA
gcc -O3 stretch_soa.c StageA+.c -o stretch_soa
gcc -O2 timer_res.c -o timer_res
```

Run the full benchmarking ladder:

```powershell
.\bench_ladder.ps1
```

Benchmark results are saved to `results/bench_ladder.log`.

## Run

All commands are run from `CODE/`. On the Pi, anything using the LED needs `sudo`.

**Stage 0**
```sh
echo 100000000 | ./build/Stage0_sum_1N_O2     # prints sum and time, LED on during the loop
./build/Stage0_sum_recur_O2                   # iterative vs recursive, N = 10,000
```

**Stage A / A+** — correctness, signal plot, parser benchmark
```sh
./build/StageA test                # test20.csv, windows 3/5: trade table, VWAP, signals, OHLC bars
./build/StageA plot 200000         # 2,000-trade slice of dev_1M.csv -> signals.dat
gnuplot plot_signals               # signals.dat -> signals.png
./build/StageA bench-old           # helper library (sscanf) on stress_full.csv
./build/StageA bench-fast          # our own parser on stress_full.csv
```

**Stage B** — in-memory engine
```sh
./build/StageB_O2 test             # 20 trades, prints the table
./build/StageB_O2 dev              # dev_1M.csv, group windows
./build/StageB_O2 stress           # stress_full.csv (benchmark), running-sum SMA
./build/StageB_O2 stress naive     # same, but re-adding the whole window each trade
```

**Stage C** — replay, latency, signals, rival bot
```sh
./build/StageC_O2 -f stress -s 1000 -c            # whole day at 1000x, coloured BUY/SELL lines
./build/StageC_O2 -f stress -s 1 -m 10 -c         # real time for the first 10 minutes
sudo ./build/StageC_O3_a76 -f stress -s 100 -l -c # Pi: LED green = BUY, red = SELL
./build/StageC_O0 -f stress -s 1000 -n -c         # "Version 0" (naive SMA, -O0)
```

| Option | Meaning |
|---|---|
| `-f test\|dev\|stress` | data set (default `stress`; `test` uses windows 3/5) |
| `-s SPEED` | `1` real time, `100`, `1000`; `0` = no pacing (pure processing time) |
| `-m MINUTES` | replay only the first MINUTES of market time |
| `-n` | naive SMA (Version 0 engine) |
| `-c` | coloured terminal signals |
| `-l` | drive the LED (laptop: prints state) |
| `-q` | no once-a-second status line (lag counter and running P&L) |
| `-o FILE` | write the signal log used by the rival bot |
| `-r US` | rival reaction time for the live P&L (default 1 µs) |

**Race demonstration** — two terminals side by side, each shows its own lag counter and P&L:
```sh
./build/StageC_O0 -f stress -s 1000 -n -c                  # terminal 1: Version 0
sudo ./build/StageC_O3_a76 -f stress -s 1000 -c -l         # terminal 2: fastest version + LED
```

**Rival bot** (Version 0 vs fastest version, R swept 0.1–100 µs)
```sh
make rival         # runs both versions unpaced, sweeps R, writes rival_sweep.csv + money_lost.png
```

**Stretch goals**

```sh
./build/stretch_soa stress       # AoS vs SoA
python3 stage_a_pure.py stress   # Stage A in plain Python
python3 stage_a_numpy.py stress  # Stage A with NumPy (needs numpy)
./build/vwap_bench stress        # VWAP kernels (assembly row on the Pi only)
```


## Tests

`make test` runs Stage A, Stage B and Stage C on `test20.csv` (windows 3/5) and
prints the trade table, final VWAP and signal counts. Compare this output with the
official `test20_expected.txt` (saved as `results/test20_diff.txt`). On `dev_1M.csv`
(group windows 40/200) all versions must report the same BUY/SELL counts, since
`test20.csv` itself produces no crossings.


## Benchmarking (Raspberry Pi 5)

```sh
# 1. performance governor, then pin to one core
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
make bench                                           # 5 runs of every version -> results/bench_*.log (take the median)

# 2. hardware counters for a version
taskset -c 3 perf stat -e cycles,instructions,cache-misses,cache-references \
    ./build/StageB_O3_a76 stress 2> results/perf_StageB_O3_a76.txt

# 3. assembly of the main loop
make asm                                             # build/StageC_O2.s, build/StageB_O2.s
```

Use `DATA=dev` (e.g. `make bench DATA=dev`) for quick tests on `dev_1M.csv`.
`CPU=n` changes the pinned core. Reboot afterwards to restore the LED's normal behaviour.

## Benchmarking on a laptop (Windows)
`.\bench_ladder.ps1` runs V0...V4 five times each on `stress_full.csv` and writes the median and speedup to `results\bench_ladder.log`.

## Source map

| File | Role |
|---|---|
| `StageA+.c/.h` | Our own `read_trade()` (pointer out-parameters) and hand-written parsers (double and fixed-point) |
| `StageA.c`, `StageA_Pi.c` | Stage A: circular-buffer SMA, OHLC bars, signals, plot output |
| `StageB.c` | Stage B: global `Trade` array, fixed-point, naive vs running-sum |
| `StageC.c` | Stage C: `malloc`, paced replay, latency/lag, LED and colour output, signal log |
| `rival.c/.h`, `rival_bot.c` | Rival-bot model and the R sweep |
| `timing.h`, `led.h`, `trade_io.c/.h` | Provided helpers (timing, LED, helper library) |
| `plot_signals`, `plot_rival` | gnuplot scripts for `signals.png` and `money_lost.png` |
| `StageB.c`, `StageC.c` | Each holds its own `#define`s (`GROUP_SHORT 40`, `GROUP_LONG 200`, fixed-point scales `STAGE_B_MAX_TRADES`) and the `Trade` struct; the engine step is the main loop in StageB and `engine_step()` in StageC |
| `stretch_soa.c`, `vwap_bench.c`, `vwap_kernel_a64.S` | Stretch goals: SoA, VWAP assembly kernel |
| `stage_a_pure.py`, `stage_a_numpy.py` | Stretch goal: C vs Python |
| `timer_res.c`, `bench_ladder.ps1` | Timer resolution check, laptop benchmark script |

## Design notes and assumptions

* **Fixed-point scales.** Price is stored ×100 and quantity ×100,000 (the data has
  at most 2 and 5 significant decimals). `price × qty` then carries a scale of 10⁷;
  a whole day's traded value (~3.4×10⁹ USDT) is ~3.4×10¹⁶ scaled, well under the
  `long long` limit of ~9.2×10¹⁸. Stage B checks this with a 128-bit sum at load
  time, and the parser **counts any non-zero digit it has to drop** — Stage B and
  Stage C refuse to run if that count is not zero, so a wrong scale cannot go unnoticed.
* **Exact crossover test.** `d = short_sum × long_win − long_sum × short_win` has the
  same sign as `SMA_short − SMA_long` and needs no division, so the BUY/SELL test is exact.
* **Running-sum SMA without a circular buffer in Stage B/C.** The oldest price is still
  in the in-memory `trades[]` array, so it is read from there. Stage A, which streams
  the file, uses an explicit circular buffer.
* **Version 0** for the rival bot is the naive (re-add the window) engine at `-O0`;
  the fastest version is the running-sum engine at the best flags (`-O3 -mcpu=cortex-a76`
  on the Pi). Both raise identical signals (checked by `make test`).
* **Timing is not done inside output code.** Signal display (terminal/LED) happens after
  the decision timestamp, and no plot/log file is written inside timed loops.
* The rival bot is a simplified teaching model (no fees, 1 BTC position); it is not trading advice.

## Results

Measured results are stored in `CODE/results/` (benchmark logs, `perf stat` output)
and reported in `PMCOAReportGroup21.pdf`: speedup ladder, latency per replay speed,
rival-bot P&L and money lost, annotated assembly, and the prediction logbook.
