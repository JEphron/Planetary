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
  float range = 500;
  int rof = 1; // rof in ms
  Timer t = new Timer(rof);
  Entity target;

  StandardPlatform(PVector p, PVector si)
  {
    super();
    type = EntityType.Platform;
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
      float d = dist(pos.x, pos.y, h.getPosition().x, h.getPosition().y);
      if (d < closestDistance) {
        closestDistance = d;
        target = h;
        if ((int)random(6)>3) // This adds some randomness to the selection process. 
          break;// I think it makes the results look nicer and the ai look smarter
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
          stroke(200, 0, 255);
          strokeWeight(1);
          line(pos.x, pos.y, target.getPosition().x, target.getPosition().y);
          //          strokeWeight(4);
          //          stroke(0, 100, 255);
          //          line(pos.x, pos.y, target.getPosition().x, target.getPosition().y);
          //          strokeWeight(1);
          //          stroke(255, 255, 255);
          //          line(pos.x, pos.y, target.getPosition().x, target.getPosition().y);
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
  float range = 150;
  int rof = 1; // rof in ms
  Timer t = new Timer(rof);
  Entity target;

  MissilePlatform(PVector p, PVector si, Entity par)
  {
    super();
    type = EntityType.Platform;
    pos = p;
    s = si;
    parent = par;
  }

  void action() {
    this.display();
  }

  void display() {
    fill(200,255,0);
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
        //if ((int)random(6)>3) // This adds some randomness to the selection process. 
        // break;// I think it makes the results look nicer and the ai look smarter
      }
    }
  }

  void fire() {
    if (!targIsDead()) {      // Don't fire on a dead target
      if (targetInRange()) {  // Only fire if in range, do this once per shot, not every frame
        noFill();
        stroke(255,255,0);
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

