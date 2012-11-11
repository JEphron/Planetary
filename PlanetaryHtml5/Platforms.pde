///////////////////////////////////////////////
//  This file contains the various types of defense platform
//  used in the game. They all inherit from the Platform class.
///////////////////////////////////////////////

class Platform extends Entity
{
  int damage;
  float range;
  int rof;
  Timer t = new Timer(rof);
  Entity target;

  Platform()
  {
  }

  void action()
  {
  }

  void display()
  {
  }

  void fireAtTarget()
  {
  }

  boolean targIsDead() {
    return true;
  }

  void aquireTarget(ArrayList a) {
  }

  void fire() {
  }
}

// Rename to Point Defense platform
class StandardPlatform extends Platform
{
  int damage = 5;
  float range = 1200;
  int rof = 1; // rof in ms
  Timer t = new Timer(rof);
  Entity target;

  StandardPlatform(PVector p, PVector si)
  {
    super();
    type = "Platform";
    pos = p;
    s = si;
  }

  void action() {
    this.display();
  }
  void display() {
    fill(255, 255, 0);
    stroke(0);
    //quad(pos.x-s.x/2, pos.y, pos.x,pos.y-s.y/2,pos.x+s.x/2,pos.y,pos.x,pos.y+s.y/2); // draw a rhombus
    rect(pos.x-s.x/2, pos.y-s.y/2, s.x, s.y); 

    line(pos.x-s.x/2, pos.y, pos.x+s.x/2, pos.y);
    line(pos.x, pos.y-s.y/2, pos.x, pos.y+s.y/2);

    // line(pos.x,pos.y+s.y/2,pos.x+s.x,pos.y+s.y/2);
  }
  // will go through all objects in arrayList and select the closest one to target
  void aquireTarget(ArrayList a) {
    float closestDistance = range; 
    Entity temp;
    for (int i = 0; i < a.size(); i++) { 
      Entity h = (Entity)a.get(i);
      float d = distV(pos, h.getPosition());
      if (!h.isTargeted() || h.getType() == "Ai") {
        if (d < closestDistance) {
          closestDistance = d;
          target = h;
         if ((int)random(10)>8) // This adds some randomness to the selection process. 
            break;// I think it makes the results look nicer and the ai look smarter
        }
      }
    }
  }
  boolean hasNoTarget()
  {
    return (target == null);
  }
  boolean targIsDead() {
    if (target != null)
      return target.isExpired();
    else return true;
  } 

  boolean targetInRange()
  {
    if ( dist(pos.x, pos.y, target.getPosition().x, target.getPosition().y) < range)
      return true;
    else return false;
  }

  boolean b = false;
  void fire() {
    if (b) {                    // Try to optimize if spare time == have
      if (!targIsDead()) {      // Don't fire on a dead target
        if (targetInRange()) {  // Only fire if in range, do this once per shot, not every frame
          target.setTargeted(true); // mark the target as targeted so other platforms won't waste time firing on it.
          stroke(random(55)+200, random(100)+100, random(200));
          strokeWeight(1);
          line(pos.x, pos.y, target.getPosition().x, target.getPosition().y);
          // // Optional fancy graphics
          // strokeWeight(4);
          // stroke(0, 100, 255);
          // line(pos.x, pos.y, target.getPosition().x, target.getPosition().y);
          // strokeWeight(1);
          // stroke(255, 255, 255);
          // line(pos.x, pos.y, target.getPosition().x, target.getPosition().y);
          target.dealDamage(damage); // Deal dmg to target
          t = new Timer(rof);  // reset timer
          t.start();
        }
      }
      b = false;
    }
    if (t.isFinished()) {       // Reset if finished
      b = true;
    }
  }
}  

class MissilePlatform extends Platform
{
  Entity parent;
  int damage = 50;
  float range = 200;
  int rof = 1; // rof in ms
  Timer t = new Timer(rof);
  Entity target;

  MissilePlatform(PVector p, PVector si, Entity par)
  {
    super();
    type = "Platform";
    pos = p;
    s = si;
    parent = par;
  }

  void action() {
    this.display();
  }

  void display() {
    fill(200, 255, 0);
    stroke(0);
    ellipse(pos.x, pos.y, s.x, s.y);
  }

  boolean hasNoTarget()
  {
    return (target == null);
  }

  boolean targIsDead() {
    if (target != null)
      return target.isExpired();
    else return true;
  } 

  boolean targetInRange()
  {
    if ( dist(pos.x, pos.y, target.getPosition().x, target.getPosition().y) < range)
      return true;
    else return false;
  }

  void aquireTarget(ArrayList a) {
    float closestDistance = range; 
    Entity temp;
    for (int i = 0; i < a.size(); i++) { 
      Entity h = (Entity)a.get(i);
      float d = dist(pos.x, pos.y, h.getPosition().x, h.getPosition().y);
      if (d < closestDistance) {
        closestDistance = d;
        target = h;
        if ((int)random(6)>3) // This adds some randomness to the selection process. 
          break;// I think it makes the results look nicer and the ai look smarter
      }
    }
  }

