#include <stdio.h>
#include <stdint.h>
#include "timing.h"

int main(void)
{
    uint64_t N;
    uint64_t sum = 0;

    printf("Enter N: ");
    scanf("%llu", &N);

    uint64_t start = now_ns();

    for (uint64_t i = 1; i <= N; i++)
    {
        sum += i;
    }

    uint64_t end = now_ns();

    printf("Sum = %llu\n", sum);
    printf("Time = %llu ns\n", end - start);

    return 0;
}
