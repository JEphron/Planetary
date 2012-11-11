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
  int rof = 500;      // rate of fire, currently broken
  int range = 100;      // set when switching weapons, how far can the bullet go
  //String wep;       // Which weapon does it use.
  Entity targ;    // Ai will seek target and fire upon it, Player's target will be selectable
  Entity parent; // the game scene which bullets will be added to
  Ship(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite, Entity pa)
  {
    speed = 0;
    turnSpeed = turnSpd;
    accel = accelSpd;
    maxSpeed = maxSpd;
    pos = p;
    sprt = sprite;
    parent = pa;
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
  boolean hasNoTarget()
  {
    return (targ == null);
  }
  void aquireTarget(ArrayList a) {
  }
  boolean targIsDead() {
    if (targ != null)
      return targ.isExpired();
    else return true;
  } 

  void cycleWeps()
  {
    int numWeps = 3;
    wep = ((wep+1) < numWeps) ? wep+1 : 0;
  }
  int getWep() {
    return wep;
  }
  void setTarget(Entity t)
  {
    targ = t;
  }
  void fire()
  {
    switch (wep) {
    case 0:      // fire a homing missile that tracks the target
      range = 2000;
     // if (targ !=null) {
        for (int i = 0; i < 5; i++) {
          HomingMissile h = new HomingMissile(new PVector( pos.x +random(-10, 10), pos.y+random(-10, 10)), range, 30, 30, targ, type); // todo: Incorperate setAngle into constructor
          h.setAngle(angle);  
          parent.addChild(h);
        }
      //}
      break;
    case 1:      // fire the standard gun
      range = 1000;
     // for (int i = 0; i < 5; i++) {
        parent.addChild(new Bullet(/*Position:*/pos, /*Range:*/range, /*Speed:*/20, /*Damage:*/50, /*Angle:*/angle+random(-5, 5), color(255, 0, 255), type));
     // }
      break;
    case 2:       // do a circular explosion thingy
      range = 1000;
      for (int i = 0; i < 360; i+= 30) {
        parent.addChild(new Bullet(/*Position:*/pos, /*Range:*/range, /*Speed:*/2, /*Damage:*/1, /*Angle:*/angle+i, color(100, 255, 55), type));
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
  Player(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite, Entity pa)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite, pa);
    type = "Player"; 
    s = new PVector(20, 20);
    wep =1;
    setTotalLife(400); // SET LIFE TOTAL HERE
  }

  int t = 500; // time between life boosts in ms
  int l = 10; // how much does the life go up each tick
  Timer lifeTimer = new Timer(500);

  void action()
  {
    pos.x += cos(radians(angle))*speed;
    pos.y += sin(radians(angle))*speed;

    if (lifeTimer.isFinished()) {
      if (this.getLife() < this.getMaxLife()-1)
        this.setLife(this.getLife()+l);
      lifeTimer = new Timer(500);
      lifeTimer.start();
    }
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

  void aquireTarget(ArrayList a) {
    if (a.size()>0) {
      targ = (Entity)a.get((int)random(0, a.size()));
    }else{
      targ = null; 
    }
  }
}

class AISpawner extends Entity // hell, everything extends this... not good oop
{
  int aiPerWave = 2; // increase over time
  int timeBetweenWaves = 2; // In seconds, decrease over time
  PVector spawnPoint; // generate at a random point on a circle that surrounds the play area. 
  int aiType; // this should be random, and eventually become a mixture. 
  float timeOfLastSpawn; // keep track of when to spawn
  float timeSinceLastSpawn;
  ArrayList targets = new ArrayList();
  MainGame parent;

  AISpawner(MainGame parent_entity, PVector p)
  {
    parent = parent_entity;
    timeOfLastSpawn = 0; 
    timeSinceLastSpawn =10000; 
    pos = p; // temporary solution
    type = "SpawnPoint";
  }

  void action()
  {
    updateAI();
    display();
    if (timeSinceLastSpawn > timeBetweenWaves*1000)
      spawnWave(aiPerWave, (int)random(3));

    timeSinceLastSpawn = millis() - timeOfLastSpawn;
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
    parent.getUI().notify("Wave incoming!!");
    targets.addAll(parent.getChildrenByType("Platform")); // get all the stuff from the parent
    targets.add(((Entity)parent.getChildrenByType("Sun").get(0)).getChild(0)); // this is hacky
    targets.addAll(parent.getChildrenByType("Player"));
    for (int i = 0; i < aiPerWave; i++)
    {
      AI a = new StandardEnemy(new PVector(pos.x + random(-25, 25), pos.y + random(-25, 25)), 10, 1, 20, null, parent);   // create a new ai
      a.aquireTarget(targets);      // give targets to the ai
      parent.addChild(a);            // add it to the parent.
    }
    //aiPerWave += 1; // increase by x each wave
    if (timeBetweenWaves>2) // don't spawn too fast...
      timeBetweenWaves -= 0; // decrease time by 1 second
    timeSinceLastSpawn = 0;
    timeOfLastSpawn = millis();
    targets.clear();
  }
}

// AI Classes:
class AI extends Ship
{
  AI(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite, Entity pa)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite, pa);
    type = "Ai";
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

    targ = (Entity)a.get((int)random(0, a.size()));
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
    super.fire();
  }
}


