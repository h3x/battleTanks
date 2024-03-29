/**********************************************************************************
 * Class:     mapEditor
 *
 * Authors:   Adam Austin
 *
 * Function:  Unfinnished map editor
 *             
 * Imports:   None
 *
 * Note:      This class is unfinnished and does not appear in the current version of the game. It has been left here
 *            for continued work outside of the assignment scope in the future
 *
 **********************************************************************************/

class mapEditor {

  int currentStatus;
  PImage tiles;
  PImage base;

  ArrayList mapTiles = new ArrayList();

  int tileSize = 30;
  int tileX;
  int tileY;
  float tilesAcross;
  float tilesDown;
  int tileNumber;
  int tileType;

  int mode = 0;
  String[] modeText = {"Base", "Floor", "Walls" };

  boolean keyDown = false;

  void startup() {
    //this method runs only once when the map editor is loaded. use for 
    //set up just like in the normal setup() in processing

   // json = loadJSONObject("maps.json");
   // TODO: open file named maps
    tiles = loadImage("tileMap.png");
    tileType = 0;
    tileNumber = -1;
    tilesAcross = width / tileSize;

    imageMode(CENTER);

    currentStatus = 0;
  }


  void drawLoop() {
    //this method runs on every draw loop while the map editor is loaded. use for 
    //normal operations just like the normal draw() in processing

    //this is the "background"
    fill(51);
    rect(0, 0, width, height);

    textSize(32);
    PVector location;

    mode = mode % 3; //base, wall or floor tile editing
    fill(255, 0, 0);
    for (int i = mapTiles.size() -1; i > 0; i--) {
      location= Util.numberToCoord((int)mapTiles.get(i));
      rect(location.x, location.y, tileSize, tileSize);
    }


    int tileSectionX;
    int tileSectionY;
    int baseTileX; // = something - the number address of the tile from the spritesheet
    int baseTileY; // = something
    
    
    //for(int i = 0; i < tileX; i++){
    // for(int j = 0; j < tileY; j++){     

    //   tileSectionX = tileSize * i + (tileSize / 2);
    //   tileSectionY = tileSize * j + (tileSize / 2);       

    //   PImage layer = tiles.get(baseTileX * tileSize , baseTileY * tileSize, tileSize, tileSize );
    //   image(layer, tileSectionX, tileSectionY);

    // }
    //}

    fill(255, 255, 0);
    text(modeText[mode], 10, 30);
    // println(tileNumber);
    //fill(127, 0, 0);


    if (keyPressed) {

      options(key);     
      keyDown = true;
    } else {
      keyDown = false;
    }

    if (mouseButton == LEFT) {
      int tileClicked = Util.coordToNumber(new PVector(mouseX, mouseY));
      if (mapTiles.indexOf(tileClicked) < 0) {
        mapTiles.add(tileClicked);
      }
    } else if (mousePressed && mouseButton == RIGHT) {
      int tileClicked = Util.coordToNumber(new PVector(mouseX, mouseY));
      int arrayIndex = mapTiles.indexOf(tileClicked);
      if(arrayIndex >= 0){
        mapTiles.remove(arrayIndex);
      }
    }
  }

  //this is like the keyPressed() method. the key_pressed argument is the keyCode of the pressed key
  void options(int key_pressed) {
    if (key == CODED && !keyDown) {
      if (keyCode == 112) {
        currentStatus = 1;
      } else if (keyCode == 113) {
        tileType++; 
        //println(json);
      } else if (keyCode == 114) {
        tileType--;
      } else if (keyCode == 115) {
        mode++;
      } else {
        println(keyCode);
      }
    } else if (key != CODED) {
      println(key_pressed);
    }
  }  

  void keyReleased() {
    println("hello");
  }

  int status() {
    return currentStatus;
  }
}