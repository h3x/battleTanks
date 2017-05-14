/**********************************************************************************
 * Class:     Map
 *
 * Authors:   Adam Austin
 *
 * Function:  TODO
 *             
 * Imports:   TODO
 *
 * Methods:   TODO
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
 * Function:   TODO
 *             
 * Parameters: TODO
 *
 * Notes:      TODO
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
 * Function:     When placing tiles on the screen, the image is obtained from
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
 * Function:     TODO
 *             
 * Parameters:   None
 *
 **********************************************************************************/
  void decodeMap(String mapString) {
    //get rid of datatype identifyer, and trailing noise elements (, \n etc)
    mapString = mapString.substring(2, mapString.length()-2);
    int[] tmpMap = int(mapString.split(","));
    for (int i = 0; i < tmpMap.length; i++) {
      newTile(tmpMap[i]);
    }

    println(tmpMap);
  }


 /**********************************************************************************
 * Method:       newTile()
 *
 * Author(s):    Adam Austin
 *
 * Function:     TODO
 *             
 * Parameters:   None
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
 * Function:     TODO
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
 * Function:     TODO
 *             
 * Parameters:   None
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
 * Function:     TODO
 *             
 * Parameters:   None
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