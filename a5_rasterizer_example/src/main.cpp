/**
 * A 2D gradient
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


int frame;

void loop() {
	float t = frame++ * 0.1;
	float ox = sin( t * 0.2);
	float oy = cos( t * 0.3);
	float rings = cos(t * 0.1) * 20.0;

	for (int j=0; j<32; j++) {
		for (int i=0; i<32; i++) {
			float u = (float) i / 32 * 2.0 - 1.0 + ox;
			float v = (float) j / 32 * 2.0 - 1.0 + oy;
			float d = sqrt(u * u + v * v);
			float col = (sin(d * rings + t) * 0.5 + 0.5) * 100.0;
		  	if (col < 50.0) col = 0.0;
			else col = 100.0;
			bg.drawPixel(i, j, {col, col, col});
		}
	}
	bg.swapBuffers();
}