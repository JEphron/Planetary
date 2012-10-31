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
      expired = true; // explode() if you want.
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

  Bullet(PVector p, int rng, int spd, int dmg, float ang)
  {
    super(p, rng, spd, dmg, ang, null);
    setTotalLife(1);
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
      fill(255, 0, 0);
      ellipse(pos.x, pos.y, 10, 10);
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
    fill(0, random(100,200), random(200, 255), random(100, 150));
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

  // Satanic wizardry that boggles my mind. 
  float beringAsMagnitudeCubic2d(PVector missile_position, PVector missile_heading, PVector tp) 
  { 
    PVector target_position = tp.get();
    target_position.sub(missile_position); 
    float forward_theta = missile_heading.x * target_position.x + missile_heading.y * target_position.y; // dot = 1 or -1 when north and postion align 
    float right_theta = -missile_heading.y * target_position.x + missile_heading.x * target_position.y; // simultaneous cross right and dot = 0 when north and position align 
    PVector cubic = cubicNormalize(new PVector(forward_theta, right_theta)); 
    // 
    if (cubic.y >= 0.f) // quads 1 and 2 
    { 
      if (cubic.x >= 0.f) { 
        return (cubic.y) * .5f;
      } // Q1 
      else { 
        return -cubic.x * .5f + .5f;
      } //Q2
    } 
    else // quads 3 and 4 
    { 
      if (cubic.x < 0.f) { 
        return cubic.x * .5f -.5f;
      } // Q3 
      else { 
        return cubic.y * .5f ;
      } //Q4
    }
  } 

  /// <summary> 
  /// returns the angle from -1 to 1  
  /// this method is a cubic based approximation it will devite about 6% at times 
  /// however all the normalization and square roots are removed 
  /// </summary> 
  /// <param name="north">north specifying the direction that is to be angle 0</param> 
  /// <param name="position">the x y vector components relative to 0,0 and the north of they quadrant system</param> 
  /// <returns>an approximate angle based on the north and postion</returns> 
  float unitAngleToTarget(PVector forward, PVector position) 
  { 
    float forward_theta = forward.x * position.x + forward.y * position.y; // dot = 1 or -1 when north and postion align 
    float right_theta = -forward.y * position.x + forward.x * position.y; // simultaneous cross right and dot = 0 when north and position align 
    PVector cubic = cubicNormalize(new PVector(forward_theta, right_theta)); 
    // 
    if (cubic.y >= 0.f) // quads 1 and 2 
    { 
      if (cubic.x >= 0.f) { 
        return (cubic.y) * .5f;
      } // Q1 
      else { 
        return -cubic.x * .5f + .5f;
      } //Q2
    } 
    else // quads 3 and 4 
    { 
      if (cubic.x < 0.f) { 
        return -cubic.y * .5f + 1.f;
      } // Q3 
      else { 
        return cubic.x * .5f + 1.5f;
      } //Q4
    }
  } 

  /// <summary> 
  /// Satisfys the rule that the absolutes of the components will sum to 1.0  
  /// cubic vector operation simply equalize x y z by thier absolute sum  
  /// the returned vector is the ratio of the magnitudes in relation to the sum of the whole   
  /// unit length vectors can be directly normalized to a cubic 
  /// and cubic vector can be directly normalized to a unit length vector 
  ///  
  /// note  
  /// the dot of a regular normal is the acos however the dot of two cubics is a ratio of the angles 
  /// as a % of 90 degrees which can be applied directly to PI or as a magnitude 
  /// will motill 2010-2012 
  /// </summary> 
  /// <param name="v"></param> 
  /// <returns>returns a cubic unitlengthvector</returns> 
  PVector cubicNormalize(PVector v) 
  { 
    float n = v.x; 
    if (n < 0) { 
      n = -n;
    } 
    if (v.y < 0)  
    { 
      n += -v.y;
    }  
    else  
    { 
      n += v.y;
    } 
    n = 1.0f / n; 
    v.x = v.x * n; 
    v.y = v.y * n;
    return v;
  }
}

