Player player;

void setup(){
  size(800,800);
  player = new Player("data/tank00.png");

  frameRate(20);
}

void draw(){
  background(0);
  player.update();
  player.display();
  
}


void keyPressed(){
 player.move(keyCode); 
}