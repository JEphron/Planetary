// abstract UIElement class.
abstract class UIElement
{
  PVector pos;
  PVector s;
  color bgCol;
  
  UIElement()
  {
    pos = new PVector();
    s = new PVector();
    
    //int xp, int yp, int w, int h
    //pos.x = xp;
   // pos.y = yp;
    //s.x = w;
    //s.y = h;
  }
  
  void display()
  {
  }
  
  void action()
  {
  }
  
  void setPosition(PVector p){pos = p;}
  PVector getPosition(){return pos;}
  
  void setSize(PVector p){s = p;}
  PVector getSize(){return s;}
}

