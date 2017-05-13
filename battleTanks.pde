/*
 
 Battle Tanks   Game - Assignment Two
 
 Authors:       Adam Austin
                Zac Madden
                Scott Nicol
                
 Date:          Y1/T1 2017
 Unit:          COSC101
 
 Description: 
 TODO
 
 Program entry point: setup()
 
 Notes: 
 If game fails to run, please ensure you have the minim sound library installed. 
 Sketch > Import Library > Add Library > Search for minim

 Credits:
 Song used with permission from creator.
 Original content creator: Alexandr Zhelanov
 https://opengameart.org/content/enemy-spotted
 
 Sand dunes background image approved for public use by creator.
 Original content creator: txturs
 https://opengameart.org/content/2048-digitally-painted-tileable-desert-sand-texture

 Rusted concrete wall tile image approved for pubilic use by creator.
 Original content creator: Tiziana
 https://opengameart.org/content/redrust-concrete-wall-512px

 Tank images approved for public use by creator.
 Original content creator: Remos Turcuman
 https://opengameart.org/content/tank-pack-bleeds-game-art
  
 Explosion sprite sheet approved for public use by creator.
 Original content creator: elnineo
 https://opengameart.org/users/elnineo
  
 Explosion sound approved for public use by creator.
 Original content creator: cydon
 http://freesound.org/people/cydon/sounds/268557/

 */

import ddf.minim.*;
import processing.net.*;
import java.net.InetAddress;
import java.net.UnknownHostException;

//constants
final int shotDamage = 60;


//Network stuff
Server s;
Client c;

String dataIn;
byte end = 10;
boolean isServer = true;
String sendMap = "";

String IP = "192.168.1.xxx";
int PORT = 12345;
String LOCAL = "127.0.0.1";
int pe = 0;


Map map;
Menu menu;
// This array is the tile addresses of all the walls
int[] tmp = { 145, 110, 180, 179, 178, 134, 169, 204, 205, 206, 694, 729, 659, 660, 661, 635, 670,
              705, 634, 633, 17, 52, 87, 822, 787, 419, 418, 417, 385, 386, 387,  568,  533,  534,
              499, 586, 515, 192, 191, 193, 227, 18, 16, 821, 823, 384, 454, 289,  253, 324,  288,
              271, 306, 305, 340, 647, 612, 648, 402, 611, 613, 190, 189, 188, 194, 195, 196, 228,
              226, 262, 646, 645, 644, 643, 649, 651, 650, 577, 678, 686, 153, 161, 437, 350, 420,
              551, 550, 401, 436, 367, 472, 403, 438, 752 };


ArrayList<Integer> mapTiles = new ArrayList<Integer>();
float tileSize = 30;
float tileX;
float tileY;
float tilesAcross;
float tilesDown;
int tileNumber;
boolean isLocal = false;
PVector player2LocalCoords = new PVector(960, 630);
//PVector player2LocalCoords = new PVector(60, 200);

//Music player
Minim minim = new Minim(this);
AudioPlayer mainTheme;
AudioSample tankShot;
AudioSample tankExplosion;
boolean music = false;

Player player; //this player
Player player2; //remote player
Score player1Score;
Score player2Score;

ArrayList<Turret> shell;
ArrayList<Turret> enemyShell;
//ArrayList<Turret> rocket;

boolean onMenu;
PImage bg;
PImage tile;

// Varables used for time
int begin;
int time;
int duration;


/**********************************************************************************
 * Method:     setup()
 *
 * Author(s):  Adam Austin
 *             Zac Madden
 *
 * Function:   TODO
 *             
 * Parameters: None
 *
 **********************************************************************************/
void setup(){
  size(1050,720);
  
  shell = new ArrayList<Turret>();
  enemyShell = new ArrayList<Turret>();
  
  //rocket = new ArrayList<Turret>();
  frameRate(30);
  menu = new Menu();
  
  tankShot = minim.loadSample("127845__cyberkineticfilms__tank-fire-mixed.wav");
  tankExplosion = minim.loadSample("268557__cydon__explosion-001.mp3");
  
  //Play theme music
  mainTheme = minim.loadFile("data/Enemy spotted.mp3");
  if(music) {
    mainTheme.loop();
    music = true;
  }
 
  bg = loadImage("sand.jpg");
  bg.resize(1050, 720);
  
  tile = loadImage("04tizeta_redwall.jpg");
  tile.resize(30, 30);
  
  map = new Map(mapTiles);
  tilesAcross = width / tileSize;
  player1Score = new Score();
  player2Score = new Score();
  player = new Player("KV-2_preview.png", "Explosion_001_Tile_8x8_256x256.png", 60, 60, 20, 20);
  player2 = new Player("VK.3601h_preview.png", "Explosion_001_Tile_8x8_256x256.png", -500, -500, 20, 20); //initalise player 2 off screen till they load in (960, 630)
  
}


