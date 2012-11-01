///////////////////////////////////////////////
// Different types of Ship. Player and AI classes defined here.
// All inherit from Ship base, which inherits from Entity.
///////////////////////////////////////////////

class Ship extends Entity
{

  float speed = 1;      // Speed of the ship
  float turnSpeed = 10;  // How fast can it turn
  PImage sprt;      // What sprite should it use
  float angle = 0;      // The current angle
  float accel=1;      // Speed of acceleration
  float maxSpeed=30;   // Speed cap
  String wep;       // Which weapon does it use.

  Ship(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite)
  {
    speed = 1;
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
  
  void fire(String wep,  Entity parent)
  {
//    switch (wep){
//      case "HomingMissile":
//    parent.addChild(
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
  Entity target;
  
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

