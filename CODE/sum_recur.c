#include <stdio.h>
#include <stdint.h>
#include "timing.h"

#define N 10000
#define REPETITIONS 10000

uint64_t iterative_sum(uint64_t n)
{
    uint64_t sum = 0;

    for (uint64_t i = 1; i <= n; i++)
    {
        sum += i;
    }

    return sum;
}

uint64_t recursive_sum(uint64_t n)
{
    if (n == 0)
    {
        return 0;
    }

    return n + recursive_sum(n - 1);
}

int main(void)
{
    uint64_t sum;
    uint64_t start, end;

    /* Iterative version */
    start = now_ns();

    for (int i = 0; i < REPETITIONS; i++)
    {
        sum = iterative_sum(N);
    }

    end = now_ns();

    printf("Iterative sum = %llu\n", sum);
    printf("Iterative time = %llu ns\n", end - start);


    /* Recursive version */
    start = now_ns();

    for (int i = 0; i < REPETITIONS; i++)
    {
        sum = recursive_sum(N);
    }

    end = now_ns();

    printf("Recursive sum = %llu\n", sum);
    printf("Recursive time = %llu ns\n", end - start);

    return 0;
}