  void fire() {
    if (!targIsDead()) {      // Don't fire on a dead target
      if (targetInRange()) {  // Only fire if in range, do this once per shot, not every frame
        noFill();
        stroke(random(55)+200, random(55)+200, 0);
        strokeWeight(1);
        bezier(pos.x, pos.y, random(pos.x-width/5, pos.x+width/5), random(pos.y-width/5, pos.y+width/5), random(pos.x-width/5, pos.x+width/5), random(pos.y-width/5, pos.y+width/5), target.getPosition().x, target.getPosition().y);
        target.dealDamage(damage);
      }
    }
  }
}

//class Torpedo extends Projectile
//{
//  Torpedo()
//  {
//  }
//}


class PulsePlatform extends Platform
{
}

class TorpedoPlatform extends Platform
{
  TorpedoPlatform(PVector p, PVector si)
  {
    super();
  }
}
//------------------------------------------------------------------------------------
//
//class MobilePlatform extends Platform
//{
//  Entity tracktarg;
//  Entity target;
//  Entity parent;
//  float speed;
//  float angle;
//  int turnSpeed;
//  int rad;
//  PVector tPos = new PVector();
//  MobilePlatform(PVector p, PVector si, Entity par, Entity track, int spd)
//  {
//    super();
//    type = "Platform";
//    tracktarg = track;
//    speed = 0.1;
//    angle = 0;
//    turnSpeed = 20;
//    parent = par;
//    pos = p;
//    s = si;
//    range = 300;
//    damage = 1;
//    rad = 50 + (int)random(-10,10);
//    vel = new PVector(-10, -10);
//  }
//
//  void action()
//  {
//    speed = 0.1;
//    rotateAroundOrgin();
//    movePointTowardsPoint(pos,tPos, speed);
//    display();
//  }
//  void movePointTowardsPoint(PVector p1, PVector p2, float moveDist) {
//    // only call this when we have to move the rect...
//    if (p1.x+s.x/2 != p2.x || p1.y+s.y/2 != p2.y) {
//      // calculate difference between points
//      PVector v  = new PVector(p2.x-p1.x, p2.y-p1.y);
//      // add the delta and the current position and multiply by a scale factor, then subtract the focus divided by 1 over the distance. Makes sense. 
//      this.setPosition(new PVector( ((p1.x+v.x*moveDist)-((s.x/2))/(1/moveDist)), ((p1.y+v.y*moveDist)-((s.y/2))/(1/moveDist))) );
//    }
//  }
//
//  void display()
//  {
//    stroke(0);
//    fill(255, 255, 0);
//    ellipseMode(CENTER);
//    ellipse(pos.x, pos.y, s.x, s.y);
//    fill(0);
//    drawCross(pos.x, pos.y, (int)s.x/2);
//  }
//
//  void rotateAroundOrgin()
//  {
//    angle += 10;
//    float xDistance = sin(angle * PI/180)*rad;
//    float yDistance = cos(angle * PI/180)*rad;
//    float xDisCalculated = tracktarg.getPosition().x + xDistance;
//    float yDisCalculated = tracktarg.getPosition().y + yDistance;
//    tPos.x = xDisCalculated;
//    tPos.y = yDisCalculated;
//  }
//
//  void aquireTarget(ArrayList a) {
//    float closestDistance = range; 
//    Entity temp;
//    for (int i = 0; i < a.size(); i++) { 
//      Entity h = (Entity)a.get(i);
//      float d = dist(pos.x, pos.y, h.getPosition().x, h.getPosition().y);
//      if (!h.isTargeted() || h.getType() == "Ai") {
//        if (d < closestDistance) {
//          closestDistance = d;
//          target = h;
//          if ((int)random(10)>8) // This adds some randomness to the selection process. 
//            break;// I think it makes the results look nicer and the ai look smarter
//        }
//      }
//    }
//  }
//  boolean hasNoTarget()
//  {
//    return (target == null);
//  }
//  boolean targIsDead() {
//    if (target != null)
//      return target.isExpired();
//    else return true;
//  } 
//
//  boolean targetInRange()
//  {
//    if ( dist(pos.x, pos.y, target.getPosition().x, target.getPosition().y) < range)
//      return true;
//    else return false;
//  }
//
//  boolean b = false;
//  void fire() {
//    if (b) {                    // Try to optimize if spare time == have
//      if (!targIsDead()) {      // Don't fire on a dead target
//        if (targetInRange()) {  // Only fire if in range, do this once per shot, not every frame
//          target.setTargeted(true); // mark the target as targeted so other platforms won't waste time firing on it.
//          stroke(random(55)+200, random(100)+100, random(200));
//          strokeWeight(1);
//          line(pos.x, pos.y, target.getPosition().x, target.getPosition().y);
//          // // Optional fancy graphics
//          // strokeWeight(4);
//          // stroke(0, 100, 255);
//          // line(pos.x, pos.y, target.getPosition().x, target.getPosition().y);
//          // strokeWeight(1);
//          // stroke(255, 255, 255);
//          // line(pos.x, pos.y, target.getPosition().x, target.getPosition().y);
//          target.dealDamage(damage); // Deal dmg to target
//          t = new Timer(rof);  // reset timer
//          t.start();
//        }else{
//          target = null;
//        }
//      }
//      b = false;
//    }
//    if (t.isFinished()) {       // Reset if finished
//      b = true;
//    }
//  }
//}

