class Game extends IAppStates
{
  float x = 0;
  Game()
  {
    nextAppStates = AppStates.Game;
    println("Entering main game...");
  }
  void action()
  {
    // Do game stuff
    // ...
    // Call this to signal that the game should end
    
    fill(64,128,255);
    rect(200,200,300,300);
    //setNextState(AppStates.Exit);
  }
}

