#include <stdio.h>
#include <unistd.h>
#include "led.h"

int main()
{
    led_init();

    printf("Both LEDs OFF\n");
    led_off(LED_GREEN);
    led_off(LED_RED);
    sleep(2);

    printf("GREEN ON\n");
    led_on(LED_GREEN);
    sleep(2);

    printf("GREEN OFF\n");
    led_off(LED_GREEN);
    sleep(2);

    printf("RED ON\n");
    led_on(LED_RED);
    sleep(2);

    printf("RED OFF\n");
    led_off(LED_RED);
    sleep(2);

    printf("Both LEDs OFF\n");
    led_off(LED_GREEN);
    led_off(LED_RED);

    led_cleanup();

    return 0;
}