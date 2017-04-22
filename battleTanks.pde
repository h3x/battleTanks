Player player;
boolean onMenu;
PImage mainMenu;
int menuPosition;

void setup(){
  size(900,900);
  player = new Player("data/tank00.png");
  
  mainMenu = loadImage("mainMenu.png");
  menuPosition = 1;
  
  frameRate(20);
  onMenu = true;
}

void draw(){
  
  if(onMenu){
   menu(); 
  }
  else{
    
    background(255);
    player.update();
    player.display();
  }
}


void keyPressed(){
  if(onMenu){
    if(keyCode == UP){
      menuPosition -= 1;
      if(menuPosition == 0){
        menuPosition = 5;
      }
    }
    else if(keyCode == DOWN){
      menuPosition += 1;
      if(menuPosition == 6){
        menuPosition = 1;
      }
    }
    
  }
  player.move(keyCode); 
}

void menu(){
  
  fill(173,149, 34);
  rect(0,0, height,width);
  fill(143,60,30);
  rect(0,(menuPosition * 150) + 27,width,110);
  image(mainMenu, 0, 0); 
  
}