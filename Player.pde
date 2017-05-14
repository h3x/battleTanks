/**********************************************************************************
 * Class:     Player
 *
 * Authors:   Zac Madden
 *            Adam Austin
 *
 * Function:  Creates and controlls player objects
 *             
 * Imports:   None
 *
 * Methods:   acceleration()     - Moves tank forward or backward on keyPress event
 *            deceleration()     - Stops tank on keyRelease
 *            steering()         - Rotates tank
 *            walls()            - Checks the tank will not move into a wall and blocks that direction if true (uses a lookahead technique)
 *            damage()           - Draws damage meter 
 *            explosion()        - Draws explosions when player dies
 *            display()          - Draws the tank
 *            checkCollisions()  - Checks for tank on tank collision
 *            update()           - Update the position of the tank object
 *            move()             - Runs on the keyPressed event. Used to initiate movement
 *            idle()             - Runs on keyReleased event. Used to terminate movement
 *            setVelocity()      - Sets the velocity of the tank
 *            setLocation()      - Sets the x,y location on the tank (used for network play)
 *            onConnect()        - Runs after the client connects to generate the map from information sent by the server 
 *            getHeading()       - Gets the heading of the tank (used for network play)
 *            setHeading()       - Sets the heading of the tank (used for network play)
 *            getRandomLocation()- Returns a random x,y location for respawn
 *            getXLocation()     - Returns the location X coordinate
 *            getYLocation()     - Returns the location Y coordinate
 *            setLocalPlay()     - Sets the onLocal boolean to true for local play          
 *
 *            
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
  boolean hit = false;
  
  float angle;
  float heading;
  
  float x, y;
  float w, h;
  
  int health;
  int counter;
  int explosionFrames = 120;

  ArrayList<PVector> coordMap;
  
  PImage tank;
  PImage explosion;


 /**********************************************************************************
 * Method:       Constructor
 *
 * Author(s):    Zac Madden
 *               Adam Austin
 *
 * Function:     Create new tank object
 *             
 * Parameters:   file   - File reference of the tank
 *               file2  - File reference of the explosion effect
 *               x      - X coord for location
 *               y      - Y coord for location
 *               w      - Width of the collision detection area
 *               h      - Height of the collision detection area
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
 * Method:         acceleration()
 *
 * Author(s):      Zac Madden
 *                 Adam Austin
 *
 * Function:       Accelerates the player
 *             
 * Parameters:     accel     - Obtains the acceleration speed from move()
 *
 * Return values:  None
 *
 **********************************************************************************/
  void acceleration(int accel) {
    acceleration = PVector.fromAngle(heading + PI/2);
    acceleration.mult(accel);
    
    //check for walls before allowing movement forward
    if (walls(acceleration)) {
      velocity.add(acceleration);
    } 
  }


/**********************************************************************************
 * Method:         deceleration()
 *
 * Author(s):      Zac Madden
 *                 Adam Austin
 *
 * Function:       Stops accelerating the player and reverses tank
 *
 *             
 * Parameters:     decel     - Obtains the deceleration speed from move()
 *
 * Return values:  None
 *
 **********************************************************************************/
  void deceleration(int decel) {
    acceleration = PVector.fromAngle(heading + PI/2);
    acceleration.mult(decel);

    //check for walls before allowing movement backwards
    if (walls(acceleration)) {
      velocity.add(acceleration);
    }
  }


/**********************************************************************************
 * Method:         steering()
 *
 * Author(s):      Zac Madden
 *
 * Function:       Rotates the player
 *           
 * Parameters:     angle     - Keeps track of the angle the player is facing in
 *                             order to move in that direction
 *
 * Return values:  None
 *
 **********************************************************************************/
  void steering(float angle) {    
    heading += angle;    
  }


