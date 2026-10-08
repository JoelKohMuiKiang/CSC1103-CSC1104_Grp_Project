#include <stdio.h>
#include "timing.h"

int main(void) {
    uint64_t N;
    uint64_t sum = 0;

    printf("Enter a number N (e.g., 100000000): ");
    if (scanf("%llu", &N) != 1) {
        printf("Invalid input.\n");
        return 1;
    }

    uint64_t start_time = now_ns();

    // Accumulate sum from 1 to N
    for (uint64_t i = 1; i <= N; ++i) {
        sum += i;
    }

    uint64_t end_time = now_ns();

    printf("The sum of 1 to %llu is %llu\n", N, sum);

    printf("Time taken: %llu nanoseconds\n", end_time - start_time);

    return 0;
}