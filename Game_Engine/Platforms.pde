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
  int damage = 2;
  float range = 200;
  int rof = 5; // rof in ms
  Timer t = new Timer(10);
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
    for (int i = a.size()-1; i > 0; i--) { 
      Entity h = (Entity)a.get(i);
      float d = dist(pos.x, pos.y, h.getPosition().x, h.getPosition().y);
      if (d < closestDistance) {
        closestDistance = d;
        target = h;
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
    if ( dist(pos.x, pos.y, target.getPosition().x, target.getPosition().y) < 200)
      return true;
    else return false;
  }

  void fire() {
    if (t.isFinished()) { // Only fire when the timer has finished
      if (!targIsDead()) {    // Don't fire on a dead target
        if (targetInRange()) {// Only fire if in range, do this once per shot, not every frame
          stroke(255, 0, 0);
          line(pos.x+s.x/2, pos.y+s.y/2, target.getPosition().x, target.getPosition().y);
          target.dealDamage(damage); // Deal dmg to target
          t = new Timer(rof);  // reset timer
          t.start();
        }
      }
    }
    // println("dd");
  }
}  