/**********************************************************************************
 * Method:     draw()
 *
 * Author(s):  Adam Austin
 *             Zac Madden
 *
 * Function:   TODO
 *             
 * Parameters: None
 *
 **********************************************************************************/
void draw(){
  background(bg);
  if(Util.onMenu){
   menu.display();
   //pulls local hostname
    try{
          InetAddress myIp = InetAddress.getLocalHost();
          Util.hostname = myIp.getHostName();
    }
    catch (UnknownHostException e){}
    isServer = menu.getServerStatus();
    isLocal = menu.isLocal();
    
    }    
  else if (isLocal && Util.setup){
    for (int i = 0; i < tmp.length; i++) {
      mapTiles.add(tmp[i]);
    }    
    
    player2.setLocalPlay(true);
    player2.setLocation((int)player2LocalCoords.x, (int)player2LocalCoords.y);
    Util.setup = false;

  }
  
  else{
    //setup networking stuff (runs once only when the network config is set up via the menu)
    
    if (!Util.networkSetup && Util.setup) {
      println("setup");
      if (isServer) {
        println("setup server");
        s = new Server(this, PORT);
        for (int i = 0; i < tmp.length; i++) {
          mapTiles.add(tmp[i]);
        }
      } else {
        println("setup client");
        c = new Client(this, Util.IP, PORT);
      }
      Util.setup = false;
      Util.networkSetup = true;
      isServer = menu.getServerStatus();
     
    }
    
    
  //println("local:" + menu.isLocal());
  //The real draw loop starts here after network stuff is setup
  for (int i = shell.size()-1; i >= 0; i--) {
    Turret s = shell.get(i);
    s.update();
    s.display();
    s.checkCollisions(player2);
    if (s.hit == true) {
      shell.remove(i);
      player2.health -= shotDamage;
      if(player2.health < 0){
       tankExplosion.trigger();
       player2.health = 0;
       player1Score.incrementScore(25);
      }
      //println("Player2 Health:",player2.health);
    }
    if (s.wrap() == true || mapTiles.indexOf(Util.coordToNumber(s.getLocation())) >= 0) { //issue here <<----
      shell.remove(i);
      break;
    }
  }
  
    for (int i = enemyShell.size()-1; i >= 0; i--) {
    Turret e = enemyShell.get(i);
    e.update();
    e.display();
    e.checkCollisions(player);
    if (e.hit == true) {
      enemyShell.remove(i);
      player.health -= shotDamage;
      if(player.health < 0){
       tankExplosion.trigger();
       player.health = 0;
       player2Score.incrementScore(25);
      }
      //println("Player1  Health:",player.health);
    }
    //println(Util.coordToNumber(e.getLocation()));
    if (e.wrap() == true || mapTiles.indexOf(Util.coordToNumber(e.getLocation())) >= 0) {
      enemyShell.remove(i);
      break;
    }
  }

  map.drawMap();  
  
  if(!isLocal){
    readNetwork();
    
    try{
      writeNetwork(); 
    }
    catch (NullPointerException npe){
    //This stops a program crash if there is a brief interuption in the network connection
    }
  }
  
  player.update();
  player2.update();
  player.damage(20, 20, 1, 20, 40);
  player2.damage(930, 20, 2, 930, 40);
  
  player.display();
  player2.display();
  player1Score.display(player1Score.playerScore, 20, 60);
  player2Score.display(player2Score.playerScore, 930, 60);
  
  }
}


/**********************************************************************************
 * Method:     collision()
 *
 * Author(s):  Zac Madden
 *
 *
 * Function:   TODO
 *             
 * Parameters: sx        - 
 *             sy        - 
 *             radius    - 
 *             tx        - 
 *             ty        - 
 *             tw        - 
 *             th        - 
 *
 **********************************************************************************/
boolean collision(float sx, float sy, float radius, float tx, float ty, float tw, float th) {
  
  float tempX = sx;  //
  float tempY = sy;  //
  
  if (sx < tx) {
    tempX = tx;
  } else if (sx > tx + tw) {
  tempX = tx + tw;
  } if (sy < ty) {
    tempY = ty;
  } else if (sy > ty + th)
  tempY = ty + th;
  
  float distX = sx - tempX;  //
  float distY = sy - tempY;  //
  float distance = sqrt((distX * distX) + (distY * distY));  //
  
  if (distance <= radius) {  //
    //println("Hit!");
    return true;
  }
  return false;
}


