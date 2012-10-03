/* * * *
 * MenuScene holds a number of menuButtons, handles layout and drawing.
 * Different menu screens should be subclasses of this. 
 */
abstract class MenuScene 
{
  PVector pos;
  ArrayList buttons; 
  String title;
  PVector buttonSize; // Change this to adjust button size
  color bgCol = color(30);
  mmScenes nextScene;
  directions transDir = directions.Down;

  MenuScene() {
    buttons = new ArrayList();
    pos = new PVector(0, 0);
  }

  void setNextScene(mmScenes m) {
    nextScene = m;
  }
  mmScenes getNextScene() {
    return nextScene;
  }

  // Consider renaming to more generic layoutItems()
  void layoutButtons() {
    // Formula for buffer distance in a vertically oriented stack of evenly spaced rectangular objects
    // 
    // H - (N*X)
    // ---------  =  D
    //  (N+1)
    //
    // H = height of screen
    // N = number of items
    // X = height of items 
    // D = buffer dist
    int boxHeight = (int)buttonSize.y;
    int place = 0;
    int bufferDistance = int(height - (buttons.size() * boxHeight))/(buttons.size()+1);
    for (int i = buttons.size()-1; i >= 0; i--) {
      MenuButton b = (MenuButton)buttons.get(i);
      place += bufferDistance;
      b.setPosition(new PVector(width/2 - buttonSize.x/2, place));
      place += boxHeight;
    }
  }

  void addButton(String t, mmScenes scene, PVector bSize, MenuScene parent) {
    MenuButton m = new MenuButton(t, scene, bSize, parent);
    buttons.add(m);
  }

  void addCBButton(String t, PVector bSize, callbackObject c) {
    MenuButton m = new MenuButton(t, bSize, c);
    buttons.add(m);
  }

  void action() {
    drawBackground();
    for (int i = buttons.size()-1; i >= 0; i--) {
      MenuButton b = (MenuButton)buttons.get(i);
      b.update();
    }
    drawTitle();
  }

  void drawTitle() {
    textAlign(CENTER);
    fill(255);
    text(title, pos .x + width/2, pos.y + height/20); //  should be positioned better
  }

  void drawBackground() {
    fill(bgCol);
    rect(pos.x, pos.y, width, height);
  }
  boolean doFadeOut(int speed)
  {
    for (int i = buttons.size()-1; i >= 0; i--) {
      MenuButton b = (MenuButton)buttons.get(i);
      b.setColor(color(red(b.getColor()), green(b.getColor()), blue(b.getColor()), alpha(b.getColor()) - speed ));
      println(alpha(b.getColor()));
    }
    bgCol = color(red(bgCol), green(bgCol), blue(bgCol), alpha(bgCol) - speed);

    if (alpha(bgCol) <= 0)
      return true;
    else 
      return false;
  }

  boolean doSlideOut(int speed) {
    PVector tvec = new PVector(0, 0);

    switch(transDir) {
    case Up:
      tvec.y = -speed;
      if (pos.y+height < 0)
        return true;
      break;
    case Down:
      tvec.y = speed;
      if (pos.y > height)
        return true;
      break;
    case Left:
      tvec.x = -speed;
      if (pos.x + width < 0)
        return true;
      break;
    case Right:
      tvec.x = speed;
      if (pos.x > width)
        return true;
      break;
    default:
      return false;
    }

    for (int i = buttons.size()-1; i >= 0; i--) {
      MenuButton b = (MenuButton)buttons.get(i);
      b.setPosition(new PVector(b.getPosition().x + tvec.x, b.getPosition().y + tvec.y));
    }
    pos.x += tvec.x;
    pos.y += tvec.y;
    return false;
  }

  boolean derp=false; // Think of a better way to do this when you aren't so tired. 

