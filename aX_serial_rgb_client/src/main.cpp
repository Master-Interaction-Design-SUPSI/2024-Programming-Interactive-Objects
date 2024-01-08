/**
 * The controller acts as a client, expecting (pixel) data from the serial port.
 *
 * The SmartMatrix library offers many tools (and examples) to display graphics,
 * animations and texts.
 * Dependencies (and docs):
 * https://github.com/pixelmatix/SmartMatrix
 *
 * Fork of the library that allows control of the special 32x32 matrix
 * https://github.com/Kameeno/SmartMatrix
 */

// Pinout configuration for the PicoDriver v.5.0
#include "common/pico_driver_v5_pinout.h"

#include <Arduino.h>
#include <SmartMatrix.h>

#define COLOR_DEPTH    24  // valid: 24, 48
#define TOTAL_WIDTH    32  // Size of the total (chained) with of the matrix/matrices
#define TOTAL_HEIGHT   32  // Size of the total (chained) height of the matrix/matrices
#define kRefreshDepth  48  // Valid: 24, 36, 48
#define kDmaBufferRows  4  // Valid: 2-4
#define kPanelType     SM_PANELTYPE_HUB75_32ROW_32COL_MOD8SCAN // custom
#define kMatrixOptions SM_HUB75_OPTIONS_NONE
#define kbgOptions     SM_BACKGROUND_OPTIONS_NONE

const uint16_t NUM_LEDS = TOTAL_WIDTH * TOTAL_HEIGHT;
const uint16_t BUFFER_SIZE = NUM_LEDS * 3; // Assume RGB data
uint8_t buf[BUFFER_SIZE];                  // A buffer for the incoming data

// SmartMatrix setup & buffer alloction
SMARTMATRIX_ALLOCATE_BUFFERS(matrix, TOTAL_WIDTH, TOTAL_HEIGHT, kRefreshDepth, kDmaBufferRows, kPanelType, kMatrixOptions);

// A single background layer "bg"
SMARTMATRIX_ALLOCATE_BACKGROUND_LAYER(bg, TOTAL_WIDTH, TOTAL_HEIGHT, COLOR_DEPTH, kbgOptions);

void setup() {
	Serial.begin(921600);

	pinMode(PICO_LED_PIN, OUTPUT);
	digitalWrite(PICO_LED_PIN, 1);

	bg.enableColorCorrection(true);
	matrix.addLayer(&bg);
	matrix.setBrightness(255);
	matrix.begin();
}

void loop() {

	static uint32_t frame = 0;

	char chr = Serial.read();
	if (chr == '*') {  // Special char to signal incoming data
		// masterFrame
		uint16_t count = Serial.readBytes((char *)buf, BUFFER_SIZE);
		if (count == BUFFER_SIZE) {
			rgb24 *buffer = bg.backBuffer();
			uint16_t idx = 0;
			rgb24 *col;
			for (uint16_t i = 0; i < NUM_LEDS; i++) {
				col = &buffer[i];
				col->red   = buf[idx++];
				col->green = buf[idx++];
				col->blue  = buf[idx++];
			}
			bg.swapBuffers(false);
		}
	}

	digitalWrite(PICO_LED_PIN, frame / 20 % 2);   // Let's animate the built-in LED as well
	frame++;
}