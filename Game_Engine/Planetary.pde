///////////////////////////////////////////////
// A planetary body, orbits a point in a circle or ellipse
///////////////////////////////////////////////

// TODO: • Consider adding support for some kind of dynamic gravity system

class Planetary extends Entity
{
  Planetary()
  {
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
