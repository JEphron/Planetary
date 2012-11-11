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
//       Major overhaul. It's coming. eventually...
// Generic UI Item
class UIItem extends Entity {
  boolean checkClick()
  {
    return false;
  }
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
    fill(map(currLife, 0, maxLife, 255, 0), map(currLife, 0, maxLife/5, 0, 255), 0);
    textAlign(LEFT);
    rect(pos.x, pos.y, s.x*(currLife/maxLife), s.y);
    if (currLife>0)
      fill(255);
    else
      fill(255, 0, 0);
    text(parent.getType()+": "+(int)currLife, pos.x+5+s.x*(currLife/maxLife), pos.y+textAscent()+4);
  }
  Entity getParent() {
    return parent;
  }
}

// Add: Money display, drawer for platforms, info box, sound controls, pauseButton. UI overlay with fancy imgs or whatever

// Techincally not really an entity, decided not to inherit
class UILayer 
{ 
  Minimap mini;
  ArrayList items;
  Notifier nfier;

  UILayer()
  {
    //It's static
    //pos = new PVector(0, 0);
    items = new ArrayList();
    nfier  = new Notifier();
  }

  void addUIItem(UIItem t)
  {
    items.add(t);
  }

  void action()
  {
    // Draw the addable items (healthbar, string, etc)
    for (int i = items.size()-1; i >= 0; i--) {
      UIItem e = (UIItem)items.get(i);
      e.action();
    }

    nfier.action();
  }

  void notify(String s)
  {
    nfier.addMsg(new UIString(s, new PVector(0,0), 800));
  }

  void setPlayerWep(int w)
  {
  }
}

class Notifier extends UIItem
{
  ArrayList msgs;
  Notifier()
  {
    msgs = new ArrayList();
  }

  void addMsg(UIString str)
  {
    msgs.add(str);
    layoutMsgs();
  }

  void action() {
    this.display();
  }
  void display() {
    for (int i = 0; i < msgs.size(); i++) {
      UIString u = (UIString)msgs.get(i);
      u.action();
      u.doFade(); // animate fade in/out
      if (u.isExpired()) {
        u = null;
        msgs.remove(i); 
        layoutMsgs();
      }
    }
  }
  
  void layoutMsgs()
  {
    for (int i = 0; i < msgs.size(); i++) {
      UIString u = (UIString)msgs.get(i);
      u.setPosition(new PVector(width-textWidth(u.getText()), (i*20)));
    }
  }
}

// Contains a number of panels, these are clickable and do things
class UITray extends UIItem
{
  ArrayList items = new ArrayList();
  PVector boxSize = new PVector(width/10, height/10);
  UITray(PVector po, PVector si)
  {
    pos = po;
    s = si;
    type = "UITray";
    // when clicked, set placement type. on click, place that type and then reset.
    class cbo extends callbackObject
    {
      String t;
      cbo(String s) {
        t=s;
      }
      void callbackMethod()
      {
        println(t);
      }
    }
    //this.addItem(new UIString("Controls"));
    this.addItem(new UIString("A to fire"));
    this.addItem(new UIString("S to reset life"));
    this.addItem(new UIString("D to change weps"));
    this.addItem(new UIString("F to place turret"));
    this.addItem(new UIString("G to clear turrets"));

    //     this.addItem(new UIBox(boxSize, new cbo("Three"), new StandardPlatform(new PVector(100, 100), new PVector(20, 20))));
    //    this.addItem(new UIBox(boxSize, new cbo("Three"), new StandardPlatform(new PVector(100, 100), new PVector(20, 20))));
    //    this.addItem(new UIBox(boxSize, new cbo("Four"), new StandardPlatform(new PVector(100, 100), new PVector(20, 20))));
  }

  void action()
  {
    this.display();
  }

  int w = width; 
  int h = height;

  void display()
  {
    drawUIBg();
    drawUIItems();

    // If the width has changed resize the boxes and lay them out
    if (w != width || h!= height) {
      boxSize = new PVector(width/10, width/10);
      layoutItems();
    }
    w = width; 
    h = height;
  }

  void drawUIBg()
  {
    fill(100, 100, 100, 100);
    stroke(0);
    rect(0, height-height/10, width, 150);
  }

  void drawUIItems()
  {
    for (int i = 0; i < items.size(); i++)
    {
      UIItem b = (UIItem)items.get(i);
      b.action();
      if (mousePressed) {
        b.checkClick();
      }
    }
  }

  void addItem(UIItem u) 
  {
    items.add(u);
    layoutItems();
  }

  void layoutItems()
  {
    int boxHeight = (int)boxSize.x;
    println(boxHeight);

    int place = 0;
    int bufferDistance = int(width - (items.size() * boxHeight))/(items.size()+1);
    for (int i = 0; i < items.size(); i++) {
      UIItem b = (UIItem)items.get(i);
      place += bufferDistance;
      b.setPosition(new PVector(place, height - height/10));
      b.setSize(boxSize);
      place += boxHeight;
    }
  }
}

class UIString extends UIItem
{
  String txt;
  int alphaCol = 255;
  int fadeTime = 0;
  boolean doneFadingIn = false;
  Timer t;
  UIString(String s)
  {
    txt=s;
    pos = new PVector (0, 0);
    type = "UIString";
  }
  
  UIString(String s, PVector po)
  {
    txt=s;
    pos = po;
    type = "UIString";
  }

  UIString(String s, PVector po, int fTime)
  {
    txt=s;
    pos = po;
    alphaCol = 0;
    fadeTime = fTime; // how long does it stay onscreen before fading out
    type = "UIString";
  }
  String getText(){return txt;}
  void action()
  {
    fill(255, 255, 255, alphaCol);
    this.display();
  }

  void doFade()
  {
    if (alphaCol < 255 && !doneFadingIn) {
      alphaCol +=25;
    }
    else {
      doneFadingIn = true;
      if (t == null) {
        t= new Timer(fadeTime);
        t.start();
      }
      if (t.isFinished()) {
        println(alphaCol);
        alphaCol-=25;
        if (alphaCol<0)
          expired = true;
      }
    }
  }
  void display()
  {
    textAlign(CENTER);
    text(txt, pos.x, pos.y+textDescent()+textAscent());
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
    //pl.setPosition(new PVector(pos.x+s.x/2, pos.y+s.y/2));
    //pl.display();
  }

  boolean checkClick()
  {
    if (pointInRect(new PVector(mouseX, mouseY), pos, s))
    {
      cbo.callbackMethod();
      return true;
    }
    else return false;
  }
}


class UIWepBox extends UIItem {  
  UIWepBox() {
  }

  void action() {
    this.display();
  }
  void display() {
  }

  void setWeapon() {
  }
}

