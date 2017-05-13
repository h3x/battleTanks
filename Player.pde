/**********************************************************************************
 * Class:     Player
 *
 * Authors:   Zac Madden
 *            Adam Austin
 *
 * Function:  TODO
 *             
 * Imports:   TODO
 *
 * Methods:   TODO
 *
 **********************************************************************************/

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


 /**********************************************************************************
 * Method:     Constructor
 *
 * Author(s):  Zac Madden
 *             Adam Austin
 *
 * Function:   TODO
 *             
 * Parameters: TODO
 *
 * Notes:      TODO
 *
 **********************************************************************************/
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


/**********************************************************************************
 * Method:     acceleration()
 *
 * Author(s):  Zac Madden
 *             Adam Austin
 *
 * Function:   TODO
 *
 *             
 * Parameters: None
 *
 **********************************************************************************/
  void acceleration() {
    acceleration = PVector.fromAngle(heading + PI/2);
    acceleration.mult(3.0);
    //check for walls before allowing movement forward
    if (walls(acceleration)) {
      velocity.add(acceleration);
    }
  }


/**********************************************************************************
 * Method:     deceleration()
 *
 * Author(s):  Zac Madden
 *             Adam Austin
 *
 * Function:   TODO
 *
 *             
 * Parameters: None
 *
 **********************************************************************************/
  void deceleration() {
    acceleration = PVector.fromAngle(heading + PI/2);
    acceleration.mult(-2);

    //check for walls before allowing movement backwards
    if (walls(acceleration)) {
      velocity.add(acceleration);
    }
  }


/**********************************************************************************
 * Method:     steering()
 *
 * Author(s):  Zac Madden
 *
 *
 * Function:   TODO
 *
 *             
 * Parameters: None
 *
 **********************************************************************************/
  void steering(float angle) {
    
    heading += angle;
    
  }


/**********************************************************************************
 * Method:     walls()
 *
 * Author(s):  Adam Austin
 *
 *
 * Function:   TODO
 *
 *             
 * Parameters: None
 *
 **********************************************************************************/
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
  
  
/**********************************************************************************
 * Method:     damage()
 *
 * Author(s):  Zac Madden
 *
 * Function:   
 *             
 * Parameters: x         - 
 *             y         - 
 *                       - 
 *             playerNum - 
 *             dmgMeterX - 
 *             dmgMeterY - 
 *
 **********************************************************************************/
  
  void damage(int x, int y, int playerNum, int dmgMeterX, int dmgMeterY) {
    
    pushStyle();
    fill(255,0,0);
    rect(x, y, health, 10);
    popStyle();
    pushStyle();
    fill(255);
    textSize(20);
    text("Player "+playerNum, dmgMeterX, dmgMeterY);
    popStyle();
    
  }
  
  
