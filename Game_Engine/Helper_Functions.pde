// This file is for useful functions that might need to be used all over the app. 

/* * * *
 * Returns true if the point pt is inside the 
 * rectangle specified by pos and s (upper left/width/height)
 */
boolean pointInRect(PVector pt, PVector pos, PVector s)
{
  if (mouseX >= pos.x && mouseX < s.x+pos.x && mouseY >= pos.y && mouseY <= s.y+pos.y)
  {
    return true;
  }
  return false;
}

void lineFromPointLengthAngle(float x, float y, float len, float angle)
{
  float x2;
  float y2;
  float a = angle * PI/180;
  x2 = x + len * cos(a);
  y2 = y + len * sin(a);
  line(x, y, x2, y2);
}

///////////////
// ** Other functions to write **
// PointInCircle
// CircleCircleCollisionTest
// RectRectCollisionTest
// RectCircleCollisionTest
// distBetweenPoints (processing might already have this)
// 