/**********************************************************************************
 * Method:         walls()
 *
 * Author(s):      Adam Austin
 *
 *
 * Function:       Uses a lookahead technique to figure out if the player _did_ 
 *                 move in the direction intended, will the tank end up inside
 *                 a wall, returns true if path clear, returns false if there 
 *                 is a wall in the way
 *
 *             
 * Parameters:     dir     - The intended acceleration vector
 *
 * Return values:  Boolean - true if all clear
 *                         - false if wall detected at acceleration vector
 *
 **********************************************************************************/
  boolean walls(PVector dir) {
    // println(coordMap.size());
    PVector velCopy = velocity.copy();
    PVector locCopy = location.copy();

    velCopy.add(dir);
    locCopy.add(velCopy);
    // for every tile in the wall array...
    for (int i = 0; i< coordMap.size(); i++) {
      // check for collisions
      if (locCopy.x > coordMap.get(i).x -15 && locCopy.x < coordMap.get(i).x + tileSize + 15) {
        if (locCopy.y > coordMap.get(i).y - 15 && locCopy.y < coordMap.get(i).y + tileSize + 15) {
          // and return false if a collision is detected 
          return false;
        }
      }
    }
    // return true if all clear
    return true;
  }
  
  
/**********************************************************************************
 * Method:         damage()
 *
 * Author(s):      Zac Madden
 *
 * Function:       Displays and updates damage meter indicating player health
 *             
 * Parameters:     dmgMeterX - X location of the damage meter
 *                 dmgMeterY - Y location of the damage meter
 *                 playerNum - Player 1 or player 2
 *                 dmgTextX  - X location of the text "player"
 *                 dmgTextY  - Y location of the text "player"
 *
 * Return values:  None
 *
 **********************************************************************************/
  void damage(int dmgMeterX, int dmgMeterY, int playerNum, int dmgTextX, int dmgTextY) {
    
    pushStyle();
    fill(255,0,0);
    rect(dmgMeterX, dmgMeterY, health, 10);
    popStyle();
    pushStyle();
    fill(255);
    textSize(20);
    text("Player "+playerNum, dmgTextX, dmgTextY);
    popStyle();
    
  }
  
  
/**********************************************************************************
 * Method:        explosion()
 *
 * Author(s):     Zac Madden
 *                Adam Austin
 *
 * Function:      Animates an explostion when player health
 *                is less than or equal to zero
 *             
 * Parameters:    None
 *
 * Return values: None
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
                  in order to cut 8 256x256 images per row
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
      if (counter >= explosionFrames) {
        location = getRandomLocation();
        health = 100;
        visible = true;
        return;
      }
    }
    else{
     counter = 0; //set counter to zero after animation has finished
    }
  }


/**********************************************************************************
 * Method:        display()
 *
 * Author(s):     Zac Madden
 *                Adam Austin
 *
 * Function:      Draw tank object to the screen
 *             
 * Parameters:    None
 * 
 * Return values: None
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

    if (shotFired == true && frameCount % 100 == 0) { //restrict shot frequency
      shotFired = false;
    }
    //rect(location.x -10, location.y -10, 20, 20);
    explosion();
    
    
  }


/**********************************************************************************
 * Method:        checkCollisions()
 *
 * Author(s):     Zac Madden
 *
 *
 * Function:      Keeps track of both player's X and Y coordinates,
 *                and returns them to the tankOnTankCollision()
 *                boolean in main().
 *             
 * Parameters:    Player p    - Uses 'p' as a reference to the player class
 *
 * Return values: None
 *
 **********************************************************************************/
  void checkCollisions(Player p) {
    
    hit = tankOnTankCollision(p.getXLocation(), p.getYLocation(),
                              player2.getXLocation(), player2.getYLocation());
                            }


/**********************************************************************************
 * Method:        update()
 *
 * Author(s):     Zac Madden
 *                Adam Austin
 *
 * Function:      Runs every frame. Wraps player location around edges of the window,
 *                runs player movement methods and updates velocity accordingly
 *             
 * Parameters:    None
 *
 * Return values: None
 *
 **********************************************************************************/
  void update() {

    if ( coordMap.size() <= 0) {
      onConnect();
    }
    
    if(location.x < 0 - (tileSize/2)){
     location.x = width + (tileSize/2); 
    }
    else if(location.x > width + (tileSize/2)){
     location.x = - (tileSize/2); 
    }
    if(location.y < 0 - (tileSize/2)){
     location.y = height + (tileSize/2); 
    }
    else if(location.y > height + (tileSize/2)){
     location.y = - (tileSize/2); 
    }
    
    if (goForward) {
      acceleration(3);
    }
    if (goBack) {
      deceleration(-2);
    }
    if (turnLeft) {
      steering(-0.05);
    }
    if (turnRight) {
      steering(0.05);
    }
    
    location.add(velocity);
    
    if (hit == true) {
      velocity.mult(-0.75); //decrease velocity when tanks collision is true
    } else {
      velocity.mult(0.25); //return to normal velocity if collision is false
    }
    
  }


