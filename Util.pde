/**********************************************************************************
 * Class:     Util
 *
 * Authors:   Adam Austin
 *
 * Function:  Utility class for common tools used by classes and objects
 *             
 * Imports:   None
 *
 * Methods:   numberToCoord()  - Converts tile number to an x, y coord 
 *            coordToNumber()  - Convert a coordinate to a numbered tile
 **********************************************************************************/

static class Util {
  
  //static variables for use throughout the program
  static int tileSize = 30;
  static boolean onMenu = true;
  static String IP = "";
  static boolean networkSetup = false;
  static boolean setup = true;
  static String hostname = "";
  
  
  /***********************************************************************************************************
   * Method:     numberToCoord()
   *
   * Authors:    Adam Austin
   *
   * Function:   Take the address of a tile and return its coordinates in pixels
   *
   *             
   * Parameters: num          - The number of the tile in question
   *             tilesAcross  - How many tiles fit across the screen at the current resoloution
   *             tileSize     - The tile size in pixels
   *
   * Returns:    PVector of the coordinates
   *
   * Notes:      There are 2 versions of the function depending on how many parameters are used
   *
   * 
   ************************************************************************************************************/

  static PVector numberToCoord(int num, float tilesAcross, float tileSize) {
    float tileX =  (num % tilesAcross ) * tileSize;
    float tileY;
    if (num >= tilesAcross) {
      tileY = floor(num / tilesAcross) * tileSize;
    } else {
      tileY = 0;
    }
    return new PVector(tileX, tileY);
  }
  
  static PVector numberToCoord(int num) {
    float tile_Size = 30;
    float tiles_Across = 1050/tile_Size;
    return numberToCoord(num, tiles_Across, tile_Size);
  }

  /***********************************************************************************************************
   * Method:     coordToNumber()
   *
   * Authors:    Adam Austin
   *
   * Function:   Take the coordinates of a tile and return its address
   *
   *             
   * Parameters: position     - The coordinates of the location in question
   *             tilesAcross  - How many tiles fit across the screen at the current resoloution
   *             tileSize     - The tile size in pixels
   *
   * Returns:    PVector of the coordinates
   *
   * Notes:      There are 2 versions of the function depending on how many parameters are used
   *
   * 
   ************************************************************************************************************/
  static int coordToNumber(PVector position, float tilesAcross, float tileSize) {
    int x = floor(position.x);
    int y = floor(position.y);

    int numX = floor(x / tileSize);
    int numY = floor(y / tileSize);

    return numX + floor( numY * tilesAcross);
  }
  
    static int coordToNumber(PVector position) {
      float tile_Size = 30;
      float tiles_Across = 1050/tile_Size;
      return coordToNumber(position,  tiles_Across, tile_Size);
  
  }
}