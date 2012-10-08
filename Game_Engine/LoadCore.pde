class LoadCore extends IAppStates
{
  LoadCore()
  {
    nextAppStates = AppStates.LoadCore;
    println("Loading core resources...");
  }
  void action()
  {
    // Load images and sounds or something
    setNextState(AppStates.Menu);
  }
}
