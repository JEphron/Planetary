///////////////////////////////////////////////
// Different types of Ship. Player and AI classes defined here.
// All inherit from Ship base, which inherits from Entity.
///////////////////////////////////////////////

class Ship extends Entity
{
  int wep = 0;         
  float speed = 1;      // Speed of the ship
  float turnSpeed = 10;  // How fast can it turn
  PImage sprt;      // What sprite should it use
  float angle = 0;      // The current angle
  float accel=1;      // Speed of acceleration
  float maxSpeed=30;   // Speed cap
  //String wep;       // Which weapon does it use.
  Entity targ;    // Ai will seek target and fire upon it, Player's target will be selectable

  Ship(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite)
  {
    speed = 0;
    turnSpeed = turnSpd;
    accel = accelSpd;
    maxSpeed = maxSpd;
    pos = p;
    sprt = sprite;
  }
  float getAngle() {
    return angle;
  }
  int getSpeed() {
    return (int)speed;
  } // merge with getVelocity in Entity
  float getMaxSpeed()
  {
    return maxSpeed;
  }
  //  void setWeapon(String w)
  //  {
  //    wep = w;
  //  }
  void cycleWeps()
  {
    int numWeps = 3;
    wep = ((wep+1) < numWeps) ? wep+1 : 0;
    println(wep);
  }
  void setTarget(Entity t)
  {
    targ = t;
  }
  void fire(Entity parent)
  {
    switch (wep) {
    case 0:      // fire a homing missile that tracks the target
      if (targ !=null) {
        for (int i = 0; i < 5; i++) {
          HomingMissile h = new HomingMissile(new PVector( pos.x +random(-10, 10), pos.y+random(-10, 10)), 5000, 30, 10, targ); // Incorperate setAngle into constructor
          h.setAngle(angle);  
          parent.addChild(h);
        }
      }
      break;

    case 1:      // fire the standard gun
      for (int i = 0; i < 5; i++)
        parent.addChild(new Bullet(/*Position:*/pos, /*Range:*/1000, /*Speed:*/20, /*Damage:*/10, /*Angle:*/angle+random(-5, 5), color(255, 0, 255)));
      break;

    case 2:       // do a circular explosion thingy
      for (int i = 0; i < 360; i+= 30) {
        parent.addChild(new Bullet(/*Position:*/pos, /*Range:*/1000, /*Speed:*/2, /*Damage:*/1, /*Angle:*/angle+i, color(100, 255, 55)));
      }
      break;

    default:
      break;
    }
  }
}

// Simple player class
class Player extends Ship
{
  Player(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite);
    s = new PVector(20, 20);
  }

  void action()
  {
    pos.x += cos(radians(angle))*speed;
    pos.y += sin(radians(angle))*speed;
    checkKeys();
    display();
  }

  void display()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(radians(angle));
    imageMode(CENTER);
    image(sprt, 0, 0);
    popMatrix();
  }

  void checkKeys()
  {
    if ( Left)
      angle -= turnSpeed;

    if ( Right)
      angle += turnSpeed;

    if ( Up)
    {
      speed += accel;
      if (speed > maxSpeed) {
        speed = maxSpeed;
      }
    }
    if ( Down && speed > 0) {
      speed -= accel;
      if ( speed < 0)
        speed = 0;
    }
  }
}

// AI Classes:
class AI extends Ship
{
  AI(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite);
  }
}

// These pirates form fleets, flock around target and shoot
// Boid logic
class BoidPirate extends AI
{
  BoidPirate(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite);
  }
}

// Fly straight at their target and detonate when they reach it
// Straight homing missile logic, explode when dist < 1
class BombShip extends AI
{
  BombShip(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite);
  }
}

// hang out at a distance and fire long range missiles/lasers
// Homing missile logic, stop at fixed dist and begin firing
class LongRangeFrigate extends AI
{
  LongRangeFrigate(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite);
  }
}

