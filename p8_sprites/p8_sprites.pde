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
PImage[] sprite1, sprite2, sprite3;

void setup() {
  // The Processing preprocessor only accepts literal values for size()
  // We can't do: size(TOTAL_WIDTH, TOTAL_HEIGHT);
  size(400, 300);
  
  noSmooth();

  led = createGraphics(TOTAL_WIDTH, TOTAL_HEIGHT);
  led.smooth(8);

  PImage spriteSheet1 = loadImage("1.png");
  sprite1 = new PImage[5];
  int spriteWidth1 = spriteSheet1.width / sprite1.length;
  for (int i=0; i<sprite1.length; i++) {
    sprite1[i] = spriteSheet1.get(spriteWidth1 * i, 0, spriteWidth1, spriteSheet1.height);
  }

  PImage spriteSheet2 = loadImage("2.png");
  sprite2 = new PImage[6];
  int spriteWidth2 = spriteSheet2.width / sprite2.length;
  for (int i=0; i<sprite2.length; i++) {
    sprite2[i] = spriteSheet2.get(spriteWidth2 * i, 0, spriteWidth2, spriteSheet2.height);
  }

  PImage spriteSheet3 = loadImage("3.png");
  sprite3 = new PImage[21];
  int spriteWidth3 = spriteSheet3.width / sprite3.length;
  for (int i=0; i<sprite3.length; i++) {
    sprite3[i] = spriteSheet3.get(spriteWidth3 * i, 0, spriteWidth3, spriteSheet3.height);
  }

  //sprite[0] = spriteSheet.get(21 * 0, 0, 21, spriteSheet.height);
  //sprite[1] = spriteSheet.get(21 * 1, 0, 21, spriteSheet.height);
  //sprite[2] = spriteSheet.get(21 * 2, 0, 21, spriteSheet.height);
  //sprite[3] = spriteSheet.get(21 * 3, 0, 21, spriteSheet.height);
  //sprite[4] = spriteSheet.get(21 * 4, 0, 21, spriteSheet.height);


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
  led.image(sprite1[frameCount / 2 % sprite1.length], 0, 5);  
  led.image(sprite2[frameCount / 4 % sprite2.length], 10, 5);  
  led.image(sprite3[frameCount / 3 % sprite3.length], 20, 5);

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
