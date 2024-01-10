SnowFlake[] snow;

void setup() {
  size(800, 600);
  textFont(loadFont("f.vlw"));

  snow = new SnowFlake[600];
  for (int i=0; i<snow.length; i++) {
    snow[i] = new SnowFlake();
  }
}


void draw() {
  background(0);

  //for (int i=0; i<snow.length; i++) {
  for (SnowFlake s : snow) {
    s.fall();
    s.display();
  }
}
