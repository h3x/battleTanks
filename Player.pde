//creates a player object with a provided spritesheet

class Player {
  int tileSize; 
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector deceleration;
  PVector direction;
  
  boolean goForward;
  boolean goBack;
  boolean turnLeft;
  boolean turnRight;
  boolean shotFired;

  float angle;
  float heading;
  
  ArrayList<PVector> coordMap;
  
  PImage tank;
  
  ArrayList<PVector> mapCoords;
  
  public Player(String file, int x, int y) {
    tank = loadImage(file);
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    tileSize = Util.tileSize;
    
    coordMap = new ArrayList<PVector>();
    for (int i = 0; i < mapTiles.size(); i++) {
      coordMap.add(Util.numberToCoord(mapTiles.get(i)));
    }
  }
  
  
  void acceleration() {
    acceleration = PVector.fromAngle(heading + PI/2);
    acceleration.mult(3.0);
    //check for walls before allowing movement forward
    if (walls(acceleration)){
      velocity.add(acceleration);
    }
  }
  
  
  void deceleration() {
    acceleration = PVector.fromAngle(heading + PI/2);
    acceleration.mult(-2);
    
    //check for walls before allowing movement backwards
    if (walls(acceleration)){
      velocity.add(acceleration);
    }
  }
  
  
  void steering(float angle) {
    heading += angle;
    
  }
  
  
  boolean walls(PVector dir) {

    PVector velCopy = velocity.copy();
    PVector locCopy = location.copy();

    velCopy.add(dir);
    locCopy.add(velCopy);
    noStroke();

    for (int i = 0; i< coordMap.size(); i++) {
      if (locCopy.x > coordMap.get(i).x -15 && locCopy.x < coordMap.get(i).x + tileSize + 15) {
        if (locCopy.y > coordMap.get(i).y - 15 && locCopy.y < coordMap.get(i).y + tileSize + 15) {
          return false;
        }
      }
    }
    return true;

  }

  
  void display() {

    pushMatrix();
    imageMode(CENTER);
    
    translate(location.x, location.y);
    rotate(heading);
    scale(0.2, 0.15);
    image(tank, 0, 0);
    popMatrix();
    
    stroke(255,0,0);
    rect(location.x-10,location.y- 10, 20,20);
    
    if (shotFired == true && frameCount % 100 == 0) {
      shotFired = false;
    }
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
    if (keyCode == ' ' && shotFired == false) {
      tankShot.play();
      shell.add(new Turret(location));
      shotFired = true;
      tankShot.rewind();
    }
  }
  
    void setVelocity(int x, int y){
    location.add(new PVector(x ,y));
  }
  
  void setLocation(int x, int y){
   location.x = x;
   location.y = y;
  }
  
  boolean collision(){
    println(mapCoords);
    
    return true;
  }
  
  float getHeading(){
   return heading; 
  }
  
  void setHeading(float heading){
   this.heading = heading; 
  }
  
  int getXLocation(){
   return int(location.x); 
  }
  
 int getYLocation(){
   return int(location.y); 
  }
  
  ArrayList<PVector> tilesToCoords(){
    ArrayList<PVector> mapCoords = new ArrayList<PVector>();
   for (int i = 0; i < mapTiles.size(); i++){
     mapCoords.add(Util.numberToCoord(mapTiles.get(i)));
   }
   return mapCoords;
  }
  
}