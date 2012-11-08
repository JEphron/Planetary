///////////////////////////////////////////////
// Different types of Ship. Player and AI classes defined here.
// All inherit from Ship base, which inherits from Entity.
///////////////////////////////////////////////

class Ship extends Entity
{
  int wep = 0;         // this should be an object. 
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
    setTotalLife(300);
    type = "Player";
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

class AISpawner extends Entity // hell, everything extends this... not good oop
{
  int aiPerWave = 10; // increase over time
  int timeBetweenWaves = 2; // In seconds, decrease over time
  PVector spawnPoint; // generate at a random point on a circle that surrounds the play area. 
  int aiType; // this should be random, and eventually become a mixture. 
  float timeOfLastSpawn; // keep track of when to spawn
  float timeSinceLastSpawn;
  ArrayList targets = new ArrayList();
  Entity parent;

  AISpawner(Entity parent_entity, PVector p)
  {
    parent = parent_entity;
    timeOfLastSpawn = 0; 
    pos = p; // temporary solution
  }

  void action()
  {
    timeSinceLastSpawn = millis() - timeOfLastSpawn;
    updateAI();
    display();
    if (timeSinceLastSpawn > timeBetweenWaves*1000)
      spawnWave(aiPerWave, (int)random(3));
  }

  void display()
  {
    stroke(200);
    strokeWeight(5);
    noFill();
    ellipse(pos.x, pos.y, 50, 50); // draw a spawnPoint marker
    fill(255);
    strokeWeight(1);
    stroke(0);
  }

  void updateAI()
  {
    // parent should do this.
  }

  void spawnWave(int num, int type)
  {

    targets.addAll(parent.getChildrenByType("Platform")); // get all the stuff from the parent
    targets.add(((Entity)parent.getChildrenByType("Sun").get(0)).getChild(0)); // this is hacky
    targets.addAll(parent.getChildrenByType("Player"));
    for (int i = 0; i < aiPerWave; i++)
    {
      AI a = new StandardEnemy(new PVector(pos.x + random(-5,5), pos.y + random(-5,5)), 10, 1, 20, null);   // create a new ai
      a.aquireTarget(targets);      // give targets to the ai
      parent.addChild(a);            // add it to the parent.
    }
    println("Spawning a wave...");
    aiPerWave += 2; // increase by x each wave
    if (timeBetweenWaves>2) // don't spawn too fast...
      timeBetweenWaves -= 1; // decrease time by 1 second
    timeSinceLastSpawn = 0;
    timeOfLastSpawn = millis();
    targets.clear();
  }
}

// AI Classes:
class AI extends Ship
{
  AI(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite);
  }

  boolean hasNoTarget()
  {
    return (targ == null);
  }

  boolean targIsDead() {
    if (targ != null)
      return targ.isExpired();
    else return true;
  } 

  boolean targetInRange()
  {
    if ( dist(pos.x, pos.y, targ.getPosition().x, targ.getPosition().y) < /*wep.getrange()*/500)
      return true;
    else return false;
  }

  void aquireTarget(ArrayList a)
  {
    String s = "";
    int sel = (int)random(90);
    // choose either player, turret, or planet. Planet should have higher priority. 

    if (sel <30) { 
      s = "Planet";
    } 
    else if (sel < 60) {
      s = "Player";
    } 
    else if (sel < 90) {
      s = "Platform";
    }
    
   targ = (Entity)a.get((int)random(0,a.size()));
//    for (int i = 0; i < a.size(); i++) { 
//      Entity h = (Entity)a.get(i);
//      if (h.getType() == s)
//      {
//        if ( s == "Platform" ) {
//          if ((int)random(10) < 7) {
//            targ = h; // if it's a platform then choose a random one.
//            break;
//          }
//        }
//        else { // generally guarenteed to be only one player/planet
//          if (targ != null)
//            targ = h;
//          break;
//        }
//        println(targ);
//      }
//    }
  }

  void fire()
  {
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

// The standard enemy ai simply flys towards its target, firing when in range. 
// Logic similar to homing missile
class StandardEnemy extends AI
{
  StandardEnemy(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite);
  }
  void action()
  {
    seekTarget();
    display();
  }
  void display()
  {
    fill(100);
    rect(pos.x, pos.y, 10, 10);
  }
  void seekTarget() // can be extracted, used by both homing missile and ai
  { 
    if (targ != null) {
      PVector targetPosition = targ.getPosition();
      PVector thrust = new PVector(0, 0); // forward direction vector.
      thrust.x = 1 * cos(radians(angle)) ;
      thrust.y = 1 * sin(radians(angle)) ;      
      float sign = beringAsMagnitudeCubic2d(pos, thrust, targetPosition);
      if ( sign < 0) {
        angle -= turnSpeed;
      }
      else if (sign > 0) {
        angle += turnSpeed;
      }
      pos.x += thrust.x;
      pos.y += thrust.y;
    }
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

