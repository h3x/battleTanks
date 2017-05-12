//creates a turret object

class Turret {
  
  PVector location;
  PVector acceleration;
  PVector velocity;
  
  boolean hit = false;
  
  //float radius;
  
  float x, y;
  float r;
  
  public Turret(float x, float y, float r, float heading) {
    this.location = new PVector(x, y);
    velocity = PVector.fromAngle(heading + PI/2);
    this.x = x;
    this.y = y;
    this.r = r;
    
  }
  
    public Turret(PVector location, float heading, float r) {
    this.location = location.copy();
    velocity = PVector.fromAngle(heading + PI/2);
    this.r = r;
  }
  
  void checkCollisions(Player p) {
    
    hit = collision(getLocation().x, getLocation().y, r, p.getXLocation(), p.getYLocation(), p.w, p.h);

}
  
  void display() {
    //TODO
    //Replace ellipse with an image of a tank shell
   // println(location);
    pushMatrix();
    //pushStyle();
    translate(location.x, location.y);
    stroke(255);
    //fill(87, 87, 87);
    fill(255);
    ellipse(0,0, r, r);
    popMatrix();
    //popStyle();
    
  }
  
  
  void update() {
    velocity.setMag(20);    
    this.location.add(velocity);
    
  }

  
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
  
  PVector getLocation(){
   return location; 
  }
}