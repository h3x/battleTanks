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
 * Methods:   TODO
 *
 **********************************************************************************/

class Turret {
  
  PVector location;
  PVector acceleration;
  PVector velocity; 
  
  boolean hit = false; //
  
  float x, y; //
  float r; //radius of tank shell shot
  
  
 /**********************************************************************************
 * Method:     Constructor
 *
 * Author(s):  Zac Madden
 *
 * Function:   TODO
 *             
 * Parameters: TODO
 *
 * Notes:      TODO
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
 * Method:     Constructor
 *
 * Author(s):  Adam Austin
 *
 * Function:   TODO
 *             
 * Parameters: TODO
 *
 * Notes:      TODO
 *
 **********************************************************************************/
    public Turret(PVector location, float heading, float r) {
    this.location = location.copy();
    velocity = PVector.fromAngle(heading + PI/2);
    this.r = r;
  }
  
  
/**********************************************************************************
 * Method:     checkCollisions()
 *
 * Author(s):  Zac Madden
 *
 *
 * Function:   TODO
 *
 *             
 * Parameters: Player p    - 
 *
 **********************************************************************************/
  void checkCollisions(Player p) {
    
    hit = shellTankCollision(getLocation().x, getLocation().y, r,
          p.getXLocation(), p.getYLocation(), p.w, p.h);

}
  
  
/**********************************************************************************
 * Method:     display()
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
  void display() {
    
    pushMatrix();
    translate(location.x, location.y);
    stroke(255);
    fill(255);
    ellipse(0,0, r, r);
    popMatrix();
    
  }
  

/**********************************************************************************
 * Method:     update()
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
  void update() {
    velocity.setMag(20);    
    this.location.add(velocity);
    
  }

  
/**********************************************************************************
 * Method:     wrap()
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
 * Method:     getLocation()
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
  PVector getLocation(){
   return location; 
  }
}