ArrayList<SnowFlake> snow;

void setup() {
  size(800, 600);
  textFont(loadFont("f.vlw"));

  snow = new ArrayList();
}


void draw() {
  background(0);
  
  if (frameCount % 2 == 0) {
    snow.add(new SnowFlake(random(width), -random(10, 100)));
  }

  if (mousePressed) {
    for (int i=0; i<5; i++) {
      snow.add(new SnowFlake(mouseX + random(-20, 20), mouseY + random(-20, 20)));
    }
  }
  
   
   for (int i = snow.size()-1; i>0; i--) {
     SnowFlake s = snow.get(i);
      s.fall();
      if (s.y >= height + 30) {
        snow.remove(s);
      }
   }


  for (SnowFlake s : snow) {
   
    s.display();
  }
}
