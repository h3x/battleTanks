/* Credits

Song used with permission from creator.
Original content creator: Alexandr Zhelanov
https://opengameart.org/content/enemy-spotted

Tank images approved for public use by creator.
Original content creator: Remos Turcuman
https://opengameart.org/content/tank-pack-bleeds-game-art

*/

//Music player
import ddf.minim.*;
Minim minim = new Minim(this);
AudioPlayer mainTheme;
boolean music = false;

Player player;
//Turret turret;

ArrayList<Turret> shell;
//ArrayList<Turret> rocket;

boolean onMenu;
boolean mapMaker;
mapEditor editor;

int menuPosition;
boolean select = false;
int menuScreen = 0;

PImage mainMenu;
PImage creditScreen;

void setup(){
  size(1050,720);
  
  mainMenu = loadImage("mainMenu.png");
  creditScreen = loadImage("credits.png");
      
  player = new Player("KV-2_preview.png");
  editor = new mapEditor();
  shell = new ArrayList<Turret>();
  //rocket = new ArrayList<Turret>();
  
  menuPosition = 1;
  
  frameRate(30);
  onMenu = true;
  mapMaker = false;
  
  //Play theme music
  mainTheme = minim.loadFile("data/Enemy spotted.mp3");
  if(!music) {
    mainTheme.loop();
    music = true;
  }
}

void draw(){
  background(255);
  
  for (int i = shell.size()-1; i >= 0; i--) {
    Turret s = shell.get(i);
    s.update();
    s.display();
    if (s.wrap() == true) {
      shell.remove(i);
      break;
    }
  }
    
  if(onMenu){
   menu(); 
  }
  else if( !onMenu && mapMaker ){
    editor.drawLoop();
    if(editor.status() == 1){
      imageMode(CORNER);
      onMenu = true;
      mapMaker = false;
    };
  }
  else{
    player.update();
    player.display();
  }
}


void keyPressed(){
  if(onMenu){
    if(keyCode == UP){
      menuPosition -= 1;
      if(menuPosition == 0){
        menuPosition = 6;
      }
    }
    else if(keyCode == DOWN){
      menuPosition += 1;
      if(menuPosition == 7){
        menuPosition = 1;
      }
    }
    else if(keyCode == 10){
     select = true;   
    }    
  }
  
  
  // TODO: if in game:
  player.move();
}


void keyReleased(){
  if(keyCode == 10){
   select = false; 
  }
  // TODO: if in game:
  player.idle();
  
  if (keyCode == ' ') {
    shell.add(new Turret(player.location));
  }
}

void menu(){

  
  if(menuScreen == 0){
    fill(173,149, 34);
    rect(0,0, height,width);
    fill(143,60,30);
    
    
    int rectPos = 0;
    switch(menuPosition){
     case 1:
       rectPos = 190;
       break;
     case 2:
       rectPos = 260;
       break;       
     case 3:
       rectPos = 330;
       break;
     case 4:
       rectPos = 400;
       break;
     case 5:
       rectPos = 460;
       break;
     case 6:
       rectPos = 520;
       break;
    }
    
    rect(0,rectPos,width,60);    
    image(mainMenu, 0, 0); 
    
    //Map Builder
    if(menuPosition == 3 && select){
      onMenu = false;
      mapMaker = true;
      editor.startup();
    }
    //Exit 
    else if(menuPosition == 6 && select){
      exit(); 
    }
    //Credits screen
    else if(menuPosition == 4 && select){
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