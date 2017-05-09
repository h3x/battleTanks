import ddf.minim.*;
import processing.net.*;

/* Credits

Song used with permission from creator.
Original content creator: Alexandr Zhelanov
https://opengameart.org/content/enemy-spotted

Tank images approved for public use by creator.
Original content creator: Remos Turcuman
https://opengameart.org/content/tank-pack-bleeds-game-art

*/

//Network stuff
Server s;
Client c;

String dataIn;
byte end = 10;
boolean isNet = true;
boolean isServer = true; // change this to false for the client side
String sendMap = "";

String IP = "192.168.1.xxx";
int PORT = 12345;
String LOCAL = "127.0.0.1";

//map stuff
Map map;
int[] tmp = {191, 225, 259, 293, 327, 361, 397, 433, 469, 505, 541, 577, 613, 579, 545, 511, 477, 443, 375, 409, 123, 157, 159, 195, 231, 267, 303, 339};
ArrayList<Integer> mapTiles = new ArrayList<Integer>();
float tileSize = 30;
float tileX;
float tileY;
float tilesAcross;
float tilesDown;
int tileNumber;

//Music player
Minim minim = new Minim(this);
AudioPlayer mainTheme;
AudioPlayer tankShot;
boolean music = false;

Player player; //this player
Player player2; //remote player
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

// Varables used for time
int begin;
int time;
int duration;

void setup(){
  size(1050,720);

  mainMenu = loadImage("mainMenu.png");
  creditScreen = loadImage("credits.png");
      
  //player = new Player("KV-2_preview.png");
  editor = new mapEditor();
  shell = new ArrayList<Turret>();
  //rocket = new ArrayList<Turret>();
  
  menuPosition = 1;
  
  frameRate(30);
  onMenu = true;
  mapMaker = false;
  
  tankShot = minim.loadFile("127845__cyberkineticfilms__tank-fire-mixed.wav");
  
  //Play theme music
  mainTheme = minim.loadFile("data/Enemy spotted.mp3");
  if(!music) {
    mainTheme.loop();
    music = true;
  }
  
  map = new Map(mapTiles);
  tilesAcross = width / tileSize;

  if (isServer == true) {
    s = new Server(this, PORT);
    for (int i = 0; i < tmp.length; i++) {
      mapTiles.add(tmp[i]);
    }
  } else {
    c = new Client(this, LOCAL, PORT);
  }
  player = new Player("KV-2_preview.png", 50, 50);
  player2 = new Player("KV-2_preview.png", -500, -500); //initalise player 2 off screen till they load in
}


void draw(){
  background(51);

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

  
  //if this is the client, read the data sent over the network
  //until a newline is send, the parse that block, and wait for the next one
  if (!isServer && c.available() > 0) {
    String inString = c.readStringUntil(end); 
    parse(inString);
  } 
  //if this is the server, wait until a data is started, then capture it and process
  else if (isServer) {
    c = s.available();
    if (c != null) {
      String inString = c.readStringUntil(end); 
      parse(inString);
    }
  }
      //write new location to client/server
  if (isServer) {
    println("#PS" + player.getXLocation() + "," + player.getYLocation() + "H" + player.getHeading() + "\n");
    s.write("#PS" + player.getXLocation() + "," + player.getYLocation() + "H" + player.getHeading() + "\n");
  } else {
    c.write("#PS" + player.getXLocation() + "," + player.getYLocation() + "H" + player.getHeading() + "\n");
  }
  
  map.drawMap();
  player.display();
  player.update();
  player.collision();
  player2.display();
  player2.update();
  }
}

void parse(String inString) {

  //filter out any noise and errors, if an error occurs, bail and return
  try {
    if (inString.charAt(0) != '#') {
      return;
    }
  }
  catch (NullPointerException npe) {
    return;
  }
  //println(inString);

  //Player movement decoding
  if (inString.charAt(1) == 'P') {
    String playerData = inString.substring(3);
    int newX = int(playerData.substring(0, playerData.indexOf(',')));
    int newY = int(playerData.substring(playerData.indexOf(',')+1, playerData.indexOf('H')));
    float newHeading = float(playerData.substring(playerData.indexOf('H') + 1, playerData.length()-1));
    //Player 1 (i.e this player)
    if (inString.charAt(2)== 'F') {
      player.setLocation(newX, newY);
      player.setHeading(newHeading);

    //Player 2 (i.e remote player)
    } else if (inString.charAt(2)== 'S') {
      player2.setLocation(newX, newY);
      player2.setHeading(newHeading);
    }

    println("Player Data: " + inString);
  } else if (inString.charAt(1) == 'M') {
    map.decodeMap(inString);

    print("Map data: " + inString) ;
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
  
  //if (keyCode == ' ') {
  //  shell.add(new Turret(player.location));
  //}
}

// when first connecting, server sends initial co-ords of both players 
// and the map data
void serverEvent(Server someServer, Client someClient) {
  println("We have a new client: " + someClient.ip()); 
  int randX = floor(random(width)); 
  int randY = floor(random(height));
  player2.setLocation(randX, randY);
  s.write("#PF" + randX + "," + randY + "H" + player.getHeading() + "\n");
  s.write("#PS" + player.getXLocation() + "," + player.getXLocation() + "H" + player.getHeading() + "\n");
  for (int i = 0; i < mapTiles.size(); i++) {
    sendMap += mapTiles.get(i)+",";
  }

  s.write("#M" + sendMap + "\n");

  //println(player.getXLocation() + "," + player.getYLocation()); 
  //println("map: " + sendMap + "\n");
  //println("player 2 loaded at " + randX + ", " + randY);
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
    //MultiPlayer
    if(menuPosition == 1 && select){
     onMenu = false; 
    }
    
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