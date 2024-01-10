let port;
let connectBtn;
let led;

const TOTAL_WIDTH  = 32;
const TOTAL_HEIGHT = 32;
const NUM_CHANNELS = 3;
const BAUD_RATE    = 921600;

function setup() {
  createCanvas(400, 400);

  led = createGraphics(TOTAL_WIDTH, TOTAL_HEIGHT);

  port = createSerial();

  try{"serial"in navigator?ports=navigator.serial.getPorts():"usb"in navigator&&(ports=serial.getPorts())}
  catch(e){alert("Serial port cannot be initialized, please try with another browser or Google Chrome.")}
  
  connectBtn = createButton('>');
  connectBtn.mousePressed(connectBtnClick);

  noSmooth();
  led.pixelDensity(1);
  led.noStroke();

  frameRate(20);
}

function draw() {

  led.background(0);
  led.fill(50);
  let d = map(mouseX, 0, 400, 0, 32);
  led.ellipse(led.width / 2, led.height / 2, d, d);

  image(led, 10, 10, TOTAL_WIDTH * 10, TOTAL_HEIGHT * 10);
  image(led, TOTAL_WIDTH * 10 + 20, 10, TOTAL_WIDTH, TOTAL_HEIGHT);

  // ----------------------------------------
  // Send Pixels data to the matrix; Do not edit these lines
  if (port.opened()){
    const buffer = new Uint8Array(TOTAL_WIDTH * TOTAL_HEIGHT * NUM_CHANNELS + 1);
    
    led.loadPixels();

    console.log(led.pixels.length);

    var bufferIndex = 0;

    for (let i = 0; i < led.pixels.length; i += 4) {
          buffer[bufferIndex++] = led.pixels[i + 0];
          buffer[bufferIndex++] = led.pixels[i + 1];
          buffer[bufferIndex++] = led.pixels[i + 2];
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