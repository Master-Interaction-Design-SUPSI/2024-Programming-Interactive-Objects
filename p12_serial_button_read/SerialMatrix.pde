import processing.serial.*;

public class SerialMatrix {
  PApplet parent;
  Serial serial;
  byte[] buffer;
  
  private int incrementValue1 = 0;
  private boolean isPressed1 = false;
  private boolean isReleased1 = false;
  private int incrementValue2 = 0;
  private boolean isPressed2 = false;
  private boolean isReleased2 = false;

  public SerialMatrix(PApplet p, String portName, int baudRate) {
    parent = p;
    String[] list = Serial.list();
    printArray(list);
    
    buffer = new byte[TOTAL_WIDTH * TOTAL_HEIGHT * NUM_CHANNELS];
    
    try {
      serial = new Serial(parent, portName, baudRate);
    }
    catch (Exception e) {
      System.err.println("Serial port not intialized...");
    }
  }
  
  public void buttonCheck(){
    if (serial.available() > 0) {
      byte[] receivedBytes = serial.readBytes();
      if (receivedBytes[0] == 0) {
        incrementValue1++;
        isPressed1 = false;
        isReleased1 = true;
      } else if(receivedBytes[0] == 1){
        isPressed1 = true;
        isReleased1 =  false;
      } else if (receivedBytes[0] == 2) {
        incrementValue2++;
        isPressed2 = false;
        isReleased2 = true;
      } else if(receivedBytes[0] == 3){
        isPressed2 = true;
        isReleased2 =  false;
      }
    }
  }
  

  public boolean buttonReleased(int btn) {
    if(btn == 1){
      if (isReleased1) {
        return true;
      } else {
        return false;
      }
    } else if (btn == 2) {
      if (isReleased2) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
  
  public boolean buttonPressed(int btn) {
    if(btn == 1){
      if (isPressed1) {
        return true;
      } else {
        return false;
      }
    } else if (btn == 2) {
      if (isPressed2) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
    }

  public int buttonValue(int btn) {
    if(btn == 1){
      return incrementValue1;
    } else if(btn == 2){
      return incrementValue2;
    } else {
      return -1;
    }
    
  }
  
  public void sendPixels(){
    
    if (serial != null) {
      loadPixels();
      int idx = 0;
      for (int i=0; i<pixels.length; i++) {
        color c = pixels[i];
        buffer[idx++] = (byte)(c >> 16 & 0xFF); // r
        buffer[idx++] = (byte)(c >> 8 & 0xFF);  // g
        buffer[idx++] = (byte)(c & 0xFF);       // b
      }
      serial.write('*');     // The 'data' command
      serial.write(buffer);  // ...and the pixel values
    }
  }
  
}
