
class Minimap extends Entity
{
  ArrayList lst = new ArrayList();
  Minimap(PVector p, PVector siz, color bg)
  {
    pos = p;
    s = siz;
    col = bg;
  }
  void action()
  {
    display();
  }
  void display()
  {
    stroke(255);
    fill(0);
    rect(pos.x, pos.y, s.x, s.y);
    stroke(255);
    // draw center crosshairs
    drawCross(pos.x+s.x/2,pos.y+s.y/2,5);
    stroke(0);
  }

  void displayPoint(PVector p, color c)
  {
    stroke(c);
    strokeWeight(2);
    // map values to rect.
    PVector pt =new PVector(map(p.x,0,width,pos.x,pos.x+s.x), map(p.y,0,height,pos.y,pos.y+s.y));
    if(pointInRect(pt,pos,s))
    point(pt.x,pt.y);
    strokeWeight(1);
    stroke(0);
  }
}

