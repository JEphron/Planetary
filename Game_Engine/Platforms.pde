class Platform extends Entity
{
  int damage;
  Platform(PVector pos)
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
}

class StandardPlatform extends Entity
{
  int damage = 5;
  float range = 2000;
  int rof = 100; // rof in ms
  Timer t = new Timer(rof);
  Entity target;

  StandardPlatform(PVector p, PVector si)
  {
    type = EntityType.Platform;
    pos = p;
    s = si;
  }

  void action() {
    this.display();
  }
  void display() {
    fill(255, 255, 0);
    stroke(255);
    rect(pos.x, pos.y, s.x, s.y);
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
          line(pos.x+s.x/2, pos.y+s.y/2, target.getPosition().x, target.getPosition().y);
          //          strokeWeight(4);
          //          stroke(0,100,255);
          //          line(pos.x+s.x/2, pos.y+s.y/2, target.getPosition().x, target.getPosition().y);
          //          strokeWeight(1);
          //          stroke(255,255,255);
          //          line(pos.x+s.x/2, pos.y+s.y/2, target.getPosition().x, target.getPosition().y);
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

    // println("dd");
  }
}  

