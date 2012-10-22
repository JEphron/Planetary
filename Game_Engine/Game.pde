///////////////////////////////////////////////
// This is the game state. It is the state where all of 
// the game logic, drawing, and interaction take place. 
// 
///////////////////////////////////////////////

// TODO: 
//       • Implement targeting algorithm
//       • Implement particle system
//       • for (Iterator<Entity> i=this.getChildren().iterator(); i.hasNext();) {
//       • Minimap
//       • UI Layer ***
//       • click to track
//       • Missle damage
//       • Platforms and placement
//       • Weapons
//       • Real enemies
//       • Zooming. Oh hell no. 

class Game extends IAppStates
{
  GameScene currentScene;
  Game()
  {
    nextAppStates = AppStates.Game;
    println("Entering main game...");
    currentScene = new MainGame();
  }

  PVector scenePos = null;
  void action()
  {
    //println(frameRate);

    currentScene.action();
    // Call this to signal that the game should end\
    //setNextState(AppStates.Exit);


    if (mousePressed) {
      if (scenePos == null)
        scenePos = currentScene.getPosition(); // this becomes the original position
      PVector difference = new PVector( mouseX - mX, mouseY - mY);
      //PVector newPos = new PVector(); 

      // Three styles of scrolling:
      // TODO: Add boundry scrolling. Arrow scrolling.

      //currentScene.setPosition(new PVector(mouseX-width/2, mouseY-height/2)); // absolute positioning based on mouse
      //currentScene.setPosition(new PVector(currentScene.getPosition().x - difference.x, currentScene.getPosition().y - difference.y)); // Relative positioning with cont. scrolling
      currentScene.setPosition(new PVector(scenePos.x + difference.x, scenePos.y + difference.y)); // Touchscreen-style controls - more natural
      //currentScene.setPosition(new PVector(scenePos.x - difference.x, scenePos.y - difference.y)); // Reversed touchscreen-style controls - some people like this for some reason....
    }
    else
    {
      scenePos = null;
      currentScene.setPosition(new PVector(currentScene.getPosition().x, currentScene.getPosition().y));
    }

    //println(currentScene.getPosition());
  }
}

// Do we need more than one of these?
// It's probably good practice to handle everything on a state by state basis
// Is it weird to have this inherit from Entity? 
abstract class GameScene extends Entity
{
  float zoom;
  PVector focus = new PVector(0, 0);

  GameScene()
  {
    // init
    pos = new PVector(0, 0);
  }

  void setBackground(PImage i)
  {
    // bg image
  }

  void setZoomFactor(float zerm)
  {
    // how much is everything scaled up?
  }

  PVector convertToLocal(PVector p)
  {
    return new PVector((p.x -this.getPosition().x - width/2), (p.y -this.getPosition().y - height/2));
  }

  PVector getFocus() {
    return focus;
  }

  void setFocus(PVector f) {
    focus = f;
  }
}

// The main game scene, this is where the fun happens
class MainGame extends GameScene
{

  StarField sf = new StarField(300);
  Sun sun = new Sun(200, color(255, 220, 40), 250, new PVector(width/2, height/2), 1, false);                     
  Planet planet;     
  UILayer ui = new UILayer();  
  PVector trackPoint;
  MainGame()
  {
    sf.generateField();
    this.addChild(sf);
    sun.setPosition(new PVector(width/2, height/2));
    s = new PVector(600, 600);
    planet = new Planet(50, color(100, 200, 170), 250, new PVector(width/2, height/2), 1, true, 1000);  // PARAMS: Planet(int bodyRadius, color c, int orbitRadius, PVector org, float speed, boolean orbits, int life)
    ui.addUIItem(new HealthBar(new PVector(0, 10), new PVector(width/2, 20), planet)); // Width and height should be relative
    sun.addPlanet(planet);
    this.addChild(sun);
    trackPoint = new PVector(0, 0);
  } 

  PVector scenePos = null;
  boolean derp = true;
  Timer t;
  PVector planetPos;


