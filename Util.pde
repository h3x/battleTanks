/**********************************************************************************
 * Class:     Util
 *
 * Authors:   Adam Austin
 *
 * Function:  Utility class for common tools and variables used throughout the program
 *             
 * Imports:   None
 *
 * Methods:   numberToCoord() - Converts a tile address to a coordinate value
 *            coordToNumber() - Converts a coordinate value to a tile address
 *
 **********************************************************************************/

static class Util {
  
  // Utility class for common tools
  static int tileSize = 30;            // Tiles size for walls
  static boolean onMenu = true;        // Wether or not the menu is active or not
  static String IP = "";               //The IP address for server address 
  static boolean networkSetup = false; // Wether or not the network has been setup for multiplayer 
  static boolean setup = true;         // Wether the setup has completesd in the draw loop
  static String hostname = "";         //The hostname for server address 
  
 /**********************************************************************************
 * Method:         numberToCoord()
 *
 * Author(s):      Adam Austin
 *
 * Function:       Converts a tile address to a coordinate value
 *             
 * Parameters:     num          - The address of the tile in question
 *                 tilesAcross  - How many tiles fit across the screen
 *                 tileSize     - How big each tile is in pixels
 *
 * Return values:  PVector      - The coordinate value of the tile
 *
 **********************************************************************************/
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
  
 /**********************************************************************************
 * Method:         numberToCoord()
 *
 * Author(s):      Adam Austin
 *
 * Function:       Converts a tile address to a coordinate value
 *             
 * Parameters:     num      - The coods of the tile in question
 *
 * Return values:  PVector  - The coordinate value of the tile
 *
 **********************************************************************************/
  static PVector numberToCoord(int num) {
    float tile_Size = 30;
    float tiles_Across = 1050/tile_Size;
    return numberToCoord(num, tiles_Across, tile_Size);
  }

/**********************************************************************************
 * Method:         coordToNumber()
 *
 * Author(s):      Adam Austin
 *
 * Function:       Converts a tile address to a coordinate value
 *             
 * Parameters:     position     - The coods of the tile in question
 *                 tilesAcross  - How many tiles fit across the screen
 *                 tileSize     - How big each tile is in pixels
 *
 * Return values:  Int          - address of the tile represented by the coordinates
 *
 **********************************************************************************/
  static int coordToNumber(PVector position, float tilesAcross, float tileSize) {
    int x = floor(position.x);
    int y = floor(position.y);

    int numX = floor(x / tileSize);
    int numY = floor(y / tileSize);

    return numX + floor( numY * tilesAcross);
  }

/**********************************************************************************
 * Method:         coordToNumber()
 *
 * Author(s):      Adam Austin
 *
 * Function:       Converts a tile address to a coordinate value
 *             
 * Parameters:     position - The coods of the tile in question
 *
 * Return values:  Int      - address of the tile represented by the coordinates
 *
 * Notes:          Overloaded method, passes the values to the first coordToNumber method
 *
 **********************************************************************************/
    static int coordToNumber(PVector position) {
      float tile_Size = 30;
      float tiles_Across = 1050/tile_Size;
      return coordToNumber(position,  tiles_Across, tile_Size);
  
  }
}