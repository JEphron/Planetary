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
    fill(64,128,255);
    rect(0 ,0,width,height);
    println(x);
    fill(255,220,40);
    ellipse(width/2,height/2,200,200);

    // Call this to signal that the game should end\
    //setNextState(AppStates.Exit);
  }
}

