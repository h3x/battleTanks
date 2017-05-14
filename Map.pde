/**********************************************************************************
 * Class:     Map
 *
 * Authors:   Adam Austin
 *
 * Function:  Create and update the map. The map is just referenced walls on a background image. scince only the walls have any interaction
 *            with the user (collisions), there is no need to complecate this with trying to work with floor tiles aswell
 *             
 * Imports:   None
 *
 * Methods:   drawMap()          - Draws the tiles contained in the wall array
 *            decodeMap()        - Decodes a network string into an array of integers that describe the positions of the walls 
 *            newTile()          - Adds a tile to the wall array by either reference to the tile address or an x,y coord (overloaded method)
 *            remTile()          - Removes a tile from the wall array. Used mainly during development for map creation
 *            addABunchOfTiles() - Adds multiple tiles at once by suppling the methond with an int array of tile addresses
 *
 **********************************************************************************/

class Map {

  ArrayList<Integer> newMap;
  PVector location;
  int tileSize;
  int tilesAcross;
  
  
 /**********************************************************************************
 * Method:     Constructor
 *
 * Author(s):  Adam Austin
 *
 * Function:   Create a new map object
 *             
 * Parameters: newMap - Interger ArrayList of the tiles to be used for walls. Can be either filled or empty and added to later
 *
 **********************************************************************************/
  Map(ArrayList<Integer> newMap) {
    this.newMap = newMap;
    tileSize = Util.tileSize;
    tilesAcross = width / tileSize;
}


 /**********************************************************************************
 * Method:       drawMap()
 *
 * Author(s):    Adam Austin
 *               Zac Madden
 *
 * Function:     When placing tiles on the screen, the image is added from
 *               this function.
 *             
 * Parameters:   None
 *
 **********************************************************************************/
  void drawMap() {
    fill(200,60,20);
    stroke(0);
    for (int i = mapTiles.size() -1; i >= 0; i--) {
      location = Util.numberToCoord((int)mapTiles.get(i), tilesAcross, tileSize );
      imageMode(CORNER);
      image(tile, location.x, location.y);
      //rect(location.x, location.y, tileSize, tileSize);
    }
  }


 /**********************************************************************************
 * Method:       decodeMap()
 *
 * Author(s):    Adam Austin
 *
 * Function:     Decodes a string containing map addresses into an int array, then passes 
 *                it to the newTile method to add the tiles referenced in the array
 *             
 * Parameters:   mapString - A string containing tile addresses. Would look something like "#M204,43,12,43,123,4\n"
 *
 **********************************************************************************/
  void decodeMap(String mapString) {
   
    //get rid of datatype identifyer, and trailing noise elements (, \n etc)
    mapString = mapString.substring(2, mapString.length()-2);
    int[] tmpMap = int(mapString.split(","));
    for (int i = 0; i < tmpMap.length; i++) {
      newTile(tmpMap[i]);
    }
  }


 /**********************************************************************************
 * Method:       newTile()
 *
 * Author(s):    Adam Austin
 *
 * Function:     Adds a new tile at the specified x, y coords 
 *             
 * Parameters:   x - the X coord of the new tile
 *               y - the Y coord of the new tile
 *
 **********************************************************************************/
  void newTile(int x, int y) {
    int tileClicked = Util.coordToNumber(new PVector(x, y), tilesAcross, tileSize);
    if (mapTiles.indexOf(tileClicked) < 0) {
      mapTiles.add(tileClicked);
    }
  }


 /**********************************************************************************
 * Method:       newTile()
 *
 * Author(s):    Adam Austin
 *
 * Function:     Adds a new tile at the specified tile address
 *             
 * Parameters:   None
 *
 **********************************************************************************/
  void newTile(int tileClicked) {
    if (mapTiles.indexOf(tileClicked) < 0) {
      mapTiles.add(tileClicked);
    }
  }


 /**********************************************************************************
 * Method:       remTile()
 *
 * Author(s):    Adam Austin
 *
 * Function:     Removes a tile at the specified x, y coords 
 *             
 * Parameters:   x - the X coord of the tile
 *               y - the Y coord of the tile
 *
 **********************************************************************************/
  void remTile(int x, int y) {
    int tileClicked = Util.coordToNumber(new PVector(mouseX, mouseY), tilesAcross, tileSize);
    int arrayIndex = mapTiles.indexOf(tileClicked);
    if (arrayIndex >= 0) {
      mapTiles.remove(arrayIndex);
    }
  }


 /**********************************************************************************
 * Method:       addABunchOfTiles()
 *
 * Author(s):    Adam Austin
 *
 * Function:     Adds a set of tiles at the specified tile addresses contained in the newMap array
 *             
 * Parameters:   newMap - Int array containing the tiles addresses of the new tiles
 *
 **********************************************************************************/
  void addABunchOfTiles(int[] newMap){
    for(int i = 0; i < newMap.length; i++){
     if(mapTiles.indexOf(newMap[i]) < 0){
      newTile(tmp[i]); 
     }
    }
  }
}