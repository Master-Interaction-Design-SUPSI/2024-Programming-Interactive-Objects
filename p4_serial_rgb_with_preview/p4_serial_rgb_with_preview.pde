/**
 * This Processing sketch sends all the pixels of the canvas to the serial port.
 * The pixel data is read out from a texture instead of the canvas; 
 * this allows a better (bigger) preview... 
 */

import processing.serial.*;

final int TOTAL_WIDTH  = 32;
final int TOTAL_HEIGHT = 32;
final int NUM_CHANNELS = 3;
final int BAUD_RATE    = 921600;

Serial serial;
byte[]buffer;

PGraphics led;

void setup() {
  // The Processing preprocessor only accepts literal values for size()
  // We can't do: size(TOTAL_WIDTH, TOTAL_HEIGHT);
  size(400, 300);
  
  noSmooth();
  
  led = createGraphics(TOTAL_WIDTH, TOTAL_HEIGHT);
  led.smooth(8);

  buffer = new byte[TOTAL_WIDTH * TOTAL_HEIGHT * NUM_CHANNELS];

  String[] list = Serial.list();
  printArray(list);

  try {
    // On macOS / Linux see the console for all wavailable ports
    final String PORT_NAME = "/dev/cu.usbserial-02B60E77";
    // On Windows the ports are numbered
    // final String PORT_NAME = "COM3";
    serial = new Serial(this, PORT_NAME, BAUD_RATE);
  }
  catch (Exception e) {
    println("Serial port not intialized...");
  }
}
void draw() {

  float x = sin(frameCount * 0.04) * 10 + TOTAL_WIDTH * 0.5;
  float y = cos(frameCount * 0.13) * 10 + TOTAL_HEIGHT * 0.5;
  led.beginDraw();
  led.background(200, 0, 180);
  led.ellipse(x, y, 10, 10);
  led.endDraw();

  image(led, 10, 10, TOTAL_WIDTH * 8, TOTAL_HEIGHT * 8);

  // --------------------------------------------------------------------------
  // Write to the serial port (if open)
  if (serial != null) {
    led.loadPixels();
    int idx = 0;
    for (int i=0; i<led.pixels.length; i++) {
      color c = led.pixels[i];
      buffer[idx++] = (byte)(c >> 16 & 0xFF); // r
      buffer[idx++] = (byte)(c >> 8  & 0xFF); // g
      buffer[idx++] = (byte)(c       & 0xFF); // b
    }
    serial.write('*');     // The 'data' command
    serial.write(buffer);  // ...and the pixel values
  } 
}
