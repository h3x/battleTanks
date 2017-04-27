//creates a player object with a provided spritesheet

// Known Bugs:      Jerky animation rotation
//                    - need a better way to restart animation if
//                      frame count is negative or exceeds total frames
//                    - sprite hatch on tank looks noticeable
//                      when changing to flipped sprite

class Player {
  
  PVector location;
  PVector direction;
  
  int numFrames = 37;
  int currentFrame;
  int dir;
  
  float angle;
  
  boolean rotating;
  
  PImage[] tank = new PImage[numFrames];
  PImage spriteSheet;
  PImage flippedSprite;
  
  public Player(String file) {
    spriteSheet = loadImage(file);
    location = new PVector(width/2, height/2);
    direction = PVector.fromAngle(angle - HALF_PI);
    angle = 0;
    dir = 5;
    
    PImage mirroredSprite = createImage(spriteSheet.width, spriteSheet.height, ARGB);
    for (int y = 0; y < spriteSheet.height; y++) {
      for (int x = 0; x < spriteSheet.width; x++) {
        mirroredSprite.set(spriteSheet.width-x-1, y, spriteSheet.get(x, y));
      }
    }
    flippedSprite = mirroredSprite;
  }
  
  
  void display() {
    
    PGraphics merged = createGraphics(4864, 128);
    merged.beginDraw();
    merged.image(spriteSheet, 0, 0);
    merged.image(flippedSprite, 2427, 0);
    merged.endDraw();
    merged.get();
    
    currentFrame = (currentFrame+1) % numFrames;
    for (int i = 0; i < numFrames; i++) {
      tank[i] = merged.get(5 + 128 * dir, 7, 120, 110);
    }
    
    pushMatrix();
    imageMode(CENTER);
    translate(location.x, location.y);
    
    image(tank[(currentFrame+dir) % numFrames], 0, 0);
    popMatrix();
    if (dir >= 37) {
      dir = 0;
    }
    else if (dir <= 0) {
      dir = 37;
    }
    println("Current Frame: " + currentFrame); // for testing
    println("Frame Count: " + numFrames); // for testing
    println("Array Length: " + tank.length); // for testing
  }
  
  
  void update() {
    if (upKey) {
      location.y -= 2;
    }
    if (downKey) {
      location.y += 2;
    }
    if (leftKey) {
      dir += 1;
    }
    if (rightKey) {
      dir -= 1;
    }
  }


  void move() {
    
    if (keyCode == UP) {
       upKey = true;
    }
    if (keyCode == DOWN) {
      downKey = true;
    }
    if (keyCode == LEFT) {
      leftKey = true;
    }
    if (keyCode == RIGHT) {
      rightKey = true;
    }
  }
  
  
  void idle() {
    
    if (keyCode == UP) {
       upKey = false;
    }
    if (keyCode == DOWN) {
      downKey = false;
    }
    if (keyCode == LEFT) {
      leftKey = false;
    }
    if (keyCode == RIGHT) {
      rightKey = false;
    }
  }
}