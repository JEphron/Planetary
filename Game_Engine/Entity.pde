///////////////////////////////////////////////
//  All objects in the game are entities
//  They share common traits such as position, size, color, and velocity
//  All entities contain an action() and display() method.
//  Logical code goes in the action() method and graphical code goes in the display() method
///////////////////////////////////////////////

// TODO: • Some sort of parent-child system
//       • Scaling. 
//       • Investigate problems with the seperation of action() and display(). 

class Entity
{
  // Member variables:
  PVector pos;  // xy position
  PVector s;    // xy size
  PVector vel;  // vectorial velocity of the entity
  PVector orgin;// center of rotation and point by which the entity is positioned
  PImage sprt;  // the sprite that this entity displays
  float rot;    // rotation of the entity
  color col;    // color of the entity.
  ArrayList children; 

  Entity()
  {
  }

  // OVERLOAD: init with sprite.
  Entity(PImage i)
  {
    sprt = i;
  }

  void action()
  {
    // Logic goes here
  }

  void display()
  {
    // Draw calls go here
    
    // Draw children
    for (int i = children.size()-1; i > 0; i--) { 
      Entity m = (Entity)children.get(i);
      m.action();
    }
  }

  // getters and setters
  PVector getPosition() {
    return pos;
  }
  
  void setPosition(PVector p) {
    pos = p;
    // should transform children
  }

  PVector getSize() {
    return s;
  }
  
  void setSize(PVector si) {
    s = si;
  }

  PVector getVelocity() {
    return vel;
  }
  
  void setVelocity(PVector v) {
    vel = v;
  }

  void setOrgin(PVector o) {
    orgin = o;
  }
  
  PVector getOrgin() {
    return orgin;
  }

  void addChild(Entity e) {
    children.add(e);
  }
  
  Entity getChild(int id) {
    return (Entity)children.get(id);
  }
}

