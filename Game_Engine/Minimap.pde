class Minimap extends UIItem
{
  private int scanRange = 500;
  private ArrayList lst = new ArrayList();
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
    drawCross(pos.x+s.x/2, pos.y+s.y/2, 5);
    stroke(0);
    fill(255,255,0);
    for (int i = 0; i < lst.size(); i++)
    {
      PointColor p = (PointColor)lst.get(i);
      stroke(p.col);
      strokeWeight(p.sw);
      if (pointInRect(p.pt, pos, s))
        point(p.x, p.y);
      strokeWeight(1);
      stroke(0);
    }
    lst = new ArrayList();
  }

  void displayPoint(PVector p, color c, float sw)
  {
    lst.add(new PointColor(new PVector(map(p.x, 0-scanRange, width+scanRange, pos.x, pos.x+s.x), map(p.y, 0-scanRange, height+scanRange, pos.y, pos.y+s.y)), c, sw));
  }
}

// why doesn't processing have structs?
class PointColor
{
  public PVector pt;
  public float x, y, sw;
  public color col;
  PointColor(PVector p, color c, float strokeWidth)
  {
    col=c;
    pt=p;
    x=p.x;
    y=p.y;
    sw = strokeWidth;
  }
}
