#include <stdio.h>
#include <stdint.h>
#include <time.h>

// Your two implementations
double vwap_c_o3(const double *prices, const double *qtys, size_t n);
extern double vwap_asm(const double *prices, const double *qtys, size_t n);

static inline uint64_t now_ns(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + ts.tv_nsec;
}

int main(void) {
    const size_t N = 4096;          // Fits inside L1/L2 cache
    const int ITERATIONS = 100000;  // Amplifies runtime to milliseconds/seconds
    double prices[N], qtys[N];

    // 1. Populate arrays (not timed)
    for (size_t i = 0; i < N; i++) {
        prices[i] = 100.0 + (i % 50);
        qtys[i] = 10.0 + (i % 10);
    }

    // 2. Warmup cache
    volatile double sink = vwap_c_o3(prices, qtys, N);

    // 3. Time GCC -O3 version
    uint64_t t0 = now_ns();
    for (int it = 0; it < ITERATIONS; it++) {
        sink += vwap_c_o3(prices, qtys, N);
    }
    uint64_t t1 = now_ns();

    // 4. Time Hand-written Assembly version
    uint64_t t2 = now_ns();
    for (int it = 0; it < ITERATIONS; it++) {
        sink += vwap_asm(prices, qtys, N);
    }
    uint64_t t3 = now_ns();

    printf("C (-O3): %.3f ms\n", (t1 - t0) / 1e6);
    printf("ASM:     %.3f ms\n", (t3 - t2) / 1e6);
    printf("Ignore:  %f\n", sink); // Prevents GCC from optimizing away the loops
    return 0;
}