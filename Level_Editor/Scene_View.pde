// this is the scene view. It handles clipping the scene to the viewport and 
// scrolling the scene and stuff.
class SceneView extends UIElement
{
  HScrollbar hsb;

  int spacing;
  PVector localPos;
  PVector localSize;
  
  SceneView(int xp, int yp, int w, int h)
  {
    super();
    // position the window
    spacing = 10;
    pos.x = xp;
    pos.y = yp;
    s.x = w;
    s.y = h;
    
    // set up local coords
    localPos = new PVector(0,0);
    localSize = new PVector(0,0);
    
    bgCol = color(255, 255, 255);
    hsb =new HScrollbar(pos.x, pos.y +s.y + 16, (int)s.x, 16, 2);
  }

  void action()
  {
    this.display();
  }

  void display()
  {
    spacing = (int)hsb.getPos()/20;
    // draw a white rectangle for the background
    fill(bgCol);
    rect(pos.x, pos.y, s.x, s.y);
    // draw a grid
    hsb.update();
    stroke(1);
    for (int xp = (int)pos.x; xp < (int)(pos.x + s.x); xp += spacing)
      line(xp, pos.y, xp, pos.y + s.y);
      
    for (int yp = (int)pos.y; yp < (int)(pos.y + s.y); yp += spacing)
      line( pos.x, yp, yp, pos.x + s.x);
  }
}

// Rectangular
class viewPort
{
  viewPort()\
  {
  }
}

// this holds the grid and has seperate local coords
class scene
{
  scene()
  {
  }
}

class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } 
    else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
    this.display();
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
      mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } 
    else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } 
    else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}



