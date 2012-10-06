///////////////////////////////////////////////
// A planetary body, orbits a point in a circle or ellipse
///////////////////////////////////////////////

// TODO: • Consider adding support for some kind of dynamic gravity system

class Planetary extends Entity
{
  int r; // radius of object
  int or; // radius of orbit
  float angle = 0;// angle of object on orbit
  float rotSpeed;
  // construct with the radius of th circle, color of circle, orgin of orbit, and radius of orbit. 
  Planetary(int bodyRadius, color c, int orbitRadius, PVector org, float speed )
  {
    r = bodyRadius;
    or = orbitRadius;
    orgin = org;
    col = c;
    rotSpeed = speed;
    pos = new PVector(0, 0);
  }

  void action()
  {
    this.rotateAroundOrgin();
    this.display();
  }

  void rotateAroundOrgin()
  {
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
}


