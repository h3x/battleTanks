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
 Original content composer: Alexandr Zhelanov
 https://opengameart.org/content/enemy-spotted
 
 Outro Theme on Credits screen composed project team member.
 Original content creator: Zac Madden
 zac.madden@gmail.com
 
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

//Imports
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

//The map!
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

//Music player
Minim minim = new Minim(this);
AudioPlayer mainTheme;
AudioSample tankShot;
AudioSample tankExplosion;
boolean music = false;

Player player; //this player
Player player2; //remote player
Score player1Score; //this player score
Score player2Score; // remote player score

ArrayList<Turret> shell;
ArrayList<Turret> enemyShell;

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
  if(!music) {
    mainTheme.loop();
    music = true;
  }
  
  //background image
  bg = loadImage("sand.jpg");
  bg.resize(1050, 720);
  
  //wall image
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
 * Function:   Draw loop runs every frame
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
    }
    if (s.wrap() == true || mapTiles.indexOf(Util.coordToNumber(s.getLocation())) >= 0) {
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
    }

    if (e.wrap() == true || mapTiles.indexOf(Util.coordToNumber(e.getLocation())) >= 0) {
      enemyShell.remove(i);
      break;
    }
  }

  map.drawMap();    
  //If network game, read and write network data
  if(!isLocal){
    readNetwork();
    
    try{
      writeNetwork(); 
    }
    catch (NullPointerException npe){
    //This stops a program crash if there is a brief interuption in the network connection
    }
  }  
  player.damage(20, 20, 1, 20, 40);
  player2.damage(930, 20, 2, 930, 40);
  
  player1Score.display(player1Score.playerScore, 20, 60);
  player2Score.display(player2Score.playerScore, 930, 60);
  
  player.update();
  player2.update();

  player.display();
  player2.display();
  
  player.checkCollisions(player);
  player2.checkCollisions(player);
  
  }
}


/**********************************************************************************
 * Method:     shellTankCollision()
 *
 * Author(s):  Zac Madden
 *
 *
 * Function:   Calculates the distance between the tank and shell
 *             
 * Parameters: sx        - shell X coordinate
 *             sy        - shell Y coordinate
 *             radius    - shell radius
 *             tx        - tank X coordinate
 *             ty        - tank Y coordinate
 *             tw        - tank width
 *             th        - tank height
 *
 * Returns:    Returns true if the distance is less and or equal to shell radius,
 *             otherwise returns false
 *
 **********************************************************************************/
boolean shellTankCollision(float sx, float sy, float radius, float tx, float ty, float tw, float th) {
  
  float tempX = sx;
  float tempY = sy;
  
  // perform calculations on the parameters to determine distance
  if (sx < tx) {                     //if shot X coord is less than tank X coord
    tempX = tx;                      //assign tank X coord to temp var
  } else if (sx > tx + tw) {         //if shot X coord is greater than tank X coord and tank width
  tempX = tx + tw;                   //assign tank X coord and tank width to temp var
  } if (sy < ty) {                   // if shot Y coord is less than tank Y coord
    tempY = ty;                      //assign tank Y coord to temp var
  } else if (sy > ty + th)           //if shot Y coord is greater than tank Y coord and tank height
  tempY = ty + th;                   //assign tank Y coord and tank height to temp var
  
  float distX = sx - tempX;         //subtract temp X var from shot X coord var
  float distY = sy - tempY;         //subtract temp Y var from shot Y coord var
  float distance = sqrt((distX * distX) + (distY * distY)); //calculate distance
  
  if (distance <= radius) {         //if distance is less than or equal
    return true;                    //then return true
  }
  return false;                     //else return false
}


/**********************************************************************************
 * Method:     tankOnTankCollision()
 *
 * Author(s):  Zac Madden
 *
 *
 * Function:   Calculates the distance between the both tanks
 *             
 * Parameters: tx        - tank X coordinate
 *             ty        - tank Y coordinate
 *             p2tx      - player 2 tank X coordinate
 *             p2ty      - player 2 tank Y coordinate
 *
 * Returns:    Returns true if the distance is less and or equal to tank width
 *             and height, otherwise returns false
 *
 **********************************************************************************/
