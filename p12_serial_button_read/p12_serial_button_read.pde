/**
 * This Processing sketch sends all the pixels of the canvas to the serial port.
 */

SerialMatrix serialMatrix;

final int TOTAL_WIDTH  = 32;
final int TOTAL_HEIGHT = 32;
final int NUM_CHANNELS = 3;
final int BAUD_RATE    = 921600;

int counter = 0;

void setup() {
  // The Processing preprocessor only accepts literal values for size()
  // so we can't do: size(TOTAL_WIDTH, TOTAL_HEIGHT);
  size(32, 32);
  
  serialMatrix = new SerialMatrix(this, "/dev/tty.usbserial-02B3C00E", BAUD_RATE);
}

void draw() {
  
  serialMatrix.buttonCheck();

  // Draw some things
  background(0, 0, 0);

  noStroke();
  
  if(serialMatrix.buttonValue(1) % 2 == 0){
    fill(255, 0, 0);
  } else {
    fill(0, 0, 255);
  }
  
  if(serialMatrix.buttonPressed(2)){
    counter ++;
  } else {
    counter = 0;
  }
  
  if(counter >= 30){
    println("Long press! - Button 1");
    counter = 0;
  }
  
  float d = map(sin(frameCount * 0.1), -1, 1, 3, 30);
  ellipse(width/2, height/2, d, d);

  noFill();
  stroke(0, 255, 0);
  rect(0, 0, 31, 31);
  
  //Send pixels to Matrix
  serialMatrix.sendPixels();
}
