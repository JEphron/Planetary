///////////////////////////////////////////////
//  All objects in the game are entities
//  They share common traits such as position, size, color, and velocity
//  All entities contain an action() and display() method.
//  Logical code goes in the action() method and graphical code goes in the display() method
///////////////////////////////////////////////

class Entity
{
  PVector pos;  // xy position
  PVector s;    // xy size
  PVector vel;  // vectorial velocity of the entity
  image sprt;   // the sprite that this entity displays
  
  Entity()
  {
  }
  
  void action()
  {
  }
  
  void display()
  {
  }
  
  // getters and setters
  PVector getPosition(){return pos;}
  
  PVector getSize(){return s;}

  PVector getVelocity(){return vel;}

}