/**********************************************************************************
 * Method:     readNetwork()
 *
 * Author(s):  Adam Austin
 *
 *
 * Function:   TODO
 *             
 * Parameters: None
 *
 **********************************************************************************/
void readNetwork(){
   //if this is the client, read the data sent over the network
  //until a newline is send, then parse that block, and wait for the next one

  if (isServer == false && c.available() > 0) {
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
}


/**********************************************************************************
 * Method:     writeNetwork()
 *
 * Author(s):  Adam Austin
 *
 *
 * Function:   TODO
 *             
 * Parameters: None
 *
 **********************************************************************************/
void writeNetwork(){
   if (isServer) {
    //println("#PS" + player.getXLocation() + "," + player.getYLocation() + "H" + player.getHeading() + "\n");
    s.write("#PS" + player.getXLocation() + "," + player.getYLocation() + "H" + player.getHeading() + "\n");
  } else {
    //println(isServer);
    c.write("#PS" + player.getXLocation() + "," + player.getYLocation() + "H" + player.getHeading() + "\n");
  } 
}


/**********************************************************************************
 * Method:     parse()
 *
 * Author(s):  Adam Austin
 *
 *
 * Function:   TODO
 *             
 * Parameters: None
 *
 **********************************************************************************/
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
    //println("Player Data: " + inString);
  } else if (inString.charAt(1) == 'M') {
    map.decodeMap(inString);
    //print("Map data: " + inString) ;
  } else if (inString.charAt(1) == 'B'){
     enemyShell.add(new Turret(player2.location, player2.getHeading(), 5));
  }   
}


/**********************************************************************************
 * Method:     keyPressed()
 *
 * Author(s):  Adam Austin
 *             Zac Madden
 *
 * Function:   Event triggered on any press of a key on the keyboard
 *             
 * Parameters: None
 *
 **********************************************************************************/
void keyPressed(){
  if(Util.onMenu){
    menu.select();
  }
  else{
    player.move();
   if(isLocal){
     player2.move();
   }
   //this is used for testing and creating maps. Left in the code on purpose
   //if(key == 'a'){
   // println(mapTiles);
   //}
  }
}


/**********************************************************************************
 * Method:     keyReleased()
 *
 * Author(s):  Adam Austin
 *             Zac Madden
 *
 * Function:   Event triggered on release of any key on the keyboards
 *             
 * Parameters: None
 *
 **********************************************************************************/
void keyReleased(){
  if(isLocal){
    player2.idle();
  }
  
  if( !Util.onMenu && player.idle() && !isLocal){
    if (isServer) {
      //println("#PS" + player.getXLocation() + "," + player.getYLocation() + "H" + player.getHeading() + "\n");
      s.write("#B\n");
    } else {
      //println(isServer);
      c.write("#B\n");
    } 
  }
}

/**********************************************************************************
 * Method:     serverEvent()
 *
 * Author(s):  Adam Austin
 *
 * Function:   Runs when client first connects to server. Used to send map data to client and set remote player position
 *             
 * Parameters: someServer - used to send data to connecting client
 *             someClient - used to establish initial client 
 **********************************************************************************/
// when first connecting, server sends initial co-ords of both players 
// and the map data
void serverEvent(Server someServer, Client someClient) {
  println("We have a new client: " + someClient.ip());   
  int p2x = floor(player2LocalCoords.x); 
  int p2y = floor(player2LocalCoords.y);
  player2.setLocation(p2x, p2y);
  s.write("#PF" + p2x + "," + p2y + "H" + player.getHeading() + "\n");
  s.write("#PS" + player.getXLocation() + "," + player.getXLocation() + "H" + player.getHeading() + "\n");
  for (int i = 0; i < mapTiles.size(); i++) {
    sendMap += mapTiles.get(i)+",";
  }

  s.write("#M" + sendMap + "\n");

}


/**********************************************************************************
 * Method:     mousePressed()
 *
 * Author(s):  Adam Austin
 *
 *
 * Function:   This is for testing and creating maps in deveolpment. Not ment for customer use, but kept for updating and testing purposes
 *             
 * Parameters: None
 *
 **********************************************************************************/
//void mousePressed(){
// if(mapTiles.indexOf(Util.coordToNumber(new PVector(mouseX, mouseY))) < 0){
//   map.newTile(mouseX, mouseY); 
// }
// else{
//  map.remTile(mouseX, mouseY); 
// }
 
//}