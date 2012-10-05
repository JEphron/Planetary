// app manager positions all the editor panels and handles input
class AppManager {  
  SceneView sView;

  AppManager() {
    // init whatever
    sView = new SceneView(200, 200, 600, 600);
  }

  void manage() {
    // put the behavior panel on the right

    // put the tilebar on the bottom

    // put the toolbar on the left

    // put the SceneView in the middle
    sView.action();

    // is the mouse down?
    if (mousePressed)
      dispatchInput();
  }

  void dispatchInput() {
    // check to see which panel has mouse (only if the mouse is down).
    // I think this should be more efficient than checking inside each object.
    if (pointInRect(new PVector(mouseX, mouseY), sView.getPosition(), sView.getSize()))
      sView.handleMouse();
  }
}

/* * * *
 * Returns true if the point pt is inside the 
 * rectangle specified by pos and s (upper left/width/height)
 */
boolean pointInRect(PVector pt, PVector pos, PVector s) {
  if (mouseX >= pos.x && mouseX < s.x+pos.x && mouseY >= pos.y && mouseY <= s.y+pos.y) {
    return true;
  }
  return false;
}

