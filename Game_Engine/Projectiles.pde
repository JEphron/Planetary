//class Weapon extends Entity
//{
//  int w;
//  Entity parent;
//  Weapon(int wepType, Entity p)
//  {
//    w = wepType; 
//    parent = p;
//  }
//
//  void fire()
//  {
//    switch (w)
//    {
//    case 0:
//      for (int i = 0; i < 5; i++) {
//        HomingMissile h = new HomingMissile(new PVector( pos.x +random(-10, 10), pos.y+random(-10, 10)), 5000, 30, 10, targ); // Incorperate setAngle into constructor
//        h.setAngle(angle);  
//        parent.addChild(h);
//      }
//      break;
//    case 1:
//      for (int i = 0; i < 5; i++)
//        parent.addChild(new Bullet(/*Position:*/pos, /*Range:*/1000, /*Speed:*/20, /*Damage:*/10, /*Angle:*/angle+random(-5, 5), color(255, 0, 255)));
//      break;
//    case 2:       // do a circular explosion thingy
//      for (int i = 0; i < 360; i+= 30) {
//        parent.addChild(new Bullet(/*Position:*/pos, /*Range:*/1000, /*Speed:*/2, /*Damage:*/1, /*Angle:*/angle+i, color(100, 255, 55)));
//      }
//      break;
//
//    default:
//      break;
//    }
//  }
//}

class Projectile extends Entity
{
  int range; // how many units this projectile will travel before epxloding
  int damage; // how much damage will it deal upon impact
  int vel; // how fast does the projectile move
  float angle; // yah
  PImage sprt; // what image to use when drawing
  float savedTime; // when was the projectile created
  boolean exploding = false;
  float distTraveled;
  //PImage splosionSprt; // the explosion graphic

  Projectile(PVector p, int rng, int spd, int dmg, float ang, PImage graphic)
  {
    setTotalLife(1); // default to 10;
    type = "Projectile";
    pos = p;
    savedTime = millis(); // init dat
    range = rng;
    damage = dmg;
    vel = spd;
    angle = ang;
    if (graphic != null)
      sprt = graphic;
  }

  void explode()
  {
  }

  void action()
  {
    if (currentLife <= 0)
      explode();

    distTraveled += vel;

    if (distTraveled > range)
      expired = true; // explode();// if you want.
  }

  int getDamage() {
    return damage;
  }
  int getRange() {
    return range;
  }
  float getTotalDistanceTraveled()
  {
    return distTraveled;
  }
  boolean isExploding()
  {
    return exploding;
  }
}

class Bullet extends Projectile
{
  int explody = 0;
  color col;
  Bullet(PVector p, int rng, int spd, int dmg, float ang, color c)
  {
    super(p, rng, spd, dmg, ang, null);
    col = c;
    setTotalLife(1);
    // sprt = loadImage("Plasma2.png");
  }

  void action()
  {
    super.action();
    pos.x += vel * cos(radians(angle));
    pos.y += vel * sin(radians(angle));     
    this.display();
  }

  void display()
  {
    if (!exploding) {
      stroke(0);
      fill(col);
      ellipse(pos.x, pos.y, 10, 10);
      //    pushMatrix();
      //    translate(pos.x, pos.y);
      //    rotate(radians(angle));
      //    imageMode(CENTER);
      //        tint(random(255),255,120);
      //
      //    image(sprt, 0, 0);
      //    tint(255);
      //    popMatrix();
    }
    else {
      // It's exploding, make an explosion;
      this.explode();
      if (explody > random(20, 30))
        expired = true;
    }
  }

  void explode()
  {
    exploding = true;
    explody += 15;
    noStroke();
    fill(0, random(100, 200), random(200, 255), random(100, 150));
    ellipse(pos.x, pos.y, explody, explody);
    stroke(1);
  }
}

class HomingMissile extends Projectile
{
  //PVector pos;
  float turnSpeed; 
  int explody = 0;
  Entity targ;
  // jTri t;
  HomingMissile(PVector p, int rng, int velocity, float tspeed, Entity target)
  {
    super(p, rng, velocity, 1, AngleTo(p, target.getPosition()), null);
    setTotalLife(1);
    turnSpeed = tspeed;
    col = color(random(255), random(255), random(255));
    if (target!=null)
      angle = AngleTo(pos, target.getPosition());
    targ = target;
  }
  void setAngle(float a) {
    angle = a;
  }
  void action()
  {
    if (targ != null) { // don't try and track a nonexistant target
      super.action();
      PVector targetPosition = targ.getPosition();
      // So now this works...
      //float radians = angle * PI / 180; 
      PVector thrust = new PVector(0, 0); // forward direction vector.
      //    fill(255,0,0); 
      //    stroke(0);
      //    ellipse(targetPosition.x,targetPosition.y,5,5); // Draw the target
      //    fill(255);
      thrust.x = vel * cos(radians(angle)) ;
      thrust.y = vel * sin(radians(angle)) ;      

      float sign = beringAsMagnitudeCubic2d(pos, thrust, targetPosition);

      if ( sign < 0) {
        angle -= turnSpeed;
      }

      else if (sign > 0) {
        angle += turnSpeed;
      }
      if (!exploding) {
        pos.x += thrust.x;
        pos.y += thrust.y;
      }
      this.display();
      // t.setRotation(angle);
      //t.setPosition(pos);
      // println(t.getPosition());
      //t.action();

      //if(dist(pos.x,pos.y,targetPosition.x,targetPosition.y)<10)
      //{
      //  targ.dealDamage(10);
      // }
    }
    else { // If the target is gone, explode. 
      this.explode();
    }
  }

  void display()
  {
    //pushMatrix();
    //translate(pos.x, pos.y);  
    //rotate(angle*PI/180);
    //translate(-pos.x, -pos.y);
    //triangle(pos.x, pos.y, pos.x + 10, pos.y - 5, pos.x + 20, pos.y);
    if (!exploding) {
      stroke(col);
      strokeWeight(2);
      lineFromPointLengthAngle(pos.x, pos.y, 10, angle);
      strokeWeight(1);
      stroke(0);
    } 
    else {
      // It's exploding, make an explosion;
      this.explode();
      if (explody > random(20, 30))
        expired = true;
    }
    //popMatrix();
    //t.display();
  }
  void explode()
  {
    exploding = true;
    explody += 15;
    noStroke();
    fill(255, random(100)+100, 0, random(100, 200));
    ellipse(pos.x, pos.y, explody, explody);
    stroke(1);
  }

  boolean isExploding() {
    return exploding;
  }

  boolean isExpired() {
    return expired;
  }
}

