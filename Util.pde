static class Util {
  
  // Utility class for common tools
  
  
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

  static int coordToNumber(PVector position, float tilesAcross, float tileSize) {
    int x = floor(position.x);
    int y = floor(position.y);

    int numX = floor(x / tileSize);
    int numY = floor(y / tileSize);

    return numX + floor( numY * tilesAcross);
  }
}