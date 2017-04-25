//creates a player object with a provided spritesheet

class Player {

  PImage spriteSheet;
  int num = 0;
  PVector location;
  ArrayList<PImage> dir = new ArrayList<PImage>();

  PImage go_left;
  PImage go_up;
  PImage go_down;
  PImage go_right;

  public Player(String file) {
    spriteSheet = loadImage(file);
    location = new PVector(width/2, height/2);

    go_right = spriteSheet.get(1166, 7, 100, 110);
    go_up = spriteSheet.get(2330, 7, 100, 110);
    go_down = spriteSheet.get(25, 7, 100, 110);

    //just gets the right image, flips it, and sets it as the left image
    PImage flipped = createImage(go_right.width, go_right.height, ARGB);
    for (int y = 0; y < go_right.height; y++) {
      for (int x = 0; x < go_right.width; x++) {
        flipped.set(go_right.width-x-1, y, go_right.get(x, y));
      }
    }
    go_left = flipped;

    dir.add(go_right);
    dir.add(go_up);
    dir.add(go_down);
    dir.add(go_left);
  }

  void display() {

    image(dir.get(num), location.x, location.y);
  }

  void update() {

    if ( num == 3) {
      location.x -= 2;
    } else if ( num == 0) {
      location.x += 2;
    } else if ( num == 1) {
      location.y -= 2;
    } else if ( num == 2) {
      location.y += 2;
    }
  }

  void move(int code) {
    //37 > left
    //38 > up
    //39 > right
    //40 > down

    if (code == 37) {
      num = 3;
      ;
    }
    if (code == 38) {
      num = 1;
    }
    if (code == 39) {
      num = 0;
    }
    if (code == 40) {
      num = 2;
    }
  }
}