class mapEditor {

  int currentStatus;
  
  JSONObject json;

  void startup() {
    //
    //JSONArray values  = new JSONArray(); 

    //String[] mapName = {"The Desert", "The Forrest", "Adam's playground" };
    //String[] fileName = {"desert.json", "forrest.json", "playground.json" };
    
    //for( int i = 0; i < mapName.length; i++ ){
    // JSONObject maps = new JSONObject();
     
    // maps.setInt("id", i);
    // maps.setString("mapName", mapName[i]);
    // maps.setString("fileName", fileName[i]);
     
    // values.setJSONObject(i, maps);
      
    //}
    
    //json = new JSONObject();
    //json.setJSONArray("maps", values);
    
    //saveJSONObject(json, "data/maps.json");
    
    json = loadJSONObject("maps.json");
    
    
    //this method runs only once when the map editor is loaded. use for 
    //set up just like in the normal setup() in processing

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

    fill(127, 0, 0);
    ellipse(height/2, width/2, 100, 100);

    if (keyPressed) {
      options(keyCode);
      
    }
  }

  //this is like the keyPressed() method. the key_pressed argument is the keyCode of the pressed key
  void options(int key_pressed) {
    
    if (key_pressed == 112) {
      currentStatus = 1;
    }
  }
  

  int status() {
    return currentStatus;
  }
}