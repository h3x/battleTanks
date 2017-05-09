static class Util {
  
  // Utility class for common tools
  static int tileSize = 30;
  static boolean onMenu = true;
  static String IP = "";
  static boolean networkSetup = false;
  static boolean setup = true;
  static String hostname = "localhost";
  
  
  
  
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