class LoadCore extends IAppStates
{
  LoadCore()
  {
    nextAppStates = 0;
    println("Loading core resources...");
  }
  void action()
  {
    // Load images and sounds or something
    setNextState(1);
  }
}

