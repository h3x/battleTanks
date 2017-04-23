Player player;
boolean onMenu;

int menuPosition;
boolean select = false;
int menuScreen = 0;

PImage mainMenu;
PImage creditScreen;

void setup(){
  size(960,960);
  
  mainMenu = loadImage("mainMenu.png");
  creditScreen = loadImage("credits.png");
      
  player = new Player("data/tank00.png");
    
  menuPosition = 1;
  
  frameRate(30);
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
    else if(keyCode == 10){
     select = true;   
    }    
  }
  player.move(keyCode); 
}


void keyReleased(){
  if(keyCode == 10){
   select = false; 
  }
}

void menu(){

  
  if(menuScreen == 0){
    fill(173,149, 34);
    rect(0,0, height,width);
    fill(143,60,30);
    rect(0,(menuPosition * 150) + 27,width,110);
    image(mainMenu, 0, 0); 
    
    println(menuPosition);
    println(select);
    
    if(menuPosition == 4 && select){
      exit(); 
    }
    else if(menuPosition == 5 && select){
       menuScreen = 1; 
       menuPosition = 1;
    }       
  }  
  if(menuScreen == 1){    
    if(menuPosition > 1){      
      fill(143,60,30);
      rect(0,0, height,width);
    }
    else{
      fill(173,149, 34);
      rect(0,0, height,width);
    }    
    image(creditScreen,0,0);
    if(select && menuPosition > 1){
       menuScreen = 0; 
       menuPosition = 1;
    }
  }
}