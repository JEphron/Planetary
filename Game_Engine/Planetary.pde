///////////////////////////////////////////////
// A planetary body, orbits a point in a circle or ellipse
///////////////////////////////////////////////

// TODO: • Consider adding support for some kind of dynamic gravity system

class Planetary extends Entity
{
  int r; // radius of object
  int or; // radius of orbit
  float angle = 0;// angle of object on orbit
  int rotSpeed;
  // construct with the radius of th circle, color of circle, orgin of orbit, and radius of orbit. 
  Planetary(int bodyRadius, color c, int orbitRadius, PVector org )
  {
    r = bodyRadius;
    or = orbitRadius;
    orgin = org;
    col = c;
    rotSpeed = 1;
    pos = new PVector(0, 0);
  }

  void action()
  {
    this.rotateAroundOrgin();
    this.display();
  }

  void rotateAroundOrgin()
  {
    //float rads = angle * 180/PI;
    
    //if (angle < 2*PI) 
     // angle += 0.01;
    //else 
     // angle = 0;

    // pos.x = ((pos.x - orgin.x) * cos(angle)) - ((orgin.y - pos.y) * sin(angle));
    // pos.y = ((orgin.y -pos.y) * cos(angle)) - ((pos.x - orgin.x) * sin(angle));

    //pos.x = orgin.x + ((pos.x - orgin.x) * cos(rads)) - ((orgin.y - pos.y) * sin(rads));
    //pos.y = orgin.y + ((orgin.y - pos.y) * cos(rads)) - ((pos.x - orgin.x) * sin(rads));
    
    //pos.x = (pos.x * cos(angle)) - (pos.y * sin(angle));
    //pos.y =(pos.y * cos(angle)) + (pos.x * sin(angle));
    
    angle += 5;
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

/****************************************************************
 
 Translate a point around another point
 
 x = ((x - x_origin) * cos(angle)) - ((y_origin - y) * sin(angle))
 y = ((y_origin - y) * cos(angle)) - ((x - x_origin) * sin(angle))
 
 
 x = x_origin +
 ((x - x_origin) * cos(angle)) - ((y_origin - y) * sin(angle))
 y = y_origin +  
 ((y_origin - y) * cos(angle)) - ((x - x_origin) * sin(angle))
 
 ****************************************************************/
