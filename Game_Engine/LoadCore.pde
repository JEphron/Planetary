class LoadCore extends IAppStates
{
  LoadCore()
  {
    nextAppStates = AppStates.LoadCore;
    println("Loading core resources...");

  }
  void action()
  {
    // Load images and sounds or whatever
    setNextState(AppStates.Menu);
  }
}
