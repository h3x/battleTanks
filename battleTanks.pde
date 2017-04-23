Player player;
boolean onMenu;
boolean mapMaker;
mapEditor editor;

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
  editor = new mapEditor();
    
  menuPosition = 1;
  
  frameRate(30);
  onMenu = true;
  mapMaker = false;
}

void draw(){
  
  if(onMenu){
   menu(); 
  }
  else if( !onMenu && mapMaker ){
    editor.drawLoop();
    if(editor.status() == 1){
      onMenu = true;
      mapMaker = false;
    };
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
  
  
  // TODO: if in game:
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
    
    //Map Builder
    if(menuPosition == 3 && select){
      onMenu = false;
      mapMaker = true;
      editor.startup();
    }
    //Exit 
    else if(menuPosition == 4 && select){
      exit(); 
    }
    //Credits screen
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