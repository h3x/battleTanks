//creates a turret object

class Turret {
  
  PVector location;
  PVector acceleration;
  PVector velocity;
  
  float radius;
  
  public Turret(PVector location) {
    this.location = location.copy();
    velocity = PVector.fromAngle(player.heading + PI/2);
    
    
  }
  
    public Turret(PVector location, float heading) {
    this.location = location.copy();
    velocity = PVector.fromAngle(heading + PI/2);
    
    
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
    ellipse(0,0, radius+5, radius+5);
    popMatrix();
    //popStyle();
    
  }
  
  
  void update() {
    velocity.setMag(20);    
    this.location.add(velocity);
    
  }

  
  boolean wrap() {
    if (location.x > width + this.radius) {
      return true;
    } else if (this.location.x < -this.radius) {
      return true;
    }
    if (location.y > height + this.radius) {
      return true;
    } else if (this.location.y < -this.radius) {
      return true;
    }
    return false;
  }
  
  PVector getLocation(){
   return location; 
  }
}