// These pirates form fleets, flock around target and shoot
// Boid logic
class BoidPirate extends AI
{
  BoidPirate(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite, Entity pa)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite, pa);
  }
}

// The standard enemy ai simply flys towards its target, firing when in range. 
// Logic similar to homing missile
class StandardEnemy extends AI
{
  Timer t = new Timer(500);
  int explody = 0;
  StandardEnemy(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite, Entity pa)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite, pa);
    setTotalLife(150);
    wep = 1;//(int)random(3);
    type = "Ai";
    s = new PVector(10, 10);
  }

  boolean b = false;
  boolean exploding = false;
  void action()
  {
    if (!exploding) {
      seekTarget();
      display();
      if (b) {                    // Try to optimize if spare time == have
        if (!targIsDead()) {      // Don't fire on a dead target
          if (targetInRange()) {  // Only fire if in range, do this once per shot, not every frame
            fire();
            // targ.dealDamage(1); // no
            t = new Timer(rof);  // reset timer
            t.start();
          }
        }
        b = false;
      }
      if (t.isFinished()) {       // Reset if finished
        b = true;
      }
      if (currentLife <=0)
        explode();
    }
    else {
      this.explode();
      if (explody > random(20, 30))
        expired = true;
    }
  }

  void explode()
  {
    exploding = true;
    explody += 15;
    noStroke();
    fill(random(200, 250), random(200, 255), 0, random(50, 250));
    ellipse(pos.x, pos.y, explody, explody);
    stroke(1);
  }


  void display()
  {
    fill(map(currentLife, 0, maxLife, 255, 0), map(currentLife, 0, maxLife/5, 0, 255), 0);
    noStroke();
    rect(pos.x, pos.y-20, 20*(float)currentLife/maxLife, 2);
    stroke(0);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(radians(angle));
    rectMode(CENTER);
    fill(100, 90, 120);
    stroke(0);
    rect(0, 0, s.x, s.y);
    rectMode(CORNER);
    popMatrix();
  }
  void seekTarget() // can be extracted, used by both homing missile and ai
  { 
    if (targ != null) {
      PVector targetPosition = targ.getPosition();
      PVector thrust = new PVector(0, 0); // forward direction vector.
      thrust.x = 1 * cos(radians(angle));
      thrust.y = 1   * sin(radians(angle));      
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
  BombShip(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite, Entity pa)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite, pa);
  }
}

// hang out at a distance and fire long range missiles/lasers
// Homing missile logic, stop at fixed dist and begin firing
class LongRangeFrigate extends AI
{
  LongRangeFrigate(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite, Entity pa)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite, pa);
  }
}

