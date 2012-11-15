///////////////////////////////////////////////
// This is the Menu state, it controls and manages
// the creation and deletion of individual menuScenes
// Should also do transitions between menus. 
///////////////////////////////////////////////

// TODO: • Make MenuButton a subclass of MenuItem. We want support for items other than buttons.
//       • Reverse the order of the buttons to make the addition process more user friendly
//       • Come up with a more consitant naming scheme
//       • Add flash to black/white transition.

class Menu extends IAppStates
{
  // enum value
  String nextScene;

  // currently displaying scene
  MenuScene currentScene;

  // scene which is about to be displayed. 
  // If someone thinks of a name that better describes what this does please let me know
  MenuScene newScene;

  Menu()
  {
    println("Entering main menu...");
    nextAppStates = 1;
    // Create the Main scene
    currentScene = createNewScene("Main");
    nextScene = currentScene.getNextScene();
  }
  int w = width;
  int h = height;
  void action()
  {
    // overview:
    // check if the scene has changed it's nextscene variable.
    // if it has, create the new scene underneath the current.
    //  –› Transition the old scene off of the canvas and then delete it.
    //  –› Display the new scene.
    // if it hasn't, keep looping. 

    // Check to see if the window has resized
    if(w!=width ||h!=height)
    {
      // Relayout the buttons if it has
       currentScene.layoutButtons();
       w = width; h = height;
    }
    // update the newScene if it exists
    if (newScene != null) {
      newScene.action();
      //if (currentScene.doFadeOut(20))
      if (currentScene.doSlideOut(50))
      {
        currentScene = newScene;
        newScene = null;
      }
    }

    // Display a menu and implement a menu state system.
    currentScene.action();

    if (currentScene.getNextScene() != nextScene) {
      newScene = createNewScene(currentScene.getNextScene());

      if (currentScene != null)
        nextScene = currentScene.getNextScene();
    }
    //setNextState(AppStates.Game);
  }

  MenuScene createNewScene(String scene)
  {
    // Switch returns scene based on enum
    if ( scene == "Play") {
      setNextState(2);
      return null;
    }
    else if (scene == "Main") {
      return new mm_Main();
    }
    else if (scene == "Options") {
      return new mm_Opts();
    }
    else if (scene == "Derp") {
      return new mm_Derp();
    }
    else if (scene == "Help") {
      return new mm_Help();
    }
    else if (scene == "Exit") {
      setNextState(4);
      return null;
    }
    else return null;

    //    switch(scene) {
    //    case Play:
    //      setNextState(2);
    //      return null;
    //    case Main:
    //      return new mm_Main();
    //    case Options:
    //      return new mm_Opts();
    //    case Derp:
    //      return new mm_Derp();
    //    case Help:
    //      return new mm_Help();
    //    case Exit:
    //      setNextState(4);
    //      return null;
    //    default:
    //      break;
    //    }
  }
}


/* * * *
 * MenuButton holds a text value and performes an
 * action when clicked. If it's going to trigger a
 * scene change it'll return an enum value which will
 * be picked up by the mainMenu state and then created.
 * OVERLOAD: Takes callback object, calls callbackMethod() onClick;
 */
// Note: could extend entity for maximum oop
class MenuButton
{
  // TODO: background/rollover/click images.
  PVector pos = new PVector(0, 0); 
  PVector s; //size
  String label; // the text label of the button
  boolean isCallbackButton = false; // does the button execute a callback?
  color c, oc; // color and original color
  String targetScene; 
  callbackObject callback; // object which gets called if this = callbackButton
  MenuScene parentScene;

  MenuButton(String t, String sc, PVector size, MenuScene parent) {
    s=size;
    label = t;
    targetScene = sc;
    c = oc = color(100, 100, 100);
    parentScene = parent;
  }

  // overload if you need to run actual code;
  MenuButton(String t, PVector size, callbackObject cbo) {
    label = t;
    s=size;
    callback = cbo;
    isCallbackButton = true;
    c = oc =  color(100, 100, 100);
  }

  void update() {
    this.display();
    this.checkMouse();
  }

  void display() {
    // draw a rectangle at pos with width/length of s. Draw text on top of that.
    fill(c);
    rect(pos.x, pos.y, s.x, s.y);
    fill(255);
    textAlign(CENTER);
    text(label, pos.x + s.x/2, pos.y + s.y/2);
  }

  void setPosition(PVector p) {
    pos=p;
  }

  PVector getPosition() {
    return pos;
  }

  void setSize(PVector si) {
    s = si;
  }

  PVector getSize() {
    return s;
  }

  void setColor(color col)
  {
    c = col;
  }

  color getColor() {
    return c;
  }

  void action()
  {
    if (isCallbackButton)
      callback.callbackMethod();
    else {
      parentScene.setNextScene(targetScene);
      println(targetScene);
    }
    mousePressed = false;
  }

  void checkMouse() {
    // should probably sel col on click, call action on release
    if (pointInRect(new PVector(mouseX, mouseY), this.getPosition(), this.getSize())) {
      if (mousePressed) {
        this.setColor(color(red(this.getColor())+120, green(this.getColor()), blue(this.getColor())));
        this.action();
      }
    } 
    else {
      if (!mousePressed)
        this.setColor(oc);
    }
  }
}

/* * * *
 * Because processing doesn't seem to support passing functions as parameters 
 * we're going to have to pass in an object that has a method which can be called. 
 * USAGE: Please subclass this and overwrite the callbackMethod() with whatever 
 * code needs to be called. 
 */
abstract class callbackObject
{
  callbackObject() {
  }
  void callbackMethod()
  {
    // Overwrite this
  }
}

