// This file is for useful functions and classes that might need to be used all over the app. 

/* * * *
 * Returns true if the point pt is inside the 
 * rectangle specified by pos and s (upper left/width/height)
 */
 
 // Check if a point is in a rectangle. Currently just checks mouse, too lazy to fix this. 
boolean pointInRect(PVector pt, PVector pos, PVector s)
{
  if (mouseX >= pos.x && mouseX < s.x+pos.x && mouseY >= pos.y && mouseY <= s.y+pos.y)
  {
    return true;
  }
  return false;
}

// Draw a line starting at a point at a given angle to a given length
void lineFromPointLengthAngle(float x, float y, float len, float angle)
{
  float x2;
  float y2;
  float a = angle * PI/180;
  x2 = x + len * cos(a);
  y2 = y + len * sin(a);
  line(x, y, x2, y2);
}

// Random timer I stole from somewhere, because programmers jack shit
class Timer {
 
  int savedTime; // When Timer started
  int totalTime; // How long Timer should last
  
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }
  
  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis(); 
  }
  
  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
  }
}

///////////////
// ** Other functions to write **
// PointInCircle
// CircleCircleCollisionTest
// RectRectCollisionTest
// RectCircleCollisionTest
// distBetweenPoints (processing might already have this)
// 