boolean tankOnTankCollision(float tx, float ty, float p2tx, float p2ty) {
  
  float tempX = tx;
  float tempY = ty; 
  
  // perform calculations on the parameters to determine distance
  if (tx < p2tx) {                 //if tank X coord is less than player 2 tank X coord
    tempX = p2tx;                  //assign player 2 tank X coord to temp var
  } else if (tx > p2tx) {          //if tank X coord is greater than player 2 tank X coord and tank width
  tempX = p2tx;                    //assign player tank X coord and tank width to temp var
  } if (ty < p2ty) {               // if tank Y coord is less than player 2 tank Y coord
    tempY = p2ty;                  //assign player 2 tank Y coord to temp var
  } else if (ty > p2ty + 20)       //if tank Y coord is greater than player 2 tank Y coord and tank height
  tempY = p2ty;                    //assign player 2 tank Y coord and tank height to temp var
  
  float distX = tx - tempX;       //subtract temp X var from tank X coord var
  float distY = ty - tempY;       //subtract temp Y var from tank Y coord var
  float distance = sqrt((distX * distX) + (distY * distY)); //calculate distance
  
  if (distance <= 20) {           //if distance is less than or equal
    return true;                  //then return true
  }
  return false;                   //else return false
}


/**********************************************************************************
 * Method:     readNetwork()
 *
 * Author(s):  Adam Austin
 *
 *
 * Function:   reads network data set from server or client
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
 * Function:   Write player positions to connected player
 *             
 * Parameters: None
 *
 **********************************************************************************/
void writeNetwork(){
   if (isServer) {
    s.write("#PS" + player.getXLocation() + "," + player.getYLocation() + "H" + player.getHeading() + "\n");
  } else {    
    c.write("#PS" + player.getXLocation() + "," + player.getYLocation() + "H" + player.getHeading() + "\n");
  } 
}


/**********************************************************************************
 * Method:     parse()
 *
 * Author(s):  Adam Austin
 *
 *
 * Function:   parse the network data and redirect into classes/methods appropriate to the propper function
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
    
  //Map data
  } else if (inString.charAt(1) == 'M') {
    map.decodeMap(inString);
    
  //shell data
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
 * Function:   detect and react to key presses depending on if theuser is in the menu, player1 or player 2
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
   
   //kept on purpose for map making later. Will be merged into the map editor outside the scope of this assignment
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
 * Function:   detect and react to key release event
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
 *
 * Function:   This is a built in method that runs on client connect. 
 *             Only active on the server side program
 *             
 * Parameters: someServer - this server
 *             someClient - the connecting client
 *
 * Notes:      when first connecting, server sends initial co-ords of both players 
*              and the map data
 **********************************************************************************/
void serverEvent(Server someServer, Client someClient) {
  println("We have a new client: " + someClient.ip());   
  
  //set player 2 onscreen
  int p2x = floor(player2LocalCoords.x); 
  int p2y = floor(player2LocalCoords.y);
  player2.setLocation(p2x, p2y);
  //tell the client where both players are and which way they are facing
  s.write("#PF" + p2x + "," + p2y + "H" + player.getHeading() + "\n");
  s.write("#PS" + player.getXLocation() + "," + player.getXLocation() + "H" + player.getHeading() + "\n");
  // turn the map into a string
  for (int i = 0; i < mapTiles.size(); i++) {
    sendMap += mapTiles.get(i)+",";
  }
  //adn send it to the client
  s.write("#M" + sendMap + "\n");

}


/**********************************************************************************
 * Method:     mousePressed()
 *
 * Author(s):  Adam Austin
 *
 *
 * Function:   Used during map making to add walls. For development only, not for production release
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