/**********************************************************************************
 * Method:     explosion()
 *
 * Author(s):  Zac Madden
 *             Adam Austin
 *
 * Function:   Animates an explostion when player health
 *             is less than or equal to zero
 *             
 * Parameters: None
 *
 **********************************************************************************/
  void explosion() {
    
    if (health <= 0) {
      visible = false;
      /*
      sw        - abbreviation for 'sprite width'
      sh        - abbreviation for 'sprite height'
                    - cuts 256x256 sections from the sprite sheet
      sx        - X coordinate of the sprite sheet upper left corner
      sy        - Y coordinate of the sprite sheet upper left corner
      counter   - increments through each row of the sprite 8 times
                  in order to cut 8 256x256 images
      */
      int sw = 256;
      int sh = 256;
      int sx = counter % 8 * sw;  //
      int sy = counter / 8 * sh;  //
      
      pushMatrix();
      translate(location.x-62.5, location.y-62.5);
      scale(0.5, 0.5);
      copy(explosion, sx, sy, sw, sh, 0, 0, sw, sh);
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


/**********************************************************************************
 * Method:     display()
 *
 * Author(s):  Zac Madden
 *             Adam Austin
 *
 * Function:   TODO
 *
 *             
 * Parameters: None
 *
 **********************************************************************************/
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


/**********************************************************************************
 * Method:     update()
 *
 * Author(s):  Zac Madden
 *             Adam Austin
 *
 * Function:   TODO
 *
 *             
 * Parameters: None
 *
 **********************************************************************************/
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


/**********************************************************************************
 * Method:     move()
 *
 * Author(s):  Zac Madden
 *             Adam Austin
 *
 * Function:   TODO
 *
 *             
 * Parameters: None
 *
 **********************************************************************************/
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


/**********************************************************************************
 * Method:     idle()
 *
 * Author(s):  Zac Madden
 *             Adam Austin
 *
 * Function:   TODO
 *
 *             
 * Parameters: None
 *
 **********************************************************************************/
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


/**********************************************************************************
 * Method:     setVelocity()
 *
 * Author(s):  Adam Austin
 *
 *
 * Function:   TODO
 *
 *             
 * Parameters: x         - 
 *             y         - 
 *
 **********************************************************************************/
  void setVelocity(int x, int y) {
    location.add(new PVector(x, y));
  }


/**********************************************************************************
 * Method:     setLocation()
 *
 * Author(s):  Adam Austin
 *
 *
 * Function:   TODO
 *
 *             
 * Parameters: x         - 
 *             y         - 
 *
 **********************************************************************************/
  void setLocation(int x, int y) {
    location.x = x;
    location.y = y;
  }

/**********************************************************************************
 * Method:     onConnect()
 *
 * Author(s):  Adam Austin
 *
 *
 * Function:   TODO
 *
 *             
 * Parameters: None
 *
 **********************************************************************************/
  void onConnect() {
    for (int i = 0; i < mapTiles.size(); i++) {
      coordMap.add(Util.numberToCoord(mapTiles.get(i)));
    }
  }

/**********************************************************************************
 * Method:     getHeading()
 *
 * Author(s):  Adam Austin
 *
 *
 * Function:   TODO
 *
 *             
 * Parameters: None
 *
 **********************************************************************************/
  float getHeading() {
    return heading;
  }

/**********************************************************************************
 * Method:     setHeading()
 *
 * Author(s):  Adam Austin
 *
 *
 * Function:   TODO
 *
 *             
 * Parameters: None
 *
 **********************************************************************************/
  void setHeading(float heading) {
    this.heading = heading;
  }

/**********************************************************************************
 * Method:     getRandomLocation()
 *
 * Author(s):  Adam Austin
 *
 *
 * Function:   TODO
 *
 *             
 * Parameters: None
 *
 **********************************************************************************/
  PVector getRandomLocation(){
    PVector rLoc = new PVector(0,0);
    boolean insideATile = false;
    while(!insideATile){
      insideATile = true;
      rLoc = new PVector(floor(random(width)), floor(random(height)));      
       for (int i = 0; i< coordMap.size(); i++) {
        if (rLoc.x > coordMap.get(i).x -15 && rLoc.x < coordMap.get(i).x + tileSize + 15) {
          if (rLoc.y > coordMap.get(i).y - 15 && rLoc.y < coordMap.get(i).y + tileSize + 15) {
           insideATile = false;
          }
        }
       }
      
      }
      return rLoc; 
  }
  
/**********************************************************************************
 * Method:     getXLocation()
 *
 * Author(s):  Adam Austin
 *
 *
 * Function:   TODO
 *
 *             
 * Parameters: None
 *
 **********************************************************************************/
  int getXLocation() {
    return int(location.x);
  }


/**********************************************************************************
 * Method:     getYLocation()
 *
 * Author(s):  Adam Austin
 *
 *
 * Function:   TODO
 *
 *             
 * Parameters: None
 *
 **********************************************************************************/
  int getYLocation() {
    return int(location.y);
  }


/**********************************************************************************
 * Method:     setLocalPlay()
 *
 * Author(s):  Adam Austin
 *
 *
 * Function:   TODO
 *
 *             
 * Parameters: None
 *
 **********************************************************************************/
  void setLocalPlay(boolean isLocal) {
    this.isLocal = isLocal;
    // println("player class: "+ isLocal);
  }

}