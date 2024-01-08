/**
 * Blink the on board LED of the PicoDriver (GPIO_NUM_0)
 */

#include <Arduino.h>

#define PICO_LED_PIN 0

void setup() {
	// Tell the board to use the PIN connected to the
	// on board LED as an output (vs input, or "read" values)
	pinMode(PICO_LED_PIN, OUTPUT);
}

void loop() {
	// Turn the LED on
	digitalWrite(PICO_LED_PIN, 1);
	// Wait a bit
	delay(300);
	// Turn the LED off
	digitalWrite(PICO_LED_PIN, 0);
	// Wait a bit
	delay(300);
	// ...start again from top (loop)
}