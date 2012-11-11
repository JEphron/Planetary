/* @pjs crisp=true; 
pauseOnBlur=true; 
preload="SunResized.png"; 
 */

Engine eng;
void setup()
{//port 9001
  //size(720, 400);
  size(900, 900);

   frameRate(60);
   Processing.logger = console;
  //size(360, 480);// 480/360 = 1.3333...
  eng = new Engine(0, 4);
}

void draw()
{
  fill(255);
  background(30);
  eng.handle();
}



// Check if a point is in a rectangle. Currently just checks mouse, too lazy to fix this. 
boolean pointInRect(PVector pt, PVector pos, PVector s)
{
  if (pt.x >= pos.x && pt.x < s.x+pos.x && pt.y >= pos.y && pt.y <= s.y+pos.y)
  {
    return true;
  }
  return false;
}


