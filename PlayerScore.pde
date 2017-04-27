class PlayerScore
{
  int playerScore = 0;
  
  public void incrementScore(int s)
  {
    playerScore += s;  
  }
  
  public void setScore(int s)
  {
    playerScore = s;  
  }
  
  public int getScore()
  {
    return playerScore;  
  }
  
  public void displayScore()
  {
    //textSize(32);
    //fill(127);
    //text(playerScore, 20, 40);  
  }
}