/**********************************************************************************
 * Method:        move()
 *
 * Author(s):     Zac Madden
 *                Adam Austin
 *
 * Function:      Moves player on keyPress event
 *             
 * Parameters:    None
 *
 * Return values: None
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
 * Method:        idle()
 *
 * Author(s):     Zac Madden
 *                Adam Austin
 *
 * Function:      Stops moving player on keyRelease event
 *
 *             
 * Parameters:    None
 *
 * Return values: Boolean - true if shot was fired (Used for network play)
 *                        - false if any other function
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
        tankShot.trigger();
        shell.add(new Turret(getXLocation(), getYLocation(), 5, player.heading));
        shotFired = true;
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
        tankShot.trigger();
        enemyShell.add(new Turret(location, heading, 5));
        shotFired = true;
        return true;
      }
      return false;
    }
  }


/**********************************************************************************
 * Method:        setVelocity()
 *
 * Author(s):     Adam Austin
 *
 * Function:      Adds PVector(x,y) to the current location
 *             
 * Parameters:    x - X variable of the PVector
 *                y - Y variable of the PVector
 *
 * Return values: None
 *
 **********************************************************************************/
  void setVelocity(int x, int y) {
    location.add(new PVector(x, y));
  }


/**********************************************************************************
 * Method:        setLocation()
 *
 * Author(s):     Adam Austin
 *
 * Function:      Set the location directly (used for network play)
 *             
 * Parameters:    x - X coord of the new location
 *                y - Y coord of the new location
 *
 * Return values: None
 *
 **********************************************************************************/
  void setLocation(int x, int y) {
    location.x = x;
    location.y = y;
  }


/**********************************************************************************
 * Method:        onConnect()
 *
 * Author(s):     Adam Austin
 *
 * Function:      Runs when client connect to server, and server sents new map data. 
 *                Converts and adds all map tile addresses to a coordinate version of the map tiles
 *             
 * Parameters:    None
 *
 * Return values: None
 **********************************************************************************/
  void onConnect() {
    for (int i = 0; i < mapTiles.size(); i++) {
      coordMap.add(Util.numberToCoord(mapTiles.get(i)));
    }
  }


/**********************************************************************************
 * Method:        getHeading()
 *
 * Author(s):     Adam Austin
 *
 *
 * Function:      Returns the current heading
 *
 *             
 * Parameters:    None
 *
 * Return values: Float - current heading
 *
 **********************************************************************************/
  float getHeading() {
    return heading;
  }


/**********************************************************************************
 * Method:        setHeading()
 *
 * Author(s):     Adam Austin
 *
 * Function:      Sets new heading directly
 *           
 * Parameters:    heading - The new heading
 *
 * Return values: None
 *
 **********************************************************************************/
  void setHeading(float heading) {
    this.heading = heading;
  }


/**********************************************************************************
 * Method:        getRandomLocation()
 *
 * Author(s):     Adam Austin
 *
 * Function:      Gets a new random location when the player is destroyed. Avoids spawning the player inside a wall
 *             
 * Parameters:    None
 *
 * Return values: Returns a random PVector(x,y) location for respawn
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
 * Method:         getXLocation()
 *
 * Author(s):      Adam Austin
 *
 * Function:       Returns the players x location
 *             
 * Parameters:     None
 *
 * Return values:  Int - The x location coord
 *
 **********************************************************************************/
  int getXLocation() {
    return int(location.x);
  }


/**********************************************************************************
 * Method:         getYLocation()
 *
 * Author(s):      Adam Austin
 *
 * Function:       Returns the players y location
 *             
 * Parameters:     None
 *
 * Return values:  Int - The y location coord
 *
 **********************************************************************************/
  int getYLocation() {
    return int(location.y);
  }


/**********************************************************************************
 * Method:        setLocalPlay()
 *
 * Author(s):     Adam Austin
 *
 * Function:      Sets isLocal depending on if current game is a local game or network game  
 *             
 * Parameters:    isLocal - if the game is a local game oor network game
 *
 * Return values: None
 *
 **********************************************************************************/
  void setLocalPlay(boolean isLocal) {
    this.isLocal = isLocal;
  }

}