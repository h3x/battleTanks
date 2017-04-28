//creates a turret object

class Turret {
  
  PVector location;
  PVector velocity;
  
  Turret(PVector location) {
    this.location = location.copy();
    velocity = PVector.fromAngle(player.heading);
    
  }
  
}