//creates a player object with a provided spritesheet

class Player {
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector deceleration;
  PVector direction;
  
  boolean goForward;
  boolean goBack;
  boolean turnLeft;
  boolean turnRight;
  
  float angle;
  float heading;
  
  PImage tank;
  
  
  public Player(String file) {
    tank = loadImage(file);
    location = new PVector(width/2, height/2);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    
  }
  
  
  void acceleration() {
    acceleration = PVector.fromAngle(heading + PI/2);
    acceleration.mult(5.0);
    velocity.add(acceleration);
    
  }
  
  
  void deceleration() {
    acceleration = PVector.fromAngle(heading + PI/2);
    acceleration.mult(-2.5);
    velocity.add(acceleration);
    
  }
  
  
  void steering(float angle) {
    heading += angle;
    
  }
  
  
  void display() {
    
    pushMatrix();
    imageMode(CENTER);
    translate(location.x, location.y);
    rotate(heading);
    image(tank, 0, 0);
    popMatrix();
    
  }
  
  
  void update() {
    if (goForward) {
      acceleration();
    }
    if (goBack) {
      deceleration();
    }
    if (turnLeft) {
      steering(-0.05);
    }
    if (turnRight) {
      steering(0.05);
    }
    
    location.add(velocity);
    velocity.mult(0.25);
  }


  void move() {
    
    if (keyCode == UP) {
      goForward = true;
    }
    if (keyCode == DOWN) {
      goBack = true;
    }
    if (keyCode == LEFT) {
      turnLeft = true;
    }
    if (keyCode == RIGHT) {
      turnRight = true;
    }
  }
  
  
  void idle() {
    
    if (keyCode == UP) {
      goForward = false;
    }
    if (keyCode == DOWN) {
      goBack = false;
    }
    if (keyCode == LEFT) {
      turnLeft = false;
    }
    if (keyCode == RIGHT) {
      turnRight = false;
    }
  }
}