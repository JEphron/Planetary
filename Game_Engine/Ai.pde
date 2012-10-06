///////////////////////////////////////////////
// Different types of Ai defined here.
// All inherit from AI.
///////////////////////////////////////////////

class AI extends Entity
{
}

// These pirates form fleets, flock around target and shoot
// Boid logic
class BoidPirate extends AI
{
}

// Fly straight at their target and detonate when they reach it
// Straight homing missile logic, explode when dist < 1
class BombShip extends AI
{
}

// hang out at a distance and fire long range missiles/lasers
// Homing missile logic, stop at fixed dist and begin firing
class LongRangeFrigate extends AI
{
}

class HomingMissile extends Entity
{
  //PVector pos;
  float angle, turnSpeed, vel; 
  boolean exploding = false;
  boolean expired = false;
  // jTri t;
  HomingMissile(PVector p)
  {
    //targetPosition = targetPos;
    turnSpeed = 20;
    pos = p;
    vel = 10;
  }

  void action(PVector targetPosition)
  {
    // So now this works...
    float radians = angle * PI / 180; 
    PVector thrust = new PVector(0, 0); // forward direction vector. 

    thrust.x = vel * cos(radians) ;
    thrust.y = vel * sin(radians) ;      

    float sign = beringAsMagnitudeCubic2d(pos, thrust, targetPosition);

    if ( sign < 0) {
      angle -= turnSpeed;
    }

    else if (sign > 0) {
      angle += turnSpeed;
    }

    pos.x += thrust.x;
    pos.y += thrust.y;
    this.display();
    //t.setRotation(angle);
    //t.setPosition(pos);
    //println(t.getPosition());
    //t.action();
  }

  void display()
  {
    //pushMatrix();
    //translate(pos.x, pos.y);  
    //rotate(angle*PI/180);
    //translate(-pos.x, -pos.y);
    //triangle(pos.x, pos.y, pos.x + 10, pos.y - 5, pos.x + 20, pos.y);
    //if (!exploding) {
      stroke(255, 128, 64);
      strokeWeight(2);
      lineFromPointLengthAngle(pos.x, pos.y, 10, angle);
      strokeWeight(1);
      stroke(0);
    //}
    //else {
      if(exploding)
      expired = true;
   // }
    //popMatrix();
    //t.display();
  }
  void explode()
  {
    exploding = true;
  }

  boolean isExloding() {
    return exploding;
  }

  boolean isExpired() {
    return expired;
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

  // Satanic wizardry that boggles my mind. 
  float beringAsMagnitudeCubic2d(PVector missile_position, PVector missile_heading, PVector target_position) 
  { 
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
}

