///////////////////////////////////////////////
// A planetary body, orbits a point in a circle or ellipse
///////////////////////////////////////////////

// TODO: • Consider adding support for some kind of dynamic gravity system

class Planetary extends Entity
{
  protected int r; // radius of object
  protected int or; // radius of orbit
  protected float angle = 0;// angle of object on orbit
  protected float rotSpeed;
  protected boolean isOrbital; // does this body orbit a point?
  boolean selected = false;
  int t = 500; // time between life boosts in ms
  Timer lifeTimer; // every t ms, life will go up some.
  boolean b = false;
  // construct with the radius of th circle, color of circle, orgin of orbit, and radius of orbit. 
  Planetary(int bodyRadius, color c, int orbitRadius, PVector org, float speed, boolean o )
  {
    r = bodyRadius;
    or = orbitRadius;
    orgin = org;
    col = c;
    rotSpeed = speed;
    pos = new PVector(0, 0);
    isOrbital = o;
  }

  void action()
  {
    if (isOrbital)
      this.rotateAroundOrgin();
    this.display();
  }

  void rotateAroundOrgin()
  {
    //println("meep");
    angle += rotSpeed;
    float xDistance = sin(angle * PI/180)*or;
    float yDistance = cos(angle * PI/180)*or;
    float xDisCalculated = orgin.x - xDistance;
    float yDisCalculated = orgin.y - yDistance;
    pos.x = xDisCalculated;
    pos.y = yDisCalculated;
  }

  void display()
  {
    fill(col);
    ellipse(pos.x, pos.y, r, r);
  }
  float getRadius() {
    return r;
  }

  boolean isClicked()
  {
    if (mousePressed) {
      if (dist(mouseX, mouseY, pos.x, pos.y)<r) {
        selected = true;
      }
    }
    return false;
  }
}

/* * * *
 * I hope this doesn't get too bloated
 * Classes for planet and Sun, sun supports a number of planets
 */
class Sun extends Planetary
{
  ArrayList planets = new ArrayList();
  Sun(int bodyRadius, color c, int orbitRadius, PVector org, float speed, boolean orbits)
  {
    super(bodyRadius, c, orbitRadius, org, speed, orbits);
    type = EntityType.Sun;
  }

  void action()
  {
    super.action();
    this.updateChildren();
    this.display();
    this.centerChildren();
  }

  void centerChildren()
  {
    if (this.getChildren().size()>0) {
      for (Iterator<Entity> i=this.getChildren().iterator(); i.hasNext();) {
        Entity e=i.next();
        e.setOrgin(this.getPosition());
      }
    }
  }   

  ArrayList getPlanets()
  {
    return planets;
  }

  void addPlanet(Planet p) // this does the same thing as addChild(); :\
  {
    this.addChild(p);
    println(this.getChildren().size());
  }
}

class Planet extends Planetary
{
  Planet(int bodyRadius, color c, int orbitRadius, PVector org, float speed, boolean orbits, int life)
  {
    super(bodyRadius, c, orbitRadius, org, speed, orbits);
    type = EntityType.Planet;
    setTotalLife(life);
    lifeTimer = new Timer(t);
  }
  void action()
  {
    if (b)
    {
      if(this.getLife() < this.getMaxLife()-1)
      this.setLife(this.getLife()+1);
      b=false;
      lifeTimer = new Timer(t);
    }
    if (lifeTimer.isFinished())
      b = true;
    //currentLife -= 10;
    super.action();
  }
}

