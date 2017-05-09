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
boolean isServer = true; // change this to false for the client side
String sendMap = "";

String IP = "192.168.1.xxx";
int PORT = 12345;
String LOCAL = "127.0.0.1";
int pe = 0;


Map map;
Menu menu;

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



// Varables used for time
int begin;
int time;
int duration;

void setup(){
  size(1050,720);

  shell = new ArrayList<Turret>();
  //rocket = new ArrayList<Turret>();
  frameRate(30);
  menu = new Menu();

  tankShot = minim.loadFile("127845__cyberkineticfilms__tank-fire-mixed.wav");
  
  //Play theme music
  mainTheme = minim.loadFile("data/Enemy spotted.mp3");
  if(music) {
    mainTheme.loop();
    music = true;
  }
 
 
  map = new Map(mapTiles);
  tilesAcross = width / tileSize;


  
  player = new Player("KV-2_preview.png", 50, 50);
  player2 = new Player("KV-2_preview.png", -500, -500); //initalise player 2 off screen till they load in
}


void draw(){
  background(51);
  if(Util.onMenu){
   menu.display();
  }
  else{
    //setup networking stuff (runs once only when the network config is set up via the menu)
    isServer = menu.getServerStatus();
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
    }
    
  
  //The real draw loop starts here after network stuff is setup
  for (int i = shell.size()-1; i >= 0; i--) {
    Turret s = shell.get(i);
    s.update();
    s.display();
    
    if (s.wrap() == true) {
      shell.remove(i);
      break;
    }
  }

  
  readNetwork();
  map.drawMap();   
  player.update();
  player2.update();
  
  try{
    writeNetwork(); 
  }
  catch (NullPointerException npe){
  //This stops a program crash if there is a brief interuption in the network connection
  }
  
  player.display();
  player2.display();
  
  
  
  }
}

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

void writeNetwork(){
   if (isServer) {
    //println("#PS" + player.getXLocation() + "," + player.getYLocation() + "H" + player.getHeading() + "\n");
    s.write("#PS" + player.getXLocation() + "," + player.getYLocation() + "H" + player.getHeading() + "\n");
  } else {
    //println(isServer);
    c.write("#PS" + player.getXLocation() + "," + player.getYLocation() + "H" + player.getHeading() + "\n");
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
  if(Util.onMenu){
    menu.select();
  }
  else{
    //add if statement here to check for localPlay boolean, and player2.moveLocal() will be called (need to create that with different key bondiongs)
   player.move();
  }
}


void keyReleased(){
  player.idle(); 
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

}