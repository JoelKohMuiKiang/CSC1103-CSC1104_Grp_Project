/*
 * led.h  -  PM Mini Project helper (works on Windows, macOS and Raspberry Pi 5)
 *
 *   led_init()        call once at the start of main()
 *   led_on(LED_GREEN) led_off(LED_GREEN)
 *   led_on(LED_RED)   led_off(LED_RED)
 *   led_cleanup()     call once at the end of main()
 *
 * On a Raspberry Pi 5 (run with sudo) this drives BOTH:
 *   - Built-in status LEDs: ACT (Green) and PWR (Red)
 *   - External breadboard LEDs: BCM GPIO 17 (Pin 11) and GPIO 27 (Pin 13)
 */
#ifndef LED_H
#define LED_H

#include <stdio.h>
#include <stdlib.h>

#define LED_GREEN 0
#define LED_RED   1

static const char *led_name[2] = { "GREEN", "RED" };

#if defined(__linux__)
static int led_hw = 0;                                   /* 1 = onboard LED in use */
static int led_ext = 0;                                  /* 1 = external GPIO in use */
static const char *led_dir[2] = { "/sys/class/leds/ACT", "/sys/class/leds/PWR" };
static const int led_gpio[2] = { 17, 27 };               /* Pin 11 = GPIO 17, Pin 13 = GPIO 27 */

/* write a short text value to one of the onboard LED's control files */
static inline int led_write(int led, const char *file, const char *value) {
    char path[128];
    FILE *fp;
    snprintf(path, sizeof path, "%s/%s", led_dir[led], file);
    fp = fopen(path, "w");
    if (fp == NULL) return 0;
    fputs(value, fp);
    fclose(fp);
    return 1;
}
#endif

static inline void led_init(void) {
#if defined(__linux__)
    char cmd[128];

    /* 1. Initialize onboard LEDs (exact original logic) */
    led_hw = led_write(LED_GREEN, "trigger", "none") &&
             led_write(LED_RED, "trigger", "none");

    if (led_hw) {
        // Green (ACT) is inverted: 1 = OFF
        led_write(LED_GREEN, "brightness", "1");

        // Red (PWR) is normal: 0 = OFF
        led_write(LED_RED, "brightness", "0");
    }

    /* 2. Initialize external GPIO 17 and 27 to Output (op) and Drive Low / OFF (dl) */
    snprintf(cmd, sizeof cmd, "pinctrl set %d op dl && pinctrl set %d op dl",
             led_gpio[LED_GREEN], led_gpio[LED_RED]);
    if (system(cmd) == 0) {
        led_ext = 1;
    }

    if (led_hw || led_ext) {
        return;
    }

    printf("[led.h] LED hardware not available (not a Pi 5, or not run with sudo). Printing instead.\n");
#else
    printf("[led.h] No Raspberry Pi LED on this computer. Printing instead.\n");
#endif
}

static inline void led_set(int led, int on) {
#if defined(__linux__)
    char cmd[64];

    /* 1. Set onboard LED (exact original logic) */
    if (led_hw) {
        if (led == LED_GREEN) {
            // Green (ACT) is inverted
            led_write(led, "brightness", on ? "0" : "1");
        } else {
            // Red (PWR) is normal
            led_write(led, "brightness", on ? "1" : "0");
        }
    }

    /* 2. Mirror state to external breadboard LED */
    if (led_ext) {
        snprintf(cmd, sizeof cmd, "pinctrl set %d %s",
                 led_gpio[led], on ? "dh" : "dl");
        system(cmd);
    }

    if (led_hw || led_ext) {
        return;
    }
#endif

    printf("[LED %s %s]\n", led_name[led], on ? "ON" : "OFF");
}

static inline void led_on(int led)  { led_set(led, 1); }
static inline void led_off(int led) { led_set(led, 0); }

static inline void led_cleanup(void) {
#if defined(__linux__)
    char cmd[128];

    /* 1. Turn both onboard LEDs off before exiting (exact original logic) */
    if (led_hw) {
        led_write(LED_GREEN, "brightness", "1");
        led_write(LED_RED, "brightness", "0");
    }

    /* 2. Turn external LEDs off and return pins to safe input (ip) state */
    if (led_ext) {
        snprintf(cmd, sizeof cmd, "pinctrl set %d dl ip && pinctrl set %d dl ip",
                 led_gpio[LED_GREEN], led_gpio[LED_RED]);
        system(cmd);
    }
#endif
}

#endif /* LED_H */