  boolean doSlideIn(int speed) {
    PVector tvec = new PVector(0, 0);
    if (!derp) {
      for (int i = buttons.size()-1; i >= 0; i--) {
        MenuButton b = (MenuButton)buttons.get(i);

        if (transDir == directions.Left)
          b.setPosition(new PVector(b.getPosition().x + width, b.getPosition().y));
        else if (transDir == directions.Down)
          b.setPosition(new PVector(b.getPosition().x, b.getPosition().y-height));
      }
      //pos.x += tvec.x;
      if (transDir == directions.Left)
        pos.x += width;
      else if (transDir == directions.Down)
        pos.y -= height;

      derp = true;
    }

    switch(transDir) {
    case Up:
      tvec.y = -speed;
      if (pos.y+height < 0)
        return true;
      break;
    case Down:
      tvec.y = speed;
      if (pos.y > 0) {
        pos.y = 0;
        return true;
      }
      break;
    case Left:
      tvec.x = -speed;
      if (pos.x < 0) {
        pos.x = 10;
        return true;
      }
      break;
    case Right:
      tvec.x = speed;
      if (pos.x > width)
        return true;
      break;
    default:
      return false;
    }

    for (int i = buttons.size()-1; i >= 0; i--) {
      MenuButton b = (MenuButton)buttons.get(i);
      if (transDir == directions.Left){
        if (b.getPosition().x + 90 > width/2)
          b.setPosition(new PVector(b.getPosition().x + tvec.x, b.getPosition().y + tvec.y));
      }else{
     b.setPosition(new PVector(b.getPosition().x + tvec.x, b.getPosition().y + tvec.y));
      }
    }
    pos.x += tvec.x;
    pos.y += tvec.y;
    return false;
  }
}



/* * *
 * mm_Main is the main menu scene,
 * has buttons (play, options, help) 
 */
class mm_Main extends MenuScene
{
  mm_Main()
  {
    title = "Main Menu";
    transDir = directions.Left;
    nextScene = mmScenes.Main;
    buttonSize = new PVector(200, 50);
    bgCol = color(100, 50, 50);
    // Add menu items in the constructor, reverse order
    this.addButton("Quit", mmScenes.Exit, buttonSize, this);
    this.addButton("Help", mmScenes.Help, buttonSize, this);
    this.addButton("Options", mmScenes.Options, buttonSize, this);
    this.addButton("Play", mmScenes.Play, buttonSize, this);
    // Then call layoutButtons();
    this.layoutButtons();
  }
  void action()
  {
    super.action();
  }
}


/* * * *
 * mm_Help is the help/instructions menu. Should have a text box or something with instructions
 */
class mm_Help extends MenuScene
{
  mm_Help()
  {
    title = "";
    nextScene = mmScenes.Help;
        transDir = directions.Up;

    bgCol = color(32,128,64);
    buttonSize = new PVector(200, 50);
    this.addButton("Return", mmScenes.Main, buttonSize, this);
    this.addButton("6", mmScenes.Derp, buttonSize, this);
 
    this.layoutButtons();
    
  }
}

class mm_Derp extends MenuScene
{
  mm_Derp()
  {
    title = "Derp";
    nextScene = mmScenes.Derp;
        
    transDir = directions.Right;
    bgCol = color (128,64,32);
    buttonSize = new PVector(200, 50);
    this.addButton("Return", mmScenes.Main, buttonSize, this);
    this.addButton("Blurrrgh", mmScenes.Help, buttonSize, this);
    this.addButton("Meep", mmScenes.Help, buttonSize, this);
    this.layoutButtons();
  }
}

/* * *
 * mm_Opts is the options menu,
 * lets you adjust sound/speed/whatever
 * Need to implement sliders and toggles. 
 */
class mm_Opts extends MenuScene
{
  mm_Opts()
  {
    title = "Options";
    nextScene = mmScenes.Options;
    buttonSize = new PVector(200, 50);
    // Add menu items in the constructor, reverse order

    ///////////////////////////////////
    // Example of how to use the callback system.
    // 
    // Create a new class that extends callbackObject
    // write your code in the callbackMethod() method
    // create an object of that class
    // create a CBButton and pass it the object
    // **CODE**
    class TestCB extends callbackObject {
      void callbackMethod() {
        println("Callback recieved!");
      }
    }
    TestCB c = new TestCB();
    this.addCBButton("Callback test 1", buttonSize, c);
    // **END**
    ///////////////////////////////////

    this.addButton("Return", mmScenes.Main, buttonSize, this);
    // Then call layoutButtons();
    this.layoutButtons();
  }
  void action()
  {
    super.action();
  }
}

