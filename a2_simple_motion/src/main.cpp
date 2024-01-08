/**
 * Simple example with motion: bounce!
 */

// Pinout configuration for the PicoDriver v.5.0
#include "common/pico_driver_v5_pinout.h"

#include <Arduino.h>
#include <SmartMatrix.h>

#define COLOR_DEPTH 24   // valid: 24, 48
#define TOTAL_WIDTH 32   // Size of the total (chained) with of the matrix/matrices
#define TOTAL_HEIGHT 32  // Size of the total (chained) height of the matrix/matrices
#define kRefreshDepth 24 // Valid: 24, 36, 48
#define kDmaBufferRows 4 // Valid: 2-4
#define kPanelType SM_PANELTYPE_HUB75_32ROW_32COL_MOD8SCAN // custom
#define kMatrixOptions (SM_HUB75_OPTIONS_NONE)
#define kbgOptions (SM_BACKGROUND_OPTIONS_NONE)

// SmartMatrix setup & buffer alloction
SMARTMATRIX_ALLOCATE_BUFFERS(matrix, TOTAL_WIDTH, TOTAL_HEIGHT, kRefreshDepth, kDmaBufferRows, kPanelType, kMatrixOptions);

// A single background layer "bg"
SMARTMATRIX_ALLOCATE_BACKGROUND_LAYER(bg, TOTAL_WIDTH, TOTAL_HEIGHT, COLOR_DEPTH, kbgOptions);

void setup() {
	// On board LED (useful for debugging)
	pinMode(PICO_LED_PIN, OUTPUT);

	// Turn the on board LED on
	digitalWrite(PICO_LED_PIN, 1);

	bg.enableColorCorrection(true);
	matrix.addLayer(&bg);
	matrix.setBrightness(255);

	// Init the library and the matrix
	matrix.begin();
}

int posX = 13;
int posY = 11;
int velX = 1;
int velY = 2;

void loop() {

	posX = posX + velX;
	if (posX >= 32 || posX < 0) {
		velX = -velX;
	}

	posY = posY + velY;
	if (posY >= 32 || posY < 0) {
		velY = -velY;
	}

	//bg.fillScreen({0, 0, 0});
	//bg.drawPixel(posX, posY, {random(256), random(256), random(256)});

	bg.fillRectangle(posX, posY, posX+3, posY+3, {random(256), random(256), random(256)});

	bg.swapBuffers();
}
