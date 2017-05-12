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
  boolean isLocal = false;
  boolean visible = true;
  
  float angle;
  float heading;
  
  float x, y;
  float w, h;
  
  int health;
  int counter;

  ArrayList<PVector> coordMap;
  
  PImage tank;
  PImage explosion;

  //ArrayList<PVector> mapCoords;

  public Player(String file, String file2, float x, float y, float w, float h) {
    tank = loadImage(file);
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    heading = 0;
    health = 100;
    tileSize = Util.tileSize;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    
    explosion = loadImage(file2);
    
    coordMap = new ArrayList<PVector>();
    for (int i = 0; i < mapTiles.size(); i++) {
      coordMap.add(Util.numberToCoord(mapTiles.get(i)));
    }
  }


  void acceleration() {
    acceleration = PVector.fromAngle(heading + PI/2);
    acceleration.mult(3.0);
    //check for walls before allowing movement forward
    if (walls(acceleration)) {
      velocity.add(acceleration);
    }
  }


  void deceleration() {
    acceleration = PVector.fromAngle(heading + PI/2);
    acceleration.mult(-2);

    //check for walls before allowing movement backwards
    if (walls(acceleration)) {
      velocity.add(acceleration);
    }
  }


  void steering(float angle) {
    
    heading += angle;
    
  }


  boolean walls(PVector dir) {
    // println(coordMap.size());
    PVector velCopy = velocity.copy();
    PVector locCopy = location.copy();

    velCopy.add(dir);
    locCopy.add(velCopy);
    //noStroke();
    for (int i = 0; i< coordMap.size(); i++) {
      if (locCopy.x > coordMap.get(i).x -15 && locCopy.x < coordMap.get(i).x + tileSize + 15) {
        if (locCopy.y > coordMap.get(i).y - 15 && locCopy.y < coordMap.get(i).y + tileSize + 15) {
          return false;
        }
      }
    }
    return true;
  }
  
  
  void damage(int x, int y, int p, int q, int r) {
    
    pushStyle();
    fill(255,0,0);
    rect(x, y, health, 10);
    popStyle();
    pushStyle();
    fill(255);
    textSize(20);
    text("Player "+p, q, r);
    popStyle();
    
  }
  
  
  void explosion() {
    
    if (health <= 0) {
      visible = false;
      int w = 256;
      int x = counter % 8 * w;
      int y = counter / 4 * w;
      
      pushMatrix();
      translate(location.x-62.5, location.y-62.5);
      scale(0.5, 0.5);
      copy(explosion, x, y, w, w, 0, 0, w, w);
      counter += 1;
      popMatrix();
      if (counter >= 64) {
        location = getRandomLocation();
        health = 100;
        visible = true;
        return;
      }
    }
    else{
     counter = 0; 
    }
  }


  void display() {
    
    pushMatrix();
    imageMode(CENTER);

    translate(location.x, location.y);
    rotate(heading);
    scale(0.2, 0.15);
    if(visible){
      image(tank, 0, 0);
    }
    popMatrix();

    //stroke(255, 0, 0);
    //rect(location.x-10,location.y- 10, w, h);

    if (shotFired == true && frameCount % 100 == 0) {
      shotFired = false;
    }
    explosion();
  }


  void update() {


    if ( coordMap.size() <= 0) {
      onConnect();
    }

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
    if (isLocal == false) {
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
    } else {
      if (key == 'w'|| key == 'W') {
        goForward = true;
      }
      if (key == 's'|| key == 'S') {
        goBack = true;
      }
      if (key == 'a'|| key == 'A') {
        turnLeft = true;
      }
      if (key == 'd'|| key == 'D') {
        turnRight = true;
      }
    }
  }

  boolean idle() {

    if (isLocal == false) {
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
      if (keyCode == ' ' && shotFired == false && visible) {
        tankShot.play();
        shell.add(new Turret(getXLocation(), getYLocation(), 5, player.heading));
        shotFired = true;
        tankShot.rewind();
        return true;
      }
      return false;
    } else {
      if (key == 'w'|| key == 'W') {
        goForward = false;
      }
      if (key == 's'|| key == 'S') {
        goBack = false;
      }
      if (key == 'a'|| key == 'A') {
        turnLeft = false;
      }
      if (key == 'd'|| key == 'D') {
        turnRight = false;
      }
      if (keyCode == 16 && shotFired == false) {
        tankShot.play();
        enemyShell.add(new Turret(location, heading, 5));
        shotFired = true;
        tankShot.rewind();
        return true;
      }
      return false;
    }
  }

  void setVelocity(int x, int y) {
    location.add(new PVector(x, y));
  }

  void setLocation(int x, int y) {
    location.x = x;
    location.y = y;
  }


  void onConnect() {
    for (int i = 0; i < mapTiles.size(); i++) {
      coordMap.add(Util.numberToCoord(mapTiles.get(i)));
    }
  }

  float getHeading() {
    return heading;
  }

  void setHeading(float heading) {
    this.heading = heading;
  }
  
  PVector getRandomLocation(){
    PVector rLoc;
    while(true){
      rLoc = new PVector(floor(random(width)), floor(random(height)));
      if( mapTiles.indexOf(Util.coordToNumber(rLoc)) < 0 ){
       return rLoc; 
      }
    }
    
  }
  
  int getXLocation() {
    return int(location.x);
  }

  int getYLocation() {
    return int(location.y);
  }

  void setLocalPlay(boolean isLocal) {
    this.isLocal = isLocal;
    // println("player class: "+ isLocal);
  }

}