  // GAME LOGIC:
  void action()
  {
    fill(0);
    stroke(0);
    rect(0, 0, width, height);

    ui.action();

    Sun s = (Sun)this.getChild(1);
    planet = (Planet)s.getChild(0);
    planetPos = planet.getPosition().get();
    // s.action();
    updateChildren();   
    fill(255);
    text(frameRate, 20, 10);
    // Always try to update the position
    // this.movePointTowardsPoint(this.getPosition(), new PVector(width/2, height/2), 0.05);

    // I fixed it. 
    if (derp) {
      t = new Timer(1);
      t.start();
      // this.setFocus(convertToLocal(planetPos)); // focus on the planet. 
      derp = false;
    }
    if (t.isFinished())
    {
      derp = true;
    }

    handleKeyPresses();
  }

  // Move the rect towards a point with decreasing speed
  void movePointTowardsPoint(PVector p1, PVector p2, float moveDist) {
    // only call this when we have to move the rect...
    if (p1.x+s.x/2 != p2.x || p1.y+s.y/2 != p2.y) {

      // calculate difference between points
      PVector v  = new PVector(p2.x-p1.x, p2.y-p1.y);

      // add the delta and the current position and multiply by a scale factor, then subtract the focus divided by 1 over the distance. Makes sense. 
      this.setPosition(new PVector( ((p1.x+v.x*moveDist)-((s.x/2)+focus.x)/(1/moveDist)), ((p1.y+v.y*moveDist)-((s.y/2)+focus.y)/(1/moveDist))) );
    }
  }

  // Overwrite this so we can do some updatin.
  void updateChildren()
  {
    // This method is kind of ugly, but I think it's standard practice. Also it works, so that's good. 
    if (this.getChildren().size()>0) {
      for (int i = 0; i <= this.getChildren().size()-1; i++) {
        Entity e=(Entity)this.getChildren().get(i);
        if (e.getType() != null) {
          if ( e.getType() == EntityType.Missile) {
            // If it's a missile, cast to missile. This could be generalized for AI. All AI should have targets.
            HomingMissile m = (HomingMissile)e;
            m.action(planetPos);
            // If it's touching the planet (or platforms), destroy it, deal dmg to planet
            if (dist(m.getPosition().x, m.getPosition().y, planetPos.x, planetPos.y)<30) {
              if (!m.isExploding())
                planet.dealDamage(1);
              m.explode();
            }
            if (m.isExpired())
            {
              m = null;
              this.getChildren().remove(i);
            }
          }
          else if ( e.getType() == EntityType.Sun )
          {
            // I guess I don't really need to do anything here
            Planetary pl = (Planetary)e;
            pl.action();
            if (pl.isClicked())
            {
              trackPoint = pl.getPosition();
            }
          }           
          else if ( e.getType() == EntityType.Platform )
          {
            StandardPlatform t = (StandardPlatform)e;
            if (t.targIsDead())
            {
              ArrayList temp = this.getChildrenByType(EntityType.Missile);
              if (temp != null)
                t.aquireTarget(temp);
            }
            t.action();
            t.fire();
          } 


          else {
            // Other type checks go right here
            e.action();
          }
        } 
        else {
          // Standard action call if no specific type defined
          e.action();
        }
      }
    }
  }

  void handleKeyPresses()
  {

    if (keyPressed) {
      if (key == 'a') {    // 'a' key spawns missiles
        for (int i = 0; i < 3; i++) {
          HomingMissile h = new HomingMissile(new PVector( mouseX +random(-100, 100), mouseY+random(-100, 100)), 20, 15, planetPos);      
          this.addChild(h);
        }
      }
      else if (key == 's') // 's' to reset the planet's health
      {
        planet.setTotalLife(1000); // should be a variable.
      }      
      else if (key == 'd') // 'd' to place a platform/turret thingy
      {
        this.addChild(new StandardPlatform(new PVector(mouseX, mouseY), new PVector(20, 20)));
      }       
      else if (key == 'f') // 'f' to clear platforms
      {
        for (int i = 0; i <= this.getChildren().size()-1; i++) {
          Entity e=(Entity)this.getChildren().get(i);
          if (e.getType() == EntityType.Platform) {
            e = null;
            this.getChildren().remove(i);
          }
        }
        
      }
    }
  }
}

// The BFG goes on the planet...
// Consider inheriting from an abstract gun/turret class.
class BFG extends Entity
{
}

