let port;
let connectBtn;

const TOTAL_WIDTH  = 32;
const TOTAL_HEIGHT = 32;
const NUM_CHANNELS = 3;
const BAUD_RATE    = 921600;

function setup() {
  createCanvas(TOTAL_WIDTH, TOTAL_HEIGHT);

  port = createSerial();

  try{"serial"in navigator?ports=navigator.serial.getPorts():"usb"in navigator&&(ports=serial.getPorts())}
  catch(e){alert("Serial port cannot be initialized, please try with another browser or Google Chrome.")}
  
  connectBtn = createButton('>');
  connectBtn.mousePressed(connectBtnClick);

  noSmooth();
  pixelDensity(1);
  noStroke();
  
  frameRate(20);
}

function draw() {

  background(0,0,0);
  fill(255, 255, 255);
  let d = map(sin(frameCount * 0.1), -1, 1, 3, 30);
  ellipse(width / 2, height / 2, d, d);

  // ----------------------------------------
  // Send Pixels data to the matrix; Do not edit these lines
  if (port.opened()){
    const buffer = new Uint8Array(TOTAL_WIDTH * TOTAL_HEIGHT * NUM_CHANNELS + 1);
    
    loadPixels();

    var bufferIndex = 0;

    for (let i = 0; i < pixels.length; i += 4) {
          buffer[bufferIndex++] = pixels[i + 0];
          buffer[bufferIndex++] = pixels[i + 1];
          buffer[bufferIndex++] = pixels[i + 2];
    }

    port.write(42);      // The 'data' command
    port.write(buffer);  // ...and the pixel values
  }
}

function connectBtnClick() {
  if (!port.opened()) {
    port.open(BAUD_RATE);
    connectBtn.html('x');
  } else {
    port.close();
    connectBtn.html('>');
  }
}