class mapEditor {

  int currentStatus;
  
  PImage tiles;
  //PImage base;
  
  JSONObject json;
  int tileSize = 30;
  int tilesX;
  int tilesY;
  int mode = 0;
  String[] modeText = {"Base", "Floor", "Walls" };
  
  int tileNumber = 0;
  
  boolean keyDown = false;
  
  void startup() {
    //this method runs only once when the map editor is loaded. use for 
    //set up just like in the normal setup() in processing
    
    json = loadJSONObject("maps.json");
    tiles = loadImage("tileMap.png");
    
    tilesX = (int)(width / tileSize);   
    tilesY = (int)(width / tileSize);
    
     
    
    imageMode(CENTER);

    /*TODO:
     open maps.json, load json file, add filenames to a maps array
     open mini menu to load existing map for editing, or to create new map.
     
     load tilemap.png
     
     either load blank file or load existing map, and create with the json file and the tilemap.png
     
     nap time
     
     
     */
    currentStatus = 0;
  }


  void drawLoop() {
    //this method runs on every draw loop while the map editor is loaded. use for 
    //normal operations just like the normal draw() in processing

    fill(51);
    rect(0, 0, height, width); 
    textSize(32);
    
    
    
    int baseTileY = int(tileNumber / 32);
    int baseTileX = tileNumber % 32;
    if(tileNumber != 0){
      baseTileY = int(tileNumber / 30);
    }
    
    mode = mode % 3;
    
    float tileSectionX;
    float tileSectionY;
    
    
      for(int i = 0; i < tilesX; i++){
       for(int j = 0; j < tilesY; j++){     
         JSONArray values = new JSONArray();
         
         tileSectionX = tileSize * i + (tileSize / 2);
         tileSectionY = tileSize * j + (tileSize / 2);       
         
         PImage layer = tiles.get(baseTileX * tileSize , baseTileY * tileSize, tileSize, tileSize );
         image(layer, tileSectionX, tileSectionY);
        
       }
      }
    
    fill(255,0,0);
    text(modeText[mode], 10,30);
   // println(tileNumber);
    //fill(127, 0, 0);
    //ellipse(height/2, width/2, 100, 100);

    if (keyPressed) {
      
      options(key);     
      keyDown = true;
    }
    else{
     keyDown = false; 
    }
    
  }

  //this is like the keyPressed() method. the key_pressed argument is the keyCode of the pressed key
  void options(int key_pressed) {
    if(key == CODED && !keyDown){
      if (keyCode == 112) {
        currentStatus = 1;
      }
      else if(keyCode == 113){
       tileNumber++; 
       //println(json);
      }
      else if(keyCode == 114){
       tileNumber--; 
      }
      else if(keyCode == 115){
       mode++; 
      }
      else{
       println(keyCode); 
      }
    }
    else if(key != CODED){
      println(key_pressed);
      
    }
  }  
  
  void keyReleased(){
   println("hello"); 
  }

  int status() {
    return currentStatus;
  }
}