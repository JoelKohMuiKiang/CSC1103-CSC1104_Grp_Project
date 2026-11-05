#include <stdio.h>
#include <stdint.h>
#include "timing.h"
#include "led.h"

int main(void)
{
    uint64_t N;
    uint64_t sum = 0;
    uint64_t start, end;

    led_init();

    printf("Enter N: ");
    /*scanf("%llu", &N);*/
    if (scanf("%llu", &N) != 1) {
        printf("Invalid input.\n");
        led_cleanup();
        return 1;
    }

    led_on(LED_GREEN);

    start = now_ns();

    for (uint64_t i = 1; i <= N; i++)
    {
        sum += i;
    }

    end = now_ns();

    led_off(LED_GREEN);

    printf("Sum = %llu\n", sum);
    printf("Time = %llu ns\n", end - start);

    led_cleanup();

    return 0;
}