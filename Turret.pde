/**********************************************************************************
 * Class:     Turret
 *
 * Authors:   Zac Madden
 *            Adam Austin
 *
 * Function:  TODO
 *             
 * Imports:   TODO
 *
 * Methods:   checkCollisions()  - Checks for tank on shell collision
 *            display()          - Draws the shell shots
 *            update()           - Update the position of the shell object
 *            wrap()             - Detects if shot has hit the edges of the window
 *            getLocation()      - Returns the location coordinates
 *
 **********************************************************************************/

class Turret {
  
  PVector location;
  PVector acceleration;
  PVector velocity; 
  
  boolean hit = false;
  
  float x, y; //
  float r; //radius of tank shell shot
  
  
 /**********************************************************************************
 * Method:       Constructor
 *
 * Author(s):    Zac Madden
 *
 * Function:     Create a new shell object
 *             
 * Parameters:   x       - X coordinate for location
 *               y       - Y coordinate for location
 *               r       - The shell radius
 *               heading - Keeps track of the current direction
 *
 **********************************************************************************/
  
  public Turret(float x, float y, float r, float heading) {
    this.location = new PVector(x, y);
    velocity = PVector.fromAngle(heading + PI/2);
    this.x = x;
    this.y = y;
    this.r = r;
    
  }


 /**********************************************************************************
 * Method:       Constructor
 *
 * Author(s):    Zac Madden
 *
 * Function:     Create a new shell object for player 2
 *             
 * Parameters:   r        - The shell radius
 *               location - coordinates for location
 *               heading  - Keeps track of the current direction
 *
 **********************************************************************************/
    public Turret(PVector location, float heading, float r) {
    this.location = location.copy();
    velocity = PVector.fromAngle(heading + PI/2);
    this.r = r;
  }
  
  
/**********************************************************************************
 * Method:        shellTankCollision()
 *
 * Author(s):     Zac Madden
 *
 *
 * Function:      Keeps track of both player and shell shot locations,
 *                and returns them to the shellTankCollision() boolean in main().
 *             
 * Parameters:    Player p    - Uses 'p' as a reference to the player class
 *
 **********************************************************************************/
  void checkCollisions(Player p) {
    
    hit = shellTankCollision(getLocation().x, getLocation().y, r,
          p.getXLocation(), p.getYLocation(), p.w, p.h);

}
  
  
/**********************************************************************************
 * Method:       display()
 *
 * Author(s):    Zac Madden
 *
 *
 * Function:     Draws the shell shots on screen
 *
 *             
 * Parameters:   None
 *
 **********************************************************************************/
  void display() {
    
    pushMatrix();
    translate(location.x, location.y);
    stroke(255);
    fill(255);
    ellipse(0,0, r, r);
    popMatrix();
    
  }
  

/**********************************************************************************
 * Method:       update()
 *
 * Author(s):    Zac Madden
 *
 *
 * Function:     Updates the current position of the shot
 *
 *             
 * Parameters:   None
 *
 **********************************************************************************/
  void update() {
    velocity.setMag(20); //magnitude for all shots
    this.location.add(velocity);
    
  }

  
/**********************************************************************************
 * Method:       wrap()
 *
 * Author(s):    Zac Madden
 *
 *
 * Function:     Detects if shot has hit the edges of the window. The array in main()
 *               controls what to do when this happens
 *
 *             
 * Parameters:   None
 *
 **********************************************************************************/
  boolean wrap() {
    if (location.x > width + this.r) {
      return true;
    } else if (this.location.x < -this.r) {
      return true;
    }
    if (location.y > height + this.r) {
      return true;
    } else if (this.location.y < -this.r) {
      return true;
    }
    return false;
  }
  
  
/**********************************************************************************
 * Method:        getLocation()
 *
 * Author(s):     Adam Austin
 *
 *
 * Function:      Returns the location of the object
 *
 *             
 * Parameters:    None
 *
 * Return values: PVector - location of the object
 *
 **********************************************************************************/
  PVector getLocation(){
   return location; 
  }
}