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
    } 
    else {
      return false;
    }
  }
}

float AngleTo(PVector f, PVector p)
{
  float xp = f.x - p.x;
  float yp = f.y - p.y;

  float desiredAngle = atan2(yp, xp); // this is the angle to the target
  return desiredAngle*= 180/PI;
}

// Satanic wizardry that boggles my mind. 
float beringAsMagnitudeCubic2d(PVector missile_position, PVector missile_heading, PVector tp) 
{ 
  PVector target_position = tp.get();
  target_position.sub(missile_position); 
  float forward_theta = missile_heading.x * target_position.x + missile_heading.y * target_position.y; // dot = 1 or -1 when north and postion align 
  float right_theta = -missile_heading.y * target_position.x + missile_heading.x * target_position.y; // simultaneous cross right and dot = 0 when north and position align 
  PVector cubic = cubicNormalize(new PVector(forward_theta, right_theta)); 
  // 
  if (cubic.y >= 0.f) // quads 1 and 2 
  { 
    if (cubic.x >= 0.f) { 
      return (cubic.y) * .5f;
    } // Q1 
    else { 
      return -cubic.x * .5f + .5f;
    } //Q2
  } 
  else // quads 3 and 4 
  { 
    if (cubic.x < 0.f) { 
      return cubic.x * .5f -.5f;
    } // Q3 
    else { 
      return cubic.y * .5f ;
    } //Q4
  }
} 

/// <summary> 
/// returns the angle from -1 to 1  
/// this method is a cubic based approximation it will devite about 6% at times 
/// however all the normalization and square roots are removed 
/// </summary> 
/// <param name="north">north specifying the direction that is to be angle 0</param> 
/// <param name="position">the x y vector components relative to 0,0 and the north of they quadrant system</param> 
/// <returns>an approximate angle based on the north and postion</returns> 
float unitAngleToTarget(PVector forward, PVector position) 
{ 
  float forward_theta = forward.x * position.x + forward.y * position.y; // dot = 1 or -1 when north and postion align 
  float right_theta = -forward.y * position.x + forward.x * position.y; // simultaneous cross right and dot = 0 when north and position align 
  PVector cubic = cubicNormalize(new PVector(forward_theta, right_theta)); 
  // 
  if (cubic.y >= 0.f) // quads 1 and 2 
  { 
    if (cubic.x >= 0.f) { 
      return (cubic.y) * .5f;
    } // Q1 
    else { 
      return -cubic.x * .5f + .5f;
    } //Q2
  } 
  else // quads 3 and 4 
  { 
    if (cubic.x < 0.f) { 
      return -cubic.y * .5f + 1.f;
    } // Q3 
    else { 
      return cubic.x * .5f + 1.5f;
    } //Q4
  }
} 

/// <summary> 
/// Satisfys the rule that the absolutes of the components will sum to 1.0  
/// cubic vector operation simply equalize x y z by thier absolute sum  
/// the returned vector is the ratio of the magnitudes in relation to the sum of the whole   
/// unit length vectors can be directly normalized to a cubic 
/// and cubic vector can be directly normalized to a unit length vector 
///  
/// note  
/// the dot of a regular normal is the acos however the dot of two cubics is a ratio of the angles 
/// as a % of 90 degrees which can be applied directly to PI or as a magnitude 
/// will motill 2010-2012 
/// </summary> 
/// <param name="v"></param> 
/// <returns>returns a cubic unitlengthvector</returns> 
PVector cubicNormalize(PVector v) 
{ 
  float n = v.x; 
  if (n < 0) { 
    n = -n;
  } 
  if (v.y < 0)  
  { 
    n += -v.y;
  }  
  else  
  { 
    n += v.y;
  } 
  n = 1.0f / n; 
  v.x = v.x * n; 
  v.y = v.y * n;
  return v;
}

///////////////
// ** Other functions to write **
// PointInCircle
// CircleCircleCollisionTest
// RectRectCollisionTest
// RectCircleCollisionTest
// 


