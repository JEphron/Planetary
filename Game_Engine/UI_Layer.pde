///////////////////////////////////////////////
// This file contains the UI_Layer class
///////////////////////////////////////////////

// The planet health bar goes at the top of the screen. It is a quad with slanted sides. It is red with pink stripes
// Health of platforms float above them
// Your money is a text value
// there is a gold bar with light yellow stripes
// All these things are contained within the UI layer, a stationary layer that holds UI elements and recieves mouseClicks

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
  PVector boxSize = new PVector();
  UITray(PVector po, PVector si)
  {
    pos = po;
    s = si;
  }

  void action()
  {
    this.display();
  }

  void display()
  {
    fill(100, 100, 100, 100);
    stroke(0);
    rect(0, height-150, width,150);
    for (int i = 0; i < boxes.size(); i++)
    {
      UIBox b = (UIBox)boxes.get(i);
      b.action();
    }
  }

  void addItem(UIBox u) 
  {
    boxes.add(u);
    layoutItems();
  }

  void layoutItems()
  {
    int boxHeight = (int)boxSize.y;
    int place = 0;
    int bufferDistance = int(s.y - (boxes.size() * boxHeight))/(boxes.size()+1);
    for (int i = boxes.size()-1; i >= 0; i--) {
      MenuButton b = (MenuButton)boxes.get(i);
      place += bufferDistance;
      b.setPosition(new PVector(width/2 - boxSize.x/2, place));
      place += boxHeight;
    }
  }
}

// It's a little boxy thing that you click on and stuff
class UIBox extends UIItem
{
  PImage img;
  Platform pl;
  UIBox(PVector po, PVector si, Platform p)
  {
    pos = po; 
    s = si;
    pl = p;
  }

  void action()
  {
    if (mousePressed) {
      checkClick();
    }
    this.display();
  }

  void display()
  {
    fill(200);
    rect(pos.x, pos.y, s.x, s.y);
  }

  boolean checkClick()
  {
    if (pointInRect(new PVector(mouseX, mouseY), pos, s))
    {
      println("Meeppppppp");
      return true;
    }
    else return false;
  }
}

