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
    nextAppStates = 2; // 2 == game
    println("Entering main game...");
    currentScene = new MainGame(this);
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
  Game parent;
  float zoom;
  PVector focus = new PVector(0, 0);

  GameScene()
  { // init
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
    return new PVector((p.x - pos.x - s.x/2), (p.y - pos.y - s.y/2));
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
  Sun sun;
  Planet planet;     
  UILayer ui = new UILayer();  
  boolean tracking = true;
  PVector trackPoint = new PVector(0, 0);
  Minimap mini = new Minimap(new PVector(5, 5), new PVector(150, 150), color(128)); // this should be part of the UI
  float trackSpeed = 0.2;
  String[] weapons = {    
    "Missiles  ", 
    "Plasma Gun", 
    "Circle Thing"
  };
  Player playerzor;

  MainGame(Game p)
  {
    //----------------------------------------------------------------------------------------------------------------
    // msc
    s = new PVector(width, height);
    sf.generateField();
    this.addChild(sf);
    parent = p;
    //----------------------------------------------------------------------------------------------------------------
    // Sun and planet
    sun  = new Sun(200, color(255, 220, 40), 250, new PVector(width/2, height/2), 1, false);
    sun.setPosition(new PVector(width/2, height/2));
    // PARAMS: Planet(int bodyRadius, color c, int orbitRadius, PVector org, float speed, boolean orbits, int life)
    planet = new Planet(50, color(100, 200, 170), 350, new PVector(width/2, height/2), 1, true, 1000);  
    sun.addPlanet(planet);
    this.addChild(sun);
    //----------------------------------------------------------------------------------------------------------------
    // Player
    playerzor = new Player(new PVector(width/2, height/2), 8, 1, 30, loadImage("SpaceShip14.png"), this);
    this.addChild(playerzor);
    //----------------------------------------------------------------------------------------------------------------
    // UI
    ui.addUIItem(new HealthBar(new PVector(mini.getPosition().x+mini.getSize().x+5, 10), width/2, 20, planet)); // Width and height should be relative
    ui.addUIItem(new HealthBar(new PVector(mini.getPosition().x+mini.getSize().x+5, 40), width/3, 20, playerzor)); // Width and height should be relative
    ui.addUIItem(new UITray(new PVector(0, height-100), new PVector(width, 100)));
    //----------------------------------------------------------------------------------------------------------------
    // Ai
    this.addChild(new AISpawner(this, new PVector(width/2-800, 50)));
    this.addChild(new AISpawner(this, new PVector(width/2+800, 50)));

    mousePressed = true;
  } 
  UILayer getUI() {
    return ui;
  }
  PVector scenePos = null;
  boolean derp = true;
  Timer t;
  PVector planetPos;  
  // GAME LOGIC:
  void action()
  {
    s.x = width;
    s.y = height;
    fill(0);
    stroke(0);
    rect(0, 0, width, height);

    // Sun su = (Sun)this.getChild    planet = (Planet)sun.getChild(0);
    planetPos = planet.getPosition().get();
    planet.addChild(new StandardPlatform(new PVector(planet.getPosition().x, planet.getPosition().y), new PVector(200, 20))); // wut?
    updateChildren();   
    mini.action();

    fill(255);
    textAlign(LEFT);
    text(frameRate, 5, mini.getPosition().y+mini.getSize().y+textAscent()+5);

    if (tracking) {
      PVector focusPoint = new PVector(playerzor.getPosition().x-width/2 +s.x/2, playerzor.getPosition().y-height/2 +s.y/2);   // ToDo: move this into it's own method  
      setFocus(convertToLocal(focusPoint));
      this.movePointTowardsPoint(pos, new PVector(width/2+1, height/2), trackSpeed);
    }
    //println(convertToLocal(playerzor.getPosition()).x);

    handleKeyPresses();
    // ui.setPlayerWeapon(playerzor.getWep());
    ui.action();
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
    // these should only be updated if they've changed
    ArrayList projectiles = this.getChildrenByType("Projectile");
    ArrayList ailist = this.getChildrenByType("Ai");
      int blah = millis();

    // mini.clearMap();
    // This method is kind of ugly, but I think it's standard practice. Also it works, so that's good. 
    if (this.getChildren().size()>0) {
      for (int i = 0; i < this.getChildren().size(); i++) {
        Entity e=(Entity)this.getChildren().get(i);
        if (e.getType() != null) {
          if ( e.getType() == "Projectile") {
            // If it's a missile, cast to missile. This could be generalized for AI. All AI should have targets.
            Projectile m = (Projectile)e;
            m.action();
            mini.displayPoint(m.getPosition(), color(255, 0, 0), 2);
            if (m.getOwner() != "Player") {
              // If it's touching the planet (or platforms), destroy it, deal dmg to planet
              // Handle this differently please. 
              if (fastDist(m.getPosition().x - planetPos.x, m.getPosition().y- planetPos.y)<30) {
                if (!m.isExploding())
                  planet.dealDamage(m.getDamage());
                m.explode();
              }
              if (fastDist(m.getPosition().x - playerzor.getPosition().x, m.getPosition().y - playerzor.getPosition().y)<50) {
                if (!m.isExploding())
                  playerzor.dealDamage(m.getDamage());
                m.explode();
              }
            }
            else { // if belongs to player
              //getchArrayList ailist = this.getChildrenByType("Ai");

              if (m.needsRetarget()) // only applies to missiles
              {
                if (ailist.size() >0) // if the target is dead then aquire a new target
                  m.setTarget((Entity)ailist.get(ailist.size()-1));
                else
                  m.setTarget(null);
              }

              for (int t = 0; t < ailist.size(); t++) // collide player's bullets with ai
              {
                Ship s = (Ship)ailist.get(t);

                if (fastDist(m.getPosition().x - s.getPosition().x, m.getPosition().y - s.getPosition().y)<30) {
                  m.explode();
                  s.dealDamage(5);
                }
              }
            }
            if (m.isExpired()) {
              m = null;
              this.getChildren().remove(i);
            }
          }
          else if ( e.getType() == "Sun" ) {
            // I guess I don't really need to do anything here
            Planetary pl = (Planetary)e;
            mini.displayPoint(pl.getPosition(), color(255, 255, 0), 25);
            mini.displayPoint(pl.getChild(0).getPosition(), color(100, 200, 170), 5);
            pl.action();
            if (pl.getChild(0).getLife()<=0) {
              ui.notify("Your planet is dead."); //todo: find out which life bar was totaled.
            }
          }           
          else if ( e.getType() == "Platform" ) {
            Platform t = (Platform)e;
            mini.displayPoint(t.getPosition(), color(0, 0, 255), 2);
            if (t.targIsDead()) {
              projectiles.addAll(ailist);
              if (projectiles != null)
                t.aquireTarget(projectiles);
            }
            t.action();
            t.fire();
          }
          else if (e.getType() == "Ai") {
            e.action();
            mini.displayPoint(e.getPosition(), color(0, 255, 0), 2);
            // todo: reaquire target if target dies
            if (e.isExpired()) {
              e = null;
              this.getChildren().remove(i);
            }
          }
          else if (e.getType() == "SpawnPoint") {
            mini.displayPoint(e.getPosition(), color(128), 5);
            e.action();
          } 
          else if (e.getType() == "Player") {
            Player p = (Player)e;
            p.action();
            if (p.targIsDead()) {
              if (ailist != null)
                p.aquireTarget(ailist);
            }
          }
          else {
            // Other type checks go right here
            e.action();
          }
        } 
        else {
          // not a duplicate
          // Standard action call if no specific type defined
          e.action();
        }
      }
    }
      println( millis() - blah);

  }

  void handleKeyPresses()
  {
    if ( Fire) {    // 'a' key spawns missiles
      // Spawn Homing Missiles
      //      for (int i = 0; i < 5; i++) {
      //        HomingMissile h = new HomingMissile(new PVector( playerzor.getPosition().x +random(-10, 10), playerzor.getPosition().y+random(-10, 10)), 5000, 30, 10, planet);    
      //        h.setAngle(playerzor.getAngle());  
      //        this.addChild(h);
      //      }
      // Spawn fixed-path bullets
      //      for (int i = 0; i < 5; i++)
      //        this.addChild(new Bullet(/*Position:*/playerzor.getPosition(), /*Range:*/300, /*Speed:*/45, /*Damage:*/10, /*Angle:*/playerzor.getAngle()+random(-5, 5)));
      //
      //      // Spawn fixed-path bullets
      //      for (int i = 0; i < 360; i+= 10) {
      //        this.addChild(new Bullet(/*Position:*/playerzor.getPosition(), /*Range:*/1000, /*Speed:*/2, /*Damage:*/1, /*Angle:*/playerzor.getAngle()+i));
      //      }
      playerzor.fire();
    }

    if (d) { // 'd' to place a platform/turret thingy

      //this.addChild(new StandardPlatform(new PVector(mouseX, mouseY), new PVector(20, 20)));
      //this.addChild(new MissilePlatform(new PVector(playerzor.getPosition().x, playerzor.getPosition().y), new PVector(20, 20), this));
      playerzor.cycleWeps();
      ui.notify("Weapon: " +weapons[playerzor.getWep()]);
      d = false;
      //key = 0;
    }   

    if (f) { // 'f' to place a platform/turret thingy

      //this.addChild(new StandardPlatform(new PVector(mouseX, mouseY), new PVector(20, 20)));
      //this.addChild(new StandardPlatform(new PVector(playerzor.getPosition().x, playerzor.getPosition().y), new PVector(20, 20)));
      this.addChild(new MobilePlatform(new PVector(playerzor.getPosition().x, playerzor.getPosition().y), new PVector(20, 20), this, playerzor, 25));

      //key = 0;
    }       

    if (keyPressed) {

      if (key == 's') { // 's' to reset health
        planet.setTotalLife(planet.getMaxLife()); 
        playerzor.setTotalLife(playerzor.getMaxLife());
        ui.notify("Health restored to full");
      }      

      else if (key == 'g') {// 'g' to clear platforms
        for (int i = 0; i < this.getChildren().size(); i++) {
          Entity e=(Entity)this.getChildren().get(i);
          if (e.getType() == "Platform") {
            e = null;
            this.getChildren().remove(i);
          }
        }
      }
      else  if (key  == ' ')
      {
        tracking  = !tracking;
        key = 0;
      }
    }
  }
}

// The BFG goes on the planet...
// Consider inheriting from an abstract gun/turret class.
class BFG extends Entity
{
}

