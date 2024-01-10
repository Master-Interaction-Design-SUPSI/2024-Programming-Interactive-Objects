
class SnowFlake {
  float x, y;
  float vy;
  String style;  
  float opacity;
  float size;
  
  float vrot;
  
  float rot;

  String[] styles = {"*", ".", "°", ",", "+"};

  SnowFlake() {
    randomize();
  }

  void randomize() {
    x = random(width);
    y = -random(height);
    style = styles[(int)random(styles.length)];
    vy = random(0.9, 1.6);
    opacity = random(100, 256);
    size = random(0.2, 1.0);
    rot = random(TAU);
    vrot = random(-0.02, 0.02);
  }

  void fall() {
    x = x + random(-1, 1);
    y = y + vy;
    if (y > height + 10) randomize();
    rot += vrot;
  }

  void display() {
    fill(255, opacity);
    textAlign(CENTER, CENTER);
    pushMatrix();
    translate(x, y);
    rotate(rot);
    scale(size);
    text(style, 0, 0);
    popMatrix();
  }
}
