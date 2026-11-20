/* timer_res.c - smallest step now_ns() can resolve on this machine. */
#ifndef __USE_MINGW_ANSI_STDIO
#define __USE_MINGW_ANSI_STDIO 1
#endif
#include "timing.h"
#include <stdio.h>

int main(void)
{
    uint64_t min_step = ~0ULL;
    for (int i = 0; i < 2000000; i++) {
        uint64_t a = now_ns(), b = now_ns();
        if (b > a && b - a < min_step) min_step = b - a;
    }
    printf("Smallest non-zero now_ns() step: %llu ns\n", (unsigned long long)min_step);
#ifdef _WIN32
    LARGE_INTEGER f;
    QueryPerformanceFrequency(&f);
    printf("QueryPerformanceCounter: %11s Hz (tick = %.1f ns)\n", 
           (long long)f.QuadPart, 1e9 / (double)f.QuadPart);
#endif
    return 0;
}