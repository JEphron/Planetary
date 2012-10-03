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

///////////////
// ** Other functions to write **
// PointInCircle
// CircleCircleCollisionTest
// RectRectCollisionTest
// RectCircleCollisionTest
// distBetweenPoints (processing might already have this)
// LineFromPointAngleLength
// 
