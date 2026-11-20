#!/bin/sh
# ladder.sh - run the V0..V4 efficiency ladder (Group 21), RUNS times each.
#
# Usage (from inside CODE/):   ./ladder.sh stress      (marked results)
#                              ./ladder.sh dev         (quick check)
# Optional env vars:  RUNS=5  CPU=3  PERF=1 (Pi only: also run perf stat)
#
# Every rung uses the SAME program (StageC.c, unpaced -s 0, no console output)
# and the same time definition: "Benchmark time" = load + replay.
#   V0  -O0   naive SMA         sscanf parser   fixed 10M array
#   V1  -O0   running-sum SMA   sscanf parser   fixed 10M array
#   V2  fast  running-sum SMA   sscanf parser   fixed 10M array   (fast = -O3, or -O3 -mcpu=cortex-a76 on the Pi)
#   V3  fast  running-sum SMA   custom parser   fixed 10M array
#   V4  fast  running-sum SMA   custom parser   malloc exact fit

DATA=${1:-stress}
RUNS=${RUNS:-5}
CPU=${CPU:-3}
mkdir -p build results

if [ "$(uname -m)" = "aarch64" ]; then FAST="-O3 -mcpu=cortex-a76"; else FAST="-O3"; fi

gcc -O0     StageC.c StageA+.c rival.c -o build/ladder_O0   -lm || exit 1
gcc $FAST   StageC.c StageA+.c rival.c -o build/ladder_fast -lm || exit 1

PIN=""
if command -v taskset >/dev/null 2>&1 && taskset -c "$CPU" true 2>/dev/null; then
    PIN="taskset -c $CPU"
fi

OUT="results/ladder_$DATA.csv"
echo "version,run,benchmark_s,trades_per_s,reserved_MiB,peak_rss_kB,buy,sell,vwap" > "$OUT"

# run_rung NAME BINARY EXTRA_ARGS...
run_rung() {
    name=$1; bin=$2; shift 2
    r=1
    while [ "$r" -le "$RUNS" ]; do
        $PIN "./$bin" -f "$DATA" -s 0 -q -o build/ladder_sig.csv "$@" > build/ladder_out.txt 2>&1
        t=$(awk '/^Benchmark time/{print $4}'            build/ladder_out.txt)
        tp=$(awk '/^Benchmark throughput/{print $4}'     build/ladder_out.txt)
        mib=$(awk '/^Selected storage/{print $5}'        build/ladder_out.txt)
        rss=$(awk '/VmHWM/{print $2}'                    build/ladder_out.txt)
        b=$(awk '/^Signals/{print $3}'                   build/ladder_out.txt)
        s=$(awk '/^Signals/{print $5}'                   build/ladder_out.txt)
        v=$(awk '/^Final VWAP/{print $4}'                build/ladder_out.txt)
        echo "$name,$r,$t,$tp,$mib,$rss,$b,$s,$v" >> "$OUT"
        echo "$name run $r: $t s  ($tp trades/s)  signals $b/$s  vwap $v"
        r=$((r + 1))
    done
    if [ "$PERF" = "1" ] && command -v perf >/dev/null 2>&1; then
        $PIN perf stat -e cycles,instructions,cache-misses \
            "./$bin" -f "$DATA" -s 0 -q -o build/ladder_sig.csv "$@" \
            > /dev/null 2> "results/perf_${name}_$DATA.txt"
    fi
}

run_rung V0 build/ladder_O0   -n --parser old  --memory fixed
run_rung V1 build/ladder_O0      --parser old  --memory fixed
run_rung V2 build/ladder_fast    --parser old  --memory fixed
run_rung V3 build/ladder_fast    --parser fast --memory fixed
run_rung V4 build/ladder_fast    --parser fast --memory malloc

echo
echo "Median of $RUNS runs (also saved in $OUT):"
for v in V0 V1 V2 V3 V4; do
    grep "^$v," "$OUT" | cut -d, -f3 | sort -n | awk -v v="$v" '
        {a[NR]=$1} END {m=a[int((NR+1)/2)]; printf "%s median %.6f s\n", v, m}'
done
echo "Check: every row must show the same BUY/SELL/VWAP (see $OUT)."