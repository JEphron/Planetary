///////////////////////////////////////////////
// This file contains the UI_Layer class
///////////////////////////////////////////////

// The planet health bar goes at the top of the screen. It is a quad with slanted sides. It is red with pink stripes
// Health of platforms float above them
// Your money is a text value
// there is a gold bar with light yellow stripes
// All these things are contained within the UI layer, a stationary layer that holds UI elements and recieves mouseClicks

// TODO:
//       Implement a drag and drop method.
//       Get placement working. 

// Generic UI Item
class UIItem extends Entity {
}

// Healthbar class is a bar that decreases in length when the object it is attached to takes damage
class HealthBar extends UIItem
{
  Entity parent;
  float maxLife, currLife;
  HealthBar(PVector po, PVector si, Entity p)
  {
    // Pass the healthBar a parent object, healthbar will get the lifeTotal and currentLife and display them. 
    parent = p;
    maxLife = parent.getMaxLife();
    pos = po;
    s = si;
    currLife = 1000;
  }

  void action()
  {
    // Is it economical to do this each frame?
    // Could save some processing if we didn't update each frame.
    currLife = parent.getLife();
    if (currLife < 0)
      currLife = 0;
    this.display();
  }

  void setLife(int l)
  {
    currLife = l;
  }
  void display()
  {
    // Draw a bar with a length proportiional to the percentage of life remaining
    // Color shift could use work though...
    fill(255/(currLife/500), 255 - 255/(currLife/50), 0);
    rect(pos.x, pos.y, s.x*(currLife/maxLife), s.y);
  }
}

// Add: Money display, drawer for platforms, info box, sound controls, pauseButton. UI overlay with fancy imgs or whatever

// Techincally not really an entity, decided not to inherit
class UILayer 
{ 
  ArrayList items;
  UILayer()
  {
    //It's static
    //pos = new PVector(0, 0);
    items = new ArrayList();
  }

  void addUIItem(UIItem t)
  {
    items.add(t);
  }

  void action()
  {
    // Draw some instructions:
    for (int i = items.size()-1; i >= 0; i--) {
      UIItem e = (UIItem)items.get(i);
      e.action();
    }
  }
}

// Contains a number of panels, these are clickable and do things
class UITray extends UIItem
{
  ArrayList boxes = new ArrayList();
  PVector boxSize = new PVector(width/10, height/10);
  UITray(PVector po, PVector si)
  {
    pos = po;
    s = si;
    
    class cbo extends callbackObject
    {
      PlatformType t;
     // cbo(PlatformType p)
     // {
     //   t = p;
     // }
      void callbackMethod()
      {
        
      }
    }
    // when clicked, set placement type. on click, place that type and then reset. 
    this.addItem(new UIBox(boxSize, new cbo(), new StandardPlatform(new PVector(100, 100), new PVector(20, 20))));
    this.addItem(new UIBox(boxSize, new cbo(), new StandardPlatform(new PVector(100, 100), new PVector(20, 20))));
    this.addItem(new UIBox(boxSize, new cbo(), new StandardPlatform(new PVector(100, 100), new PVector(20, 20))));
    this.addItem(new UIBox(boxSize, new cbo(), new StandardPlatform(new PVector(100, 100), new PVector(20, 20))));
  }

  void action()
  {
    this.display();
  }
  int w = width; 
  int h = height;
  void display()
  {

    fill(100, 100, 100, 100);
    stroke(0);
    rect(0, height-150, width, 150);
    for (int i = 0; i < boxes.size(); i++)
    {
      UIBox b = (UIBox)boxes.get(i);
       b.action();
      if (mousePressed) {
        b.checkClick();
      }
    }

    if (w != width || h!= height) {
      boxSize = new PVector(width/10, width/10);
      layoutItems();
    }
    w = width; 
    h = height;
  }

  void addItem(UIBox u) 
  {
    boxes.add(u);
    layoutItems();
  }

  void layoutItems()
  {
    int boxHeight = (int)boxSize.x;
    println(boxHeight);

    int place = 0;
    int bufferDistance = int(width - (boxes.size() * boxHeight))/(boxes.size()+1);
    for (int i = boxes.size()-1; i >= 0; i--) {
      UIItem b = (UIItem)boxes.get(i);
      place += bufferDistance;
      b.setPosition(new PVector(place, height - 100));
      b.setSize(boxSize);
      place += boxHeight;
    }
  }
}

// It's a little boxy thing that you click on and stuff
class UIBox extends UIItem
{
  PImage img;
  Platform pl;
  callbackObject cbo;
  UIBox( PVector si, callbackObject callback, Platform p)
  {
    cbo = callback;
    s = si;
    pl = p;
  }

  void action()
  {
    this.display();
  }

  void display()
  {
    fill(200);
    rect(pos.x, pos.y, s.x, s.y);
    pl.setPosition(new PVector(pos.x+s.x/2, pos.y+s.y/2));
    pl.display();
  }

  boolean checkClick()
  {
    if (pointInRect(new PVector(mouseX, mouseY), pos, s))
    {
      println(pos.x);
      cbo.callbackMethod();
      return true;
    }
    else return false;
  }
}

