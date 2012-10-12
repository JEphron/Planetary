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
  protected PVector pos;  // xy position
  protected PVector s;    // xy size
  protected PVector vel;  // vectorial velocity of the entity
  protected PVector orgin;// center of rotation and point by which the entity is positioned
  protected PImage sprt;  // the sprite that this entity displays
  protected float rot;    // rotation of the entity
  protected color col;    // color of the entity.
  private ArrayList children = new ArrayList(); 

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

  void updateChildren()
  {
    if (this.getChildren().size()>0) {
      for (Iterator<Entity> i=this.getChildren().iterator(); i.hasNext();) {
        Entity e=i.next();
        e.action();
      }
    }
  }
  // getters and setters
  PVector getPosition() {
    return pos;
  }

  void setPosition(PVector p) {
    // should transform children if they exist
    if (this.getChildren().size()>0) {
      for (Iterator<Entity> i=this.getChildren().iterator(); i.hasNext();) {
        Entity e=i.next();
        e.setPosition(new PVector(e.getPosition().x -(pos.x-p.x), e.getPosition().y + (p.y - pos.y)));
        //println(e.getPosition().x);
        //e.setPosition(new PVector(random(100), random(100)));
      }
    }
    pos = p;
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

  ArrayList getChildren()
  {
    return children;
  }
}

