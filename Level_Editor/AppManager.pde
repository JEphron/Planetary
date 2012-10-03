// app manager positions all the editor panels and handles input
class AppManager
{  
  SceneView sView;
  AppManager()
  {
    // init whatever
    sView = new SceneView(50,50,600,600);
  }
  void manage()
  {
    // put the behavior panel on the right
    // put the tilebar on the bottom
    // put the toolbar on the left
    // put the SceneView in the middle
      sView.action();
  }
}

