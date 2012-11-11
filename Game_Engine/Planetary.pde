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
  PImage glow;
  Sun(int bodyRadius, color c, int orbitRadius, PVector org, float speed, boolean orbits)
  {
    super(bodyRadius, c, orbitRadius, org, speed, orbits);
    type = "Sun";
    sprt = loadImage("SunResized.png");
    glow = loadImage("Glow.png");
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
  void display()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    scale(1, 1);
    imageMode(CENTER);

    image(sprt, 0, 0);
    popMatrix();
    
  }

  void addPlanet(Planet p) // this does the same thing as addChild(); :\
  {
    this.addChild(p);
    println(this.getChildren().size());
  }
}

class Planet extends Planetary
{
  int t = 500; // time between life boosts in ms
  int l = 10; // how much does the life go up each tick
  Timer lifeTimer;
  boolean b = false;

  Planet(int bodyRadius, color c, int orbitRadius, PVector org, float speed, boolean orbits, int life)
  {
    super(bodyRadius, c, orbitRadius, org, speed, orbits);
    type = "Planet";
    setTotalLife(life);
    lifeTimer = new Timer(t); // every t ms, life will go up some.
    sprt = loadImage("PlanetResized.gif");
  }
  void action()
  {
    // Regen health slowly
    if (b) {
      if (this.getLife() < this.getMaxLife()-1)
        this.setLife(this.getLife()+l);
      lifeTimer = new Timer(t);
      lifeTimer.start();
      b=false;
    }
    if (lifeTimer.isFinished()) {       // Reset if finished
      b = true;
    }

    //currentLife -= 10;
    super.action();
  }

//  void display()
//  {
//    pushMatrix();
//    translate(pos.x, pos.y);
//    scale(0.1, 0.1);
//    imageMode(CENTER);
//    image(sprt, 0, 0);
//    popMatrix();
//  }
}

