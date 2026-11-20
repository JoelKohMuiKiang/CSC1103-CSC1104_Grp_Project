# Makefile - Tick-to-Trade mini project (Group 21: short 40 / long 200)
#
# Typing `make` builds every version on the efficiency ladder.
# Written for the Raspberry Pi 5 (gcc on Linux); also builds on Linux/Mac laptops.
# On a laptop the -mcpu=cortex-a76 variant is skipped automatically.
#
#   make              build everything into build/
#   make test         run the 20-trade check (windows 3/5) on Stages A, B and C
#   make asm          write the -O2 assembly of StageB/StageC to build/*.s
#   make rival        run Version 0 and the fastest version, then the rival bot
#                     sweep -> rival_sweep.csv and money_lost.png
#   make bench        time every ladder version 5 times -> results/*.log
#   make clean        remove build/ and generated results
#
# Options:  DATA=dev    use dev_1M.csv instead of stress_full.csv (quick tests)
#           CPU=3       core used by taskset when benchmarking (Pi only)
#           CC=gcc      compiler

CC     ?= gcc
WARN   := -Wall -Wextra
LDLIBS := -lm
DATA   ?= stress
CPU    ?= 3

ifeq ($(DATA),dev)
  DATA_CSV := ../DATABASE/dev_1M.csv
else
  DATA_CSV := ../DATABASE/stress_full.csv
endif

# Pin to one core when taskset exists and that core exists (Pi / Linux).
# Empty on Mac or when CPU=n is not a valid core.
PIN := $(shell command -v taskset >/dev/null 2>&1 && taskset -c $(CPU) true 2>/dev/null && echo "taskset -c $(CPU)")

# -mcpu=cortex-a76 only exists on the Pi 5 (64-bit ARM Linux).
ifeq ($(shell uname -m),aarch64)
  NATIVE := 1
endif

HDRS := timing.h led.h trade_io.h StageA+.h rival.h

# ---------------------------------------------------------------- ladder
# One binary per optimisation level for StageB and StageC.
SUFFIXES := O0 O2 O3
FLAGS_O0 := -O0
FLAGS_O2 := -O2
FLAGS_O3 := -O3
ifdef NATIVE
  SUFFIXES += O3_a76
  FLAGS_O3_a76 := -O3 -mcpu=cortex-a76
  FAST_SUFFIX := O3_a76
else
  FAST_SUFFIX := O3
endif

STAGE0   := Stage0_loop Stage0_sum_1N Stage0_sum_recur
STAGE0_O := O0 O1 O2 O3
FLAGS_O1 := -O1

B_BINS := $(foreach s,$(SUFFIXES),build/StageB_$(s))
C_BINS := $(foreach s,$(SUFFIXES),build/StageC_$(s))
Z_BINS := $(foreach p,$(STAGE0),$(foreach o,$(STAGE0_O),build/$(p)_$(o)))
A_BINS := build/StageA build/StageA_Pi
X_BINS := build/rival_bot build/test_helpers build/test_led build/stretch_soa build/vwap_bench build/timer_res

all: $(A_BINS) $(Z_BINS) $(B_BINS) $(C_BINS) $(X_BINS)

build:
	mkdir -p build results

# Stage 0 programs at -O0 .. -O3 (single source file, led.h/timing.h only)
define STAGE0_RULE
build/$(1)_$(2): $(1).c $(HDRS) | build
	$$(CC) $$(WARN) $$(FLAGS_$(2)) $$< -o $$@
endef
$(foreach p,$(STAGE0),$(foreach o,$(STAGE0_O),$(eval $(call STAGE0_RULE,$(p),$(o)))))

# Stage A (helper library) and the Pi/LED variant
build/StageA: StageA.c trade_io.c StageA+.c $(HDRS) | build
	$(CC) $(WARN) -O2 StageA.c trade_io.c StageA+.c -o $@ $(LDLIBS)

build/StageA_Pi: StageA_Pi.c trade_io.c $(HDRS) | build
	$(CC) $(WARN) -O2 StageA_Pi.c trade_io.c -o $@ $(LDLIBS)

# Stage B and Stage C ladder versions
define LADDER_RULE
build/StageB_$(1): StageB.c StageA+.c $(HDRS) | build
	$$(CC) $$(WARN) $$(FLAGS_$(1)) StageB.c StageA+.c -o $$@ $$(LDLIBS)

build/StageC_$(1): StageC.c StageA+.c rival.c $(HDRS) | build
	$$(CC) $$(WARN) $$(FLAGS_$(1)) StageC.c StageA+.c rival.c -o $$@ $$(LDLIBS)
endef
$(foreach s,$(SUFFIXES),$(eval $(call LADDER_RULE,$(s))))

