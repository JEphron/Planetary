// this is the scene view. It handles clipping the scene to the viewport and 
// scrolling the scene and stuff.
// contains a viewport which contains a scene
class SceneView extends UIElement
{
  HScrollbar hsb; // horizontal scrollbar
  HScrollbar vsb; // vertical scrollbar

  Viewport view; // the viewport

  SceneView(int xp, int yp, int w, int h)
  {
    super();
    // position the window
    pos.x = xp;
    pos.y = yp;
    s.x = w;
    s.y = h;

    view = new Viewport(pos, s);

    bgCol = color(255, 255, 255);
    hsb =new HScrollbar(pos.x, pos.y +s.y + 16, (int)s.x, 16, 2);
  }

  void action()
  {
    this.display();
  }

  void display()
  {
    // draw a white rectangle for the background
    fill(bgCol);
    rect(pos.x, pos.y, s.x, s.y);
    hsb.update();
        view.setSpacing((int) hsb.getPos()/20);

    view.display();
  }

  void handleMouse() {
    shapeMode(CENTER);
    PVectRect(view.snapToGrid(new PVector(mouseX, mouseY)), new PVector(50, 50));
  }
}
void PVectRect(PVector p, PVector s)
{
  rect(p.x, p.y, s.x, s.y);
}
/////////////////////////////
// Rectangular object that handles clipping.
// member functions:
//     get/setScenePos(): set/get the position of the scene inside the viewport.
//     getSelectedTiles(): return an array of the tiles that are currently selected. 
class Viewport
{
  // local coords
  PVector localPos;
  PVector localSize;

  // global coords
  PVector pos;
  PVector s;

  int spacing;
  Viewport(PVector p, PVector si)
  {
    // set up local coords
    localPos = new PVector(0, 0);
    localSize = new PVector(0, 0);
    spacing = 50;
    pos = p;
    s = si;
  }
  void action()
  {
    // this.display();
  }
  void display()
  {
    drawGrid();
  }

  void drawGrid()
  {
    
    // draw a grid
    stroke(1);

    for (int xp = (int)pos.x; xp < (int)(pos.x + s.x); xp += spacing)
      line(xp, pos.y, xp, pos.y + s.y); // vertical lines

    for (int yp = (int)pos.y; yp < (int)(pos.y + s.y); yp += spacing)
      line( pos.x, yp, pos.x + s.x, yp); // horizontal lines
  }

  PVector localToGlobal(PVector loc)
  {
    return new PVector(loc.x - pos.x, loc.y - pos.y); // need to account for scrolling.
  }

  PVector globalToLocal(PVector loc)
  {
    return new PVector(loc.x - pos.x, loc.y - pos.y); // need to account for scrolling.
  }

  PVector snapToGrid(PVector loc)
  {
    println(spacing);
    return new PVector((spacing * round(loc.x/spacing)), (spacing * round(loc.y/spacing)));
  }
  void setSpacing(int s){spacing = s;}
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

