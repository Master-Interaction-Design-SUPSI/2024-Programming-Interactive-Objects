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

Sprite s1, s2;

void setup() {
  // The Processing preprocessor only accepts literal values for size()
  // We can't do: size(TOTAL_WIDTH, TOTAL_HEIGHT);
  size(400, 300);

  noSmooth();

  led = createGraphics(TOTAL_WIDTH, TOTAL_HEIGHT);
  led.smooth(8);

 
  s1 = new Sprite("1.png", 5, 3);
  s2 = new Sprite("2.png", 6, 2);


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

  frameRate(20);
}
void draw() {

  led.beginDraw();
  led.background(0);
  
  s1.step(frameCount);
  s2.step(frameCount);
  
  s1.draw(led, -5, 5);
  s2.draw(led, 15, 5);

  led.endDraw();


  image(led, 10, 10, TOTAL_WIDTH * 8, TOTAL_HEIGHT * 8);
  image(led, TOTAL_WIDTH * 8 + 20, 10);

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