# Rival bot and helper checks
build/rival_bot: rival_bot.c rival.c StageA+.c $(HDRS) | build
	$(CC) $(WARN) -O2 rival_bot.c rival.c StageA+.c -o $@ $(LDLIBS)

build/test_helpers: test_helpers.c $(HDRS) | build
	$(CC) $(WARN) -O2 test_helpers.c trade_io.c -o $@ $(LDLIBS)

build/test_led: test_led.c led.h | build
	$(CC) $(WARN) -O2 test_led.c -o $@

build/stretch_soa: stretch_soa.c StageA+.c $(HDRS) | build
	$(CC) $(WARN) -O3 stretch_soa.c StageA+.c -o $@ $(LDLIBS)

build/timer_res: timer_res.c timing.h | build
	$(CC) $(WARN) -O2 timer_res.c -o $@

# vwap_bench: the AArch64 assembly row only exists on the Pi
ifdef NATIVE
build/vwap_bench: vwap_bench.c StageA+.c vwap_kernel_a64.S $(HDRS) | build
	$(CC) $(WARN) -O3 -mcpu=cortex-a76 vwap_bench.c StageA+.c vwap_kernel_a64.S -o $@ $(LDLIBS)
else
build/vwap_bench: vwap_bench.c StageA+.c $(HDRS) | build
	$(CC) $(WARN) -O3 vwap_bench.c StageA+.c -o $@ $(LDLIBS)
endif

# ---------------------------------------------------------------- test
# test20.csv always uses short = 3, long = 5. Compare the printed table with
# test20_expected.txt by eye (or diff the signal lines) before trusting a version.
test: build/StageA build/StageB_O2 build/StageC_O2
	@echo "=== Stage A (test20) ===";  ./build/StageA test
	@echo "=== Stage B (test20) ===";  ./build/StageB_O2 test
	@echo "=== Stage C (test20, unpaced) ==="; ./build/StageC_O2 -f test -s 0 -q -o build/test_signals.csv

# ---------------------------------------------------------------- assembly
# Plain gcc -S -O2 of the main loop (the engine step is inlined into main).
# -fno-asynchronous-unwind-tables drops the .cfi lines so it is easier to annotate.
asm: build/StageC_O2.s build/StageB_O2.s

build/%_O2.s: %.c StageA+.h rival.h timing.h led.h | build
	$(CC) -S -O2 -fno-asynchronous-unwind-tables $< -o $@

# ---------------------------------------------------------------- rival bot
# Version 0 = naive SMA (re-adds the window) at -O0; fastest = running-sum at
# the best flags. Both run unpaced (-s 0) so the logged reaction time is pure
# processing time. Both raise the same signals.
V0_BIN   := build/StageC_O0
FAST_BIN := build/StageC_$(FAST_SUFFIX)

build/log_v0.csv: $(V0_BIN)
	$(PIN) ./$(V0_BIN) -f $(DATA) -s 0 -n -q -o $@

build/log_fast.csv: $(FAST_BIN)
	$(PIN) ./$(FAST_BIN) -f $(DATA) -s 0 -q -o $@

rival: build/rival_bot build/log_v0.csv build/log_fast.csv
	./build/rival_bot $(DATA_CSV) build/log_v0.csv build/log_fast.csv rival_sweep.csv | tee results/rival_bot.log
	@command -v gnuplot >/dev/null && gnuplot plot_rival && echo "Wrote money_lost.png" \
	  || echo "gnuplot not found: install it or plot rival_sweep.csv yourself"

# ---------------------------------------------------------------- benchmark
# Five runs of every ladder version, naive and running-sum. Look at the
# "Processing time" lines and take the median of the five.
bench: $(B_BINS) $(C_BINS)
	@for s in $(SUFFIXES); do \
	  for run in 1 2 3 4 5; do \
	    echo "== StageB_$$s running-sum run $$run"; \
	    $(PIN) ./build/StageB_$$s $(DATA) | grep -E "Load time|Processing time|Total time|memory"; \
	    echo "== StageB_$$s naive run $$run"; \
	    $(PIN) ./build/StageB_$$s $(DATA) naive | grep -E "Load time|Processing time|Total time|memory"; \
	  done; \
	done 2>&1 | tee results/bench_stageB.log
	@for s in $(SUFFIXES); do \
	  for run in 1 2 3 4 5; do \
	    echo "== StageC_$$s running-sum run $$run"; \
	    $(PIN) ./build/StageC_$$s -f $(DATA) -s 0 -q -o build/bench_sig.csv | grep -E "Wall time|Processing per trade|Latency per trade"; \
	  done; \
	done 2>&1 | tee results/bench_stageC.log

clean:
	rm -rf build results rival_sweep.csv money_lost.png

.PHONY: all test asm rival bench clean