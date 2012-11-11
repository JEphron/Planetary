///////////////////////////////////////////////
// MenuScene holds a number of menuButtons, handles layout and drawing.
// Different menu screens should be subclasses of this. 
///////////////////////////////////////////////

abstract class MenuScene 
{
  PVector pos;
  ArrayList buttons; 
  String title;
  PVector buttonSize; // Change this to adjust button size
  color bgCol = color(30); 
  String nextScene;
  String transDir = "Down";

  MenuScene() {
    buttons = new ArrayList();
    pos = new PVector(0, 0);
  }

  void setNextScene(String m) {
    nextScene = m;
  }
  String getNextScene() {
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

  void addButton(String t, String scene, PVector bSize, MenuScene parent) {
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

    if (transDir == "Up") {
      tvec.y = -speed;
      if (pos.y+height < 0)
        return true;
    }
    else if (transDir == "Down") {
      tvec.y = speed;
      if (pos.y > height)
        return true;
    }
    else if (transDir == "Left") {
      tvec.x = -speed;
      if (pos.x + width < 0)
        return true;
    }
    else if (transDir == "Right") {
      tvec.x = speed;
      if (pos.x > width)
        return true;
    }
    else {
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

        if (transDir == "Left")
          b.setPosition(new PVector(b.getPosition().x + width, b.getPosition().y));
        else if (transDir == "Down")
          b.setPosition(new PVector(b.getPosition().x, b.getPosition().y-height));
      }
      //pos.x += tvec.x;
      if (transDir == "Left")
        pos.x += width;
      else if (transDir == "Down")
        pos.y -= height;

      derp = true;
    }

    if (transDir == "Up") {
      tvec.y = -speed;
      if (pos.y+height < 0)
        return true;
    }
    else if (transDir == "Down") {
      tvec.y = speed;
      if (pos.y > 0) 
        pos.y = 0;
        return true;
    }
    else if (transDir == "Left") {
      tvec.x = -speed;
      if (pos.x < 0) 
        pos.x = 10;
        return true;
    }
    else if (transDir == "Right") {
            tvec.x = speed;
      if (pos.x > width)
        return true;

    }
    else {
      return false;
    }

    for (int i = buttons.size()-1; i >= 0; i--) {
      MenuButton b = (MenuButton)buttons.get(i);
      if (transDir == "Left") {
        if (b.getPosition().x + 90 > width/2)
          b.setPosition(new PVector(b.getPosition().x + tvec.x, b.getPosition().y + tvec.y));
      }
      else {
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
    transDir = "Left";
    nextScene = "Main";
    buttonSize = new PVector(200, 50);
    bgCol = color(100, 50, 50);
    // Add menu items in the constructor, reverse order
    this.addButton("Quit", "Exit", buttonSize, this);
    this.addButton("Help", "Help", buttonSize, this);
    this.addButton("Options", "Options", buttonSize, this);
    this.addButton("Play", "Play", buttonSize, this);
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
    nextScene = "Help";
    transDir = "Up";

    bgCol = color(32, 128, 64);
    buttonSize = new PVector(200, 50);
    this.addButton("Return", "Main", buttonSize, this);
    this.addButton("derp", "Derp", buttonSize, this);

    this.layoutButtons();
  }
}

class mm_Derp extends MenuScene
{
  mm_Derp()
  {
    title = "Derp";
    nextScene = "Derp";

    transDir = "Right";
    bgCol = color (128, 64, 32);
    buttonSize = new PVector(200, 50);
    this.addButton("Return", "Main", buttonSize, this);
    this.addButton("Blurrrgh", "Help", buttonSize, this);
    this.addButton("Meep", "Help", buttonSize, this);
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
    nextScene = "Options";

    transDir = "Right";
    bgCol = color (128, 64, 32);
    buttonSize = new PVector(200, 50);
    this.addButton("Return", "Main", buttonSize, this);
    this.addButton("Blurrrgh", "Help", buttonSize, this);
    this.addButton("Meep", "Help", buttonSize, this);
    this.layoutButtons();
  }
  void action()
  {
    super.action();
  }
}

