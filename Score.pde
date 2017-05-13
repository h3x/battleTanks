/**********************************************************************************
 * Class:     Score
 *
 * Authors:   Zac Madden
 *            Scott Nicol
 *
 * Function:  TODO
 *             
 * Imports:   TODO
 *
 * Methods:   TODO
 *
 **********************************************************************************/

class Score {
  
  int playerScore;
  
  
/**********************************************************************************
 * Method:     incrementScore()
 *
 * Author(s):  Zac Madden
 *             Scott Nicol
 *
 *
 * Function:   TODO
 *
 *             
 * Parameters: s         - 
 *
 **********************************************************************************/
  public void incrementScore(int s) {
    
    playerScore += s;
    
  }
  

/**********************************************************************************
 * Method:     display()
 *
 * Author(s):  Zac Madden
 *             Scott Nicol
 *
 * Function:   TODO
 *
 *             
 * Parameters: playerScore - 
 *             scoreY      - 
 *             scoreX      -
 *
 **********************************************************************************/
  public void display(int playerScore, int scoreX, int scoreY) {
    
    pushStyle();
    fill(255);
    textSize(20);
    text("Score   "+playerScore, scoreX, scoreY);
    popStyle();
    
  }
  
}