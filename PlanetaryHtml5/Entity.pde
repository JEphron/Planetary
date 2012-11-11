///////////////////////////////////////////////
//  All objects in the game are entities
//  They share common traits such as position, size, color, and velocity
//  All entities contain an action() and display() method.
//  Logical code goes in the action() method and graphical code goes in the display() method
///////////////////////////////////////////////

// TODO: • Some sort of parent-child system
//       • Scaling. 
//       • Investigate problems with the seperation of action() and display(). 
//       • Subclass Entity for game objects
//       • Subclass for general things with pos/scale/children 
//       • Find a better way to handle types. Enums won't work b/c java and strings just suck 
//       • Implement a subType

// This class is getting too big, consider refactoring soon. 
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
  protected boolean expired = false;// Does this entity need to be deleted?
  protected String type;
  protected int maxLife;
  protected int currentLife;
  boolean targeted = false;
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
  boolean isTargeted()
  {
    return targeted;
  }

  void setTargeted(boolean t)
  {
    targeted = t;
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

  void setPosition(PVector p) 
  {
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

  boolean isExpired() {
    return expired;
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

  ArrayList getChildrenByType(String t)
  {
    ArrayList temp = new ArrayList();
    for (Iterator<Entity> i=this.getChildren().iterator(); i.hasNext();) {
      Entity e=i.next();
      if (e.getType() == t)
        temp.add(e);
    }
   // if (temp.size() > 0)
      return temp;
   // else return null;
  }

  ArrayList getChildren() {
    return children;
  }

  String getType() {
    return type;
  }

  // This should be seperated into a new class. 

  // This will set the current life to the max, and set the max to the param
  void setTotalLife(int ml) {
    maxLife = currentLife = ml;
  }
  void setLife(int l) {
    currentLife = l;
    if (currentLife < 0)
      currentLife = 0;
      if(currentLife > maxLife)
      currentLife = maxLife;
  }
  int getMaxLife() {
    return maxLife;
  }
  int getLife() {
    return currentLife;
  }
  // Convience method to deal some dmg
  void dealDamage(int d) {
    if (currentLife > 0)
      currentLife -= d;
    else
      currentLife = 0;
  }
}

