/**********************************************************************************
 * Class:     Score
 *
 * Authors:   Zac Madden
 *            Scott Nicol
 *
 * Function:  Keeps track of player score and displays on screen
 *             
 * Imports:   None
 *
 * Methods:   incrementScore()   - used to keep track of current score
 *            display();          - displays score on screen
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
 * Function:   The method is called in the shell and enemyShell arrays to give the
 *             player points for destroying the enemy tank
 *
 *             
 * Parameters: s         - Receives argument from shell and enemyShell arrays to
 *                         increment the player score
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
 * Function:   Draws the score on the screen
 *
 *             
 * Parameters: playerScore - Receives score from either player 1 or 2 in main()
 *             scoreX      - X coordinates of where to draw score on screen
 *             scoreY      - Y coordinates of where to draw score on screen
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