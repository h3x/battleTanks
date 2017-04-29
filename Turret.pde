//creates a turret object

class Turret {
  
  PVector location;
  PVector velocity;
  
  float radius;
  
  public Turret(PVector location) {
    this.location = location.copy();
    velocity = PVector.fromAngle(player.heading + PI/2);
    velocity.mult(25);
    
  }
  
  
  void display() {
    //TODO
    //Replace ellipse with an image of a tank shell
    pushStyle();
    stroke(87, 87, 87);
    fill(167, 167, 167);
    ellipse(location.x, location.y, radius+5, radius+5);
    popStyle();
    
  }
  
  
  void update() {
    
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
}