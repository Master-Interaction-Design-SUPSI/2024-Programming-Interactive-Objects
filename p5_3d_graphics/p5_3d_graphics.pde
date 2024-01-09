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
  size(400, 300, P3D);
  
  noSmooth();
  
  led = createGraphics(TOTAL_WIDTH, TOTAL_HEIGHT, P3D);
  

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

  
  led.beginDraw();
  led.background(0);
  led.translate(led.width/2, led.height/2);
  led.rotateX( frameCount * 0.022);
  led.rotateY( frameCount * 0.033);
  led.rotateZ( frameCount * 0.044);
  led.fill(255,0,0);
  led.box(16);
  
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
