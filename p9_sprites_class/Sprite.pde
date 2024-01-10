class Sprite {
  PImage[] sequence;
  int currentFrame;
  int speed; // 1: fastest... 10: slow, etc.
  boolean loop;
  int width, height;

  Sprite(String spriteSheetFileName, int numSprites, int speed) {
    PImage spriteSheet = loadImage(spriteSheetFileName);
    width = spriteSheet.width / numSprites;
    height = spriteSheet.height;
    sequence = new PImage[numSprites];
    for (int i=0; i<numSprites; i++) {
      sequence[i] = spriteSheet.get(width * i, 0, width, height);
    }

    this.loop = true;
    this.speed = speed;
  }

  void step(int frame) {
    if (frame % speed == 0) {
      if (loop) {
        currentFrame = (currentFrame + 1) % sequence.length;
      } else {
        currentFrame = min(sequence.length-1, currentFrame + 1);
      }
    }
  }

  void draw(PGraphics target, int x, int y) {
    target.image(sequence[currentFrame], x, y);
  }
}
