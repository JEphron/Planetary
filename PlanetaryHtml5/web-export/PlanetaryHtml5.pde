/* @pjs crisp=true; 
pauseOnBlur=true; 
preload="SunResized.png"; 
 */

Engine eng;
void setup()
{//port 9001
  //size(720, 400);
  size(900, 900);

   frameRate(60);
   Processing.logger = console;
  //size(360, 480);// 480/360 = 1.3333...
  eng = new Engine(0, 4);
}

void draw()
{
  fill(255);
  background(30);
  eng.handle();
}



// Check if a point is in a rectangle. Currently just checks mouse, too lazy to fix this. 
boolean pointInRect(PVector pt, PVector pos, PVector s)
{
  if (pt.x >= pos.x && pt.x < s.x+pos.x && pt.y >= pos.y && pt.y <= s.y+pos.y)
  {
    return true;
  }
  return false;
}


///////////////////////////////////////////////
//  This is the main Engine class. It should  
//  be crearted at the start of the program
//  It is resposible for managing, updating,
//  and switching states. 
//  Also contains IAppState
///////////////////////////////////////////////

// TODO: • Stack based state switching.
//       • State level transitions. 
//       • Make member vars private/protected

// Create with starting state and ending state: equiv to Handler
class Engine
{
  int nextState;
  int exitState;
  IAppStates appState;

  // Construct with a starting state and an ending state
  Engine(int startState, int endState) 
  {
    exitState = endState;
    nextState = startState;
    // start out with the initial start state.
    appState = createAppStates(nextState);

    handle();
  }

  void handle()
  {
    //////////////////
    // Create the state, 
    // run each tick and update scene
    // if expired, delete and create new scene

      // check if appState has been created and create it if it hasn't
    if (appState==null)
      appState = createAppStates(nextState);

    appState.action();

    // check to see if the state has declared a next state.
    // if it has, delete the current state and create a new one.
    if (appState.getNextState() != nextState)
    {
      nextState = appState.getNextState();

      appState = createAppStates(nextState);
    }
  }

  // Call this each frame, or don't. 
  void update()
  {
  }

  // Creates the new state.
  IAppStates createAppStates(int state)
  {
    switch(state) {
    case 0:
      return new LoadCore();

    case 1:
      return new Menu();

    case 2:
      return new Game();

    case 3:
      println("Done with app, exiting");
      exit();
      break;
    case 4: 
      exit();
      println("Program terminated.");
      break;
    default:
      println("ERROR: Problem creating new app state, does it have a corrosponding switch case?");
      break;
    }
    return null;
  }
}

abstract class IAppStates
{
  // Holds the next app state
  int nextAppStates;
  IAppStates()
  {
  }
  // Set the next state
  void setNextState(int next) { 
    nextAppStates = next;
  }

  int getNextState() {
    return nextAppStates;
  }

  // Do whatever the state does, state class should overwrite
  void action() {
  }
}

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
    ui.addUIItem(new HealthBar(new PVector(mini.getPosition().x+mini.getSize().x+5, 10), new PVector(width/2, 20), planet)); // Width and height should be relative
    ui.addUIItem(new HealthBar(new PVector(mini.getPosition().x+mini.getSize().x+5, 40), new PVector(width/3, 20), playerzor)); // Width and height should be relative
    ui.addUIItem(new UITray(new PVector(0, height-100), new PVector(width, 100)));
    //----------------------------------------------------------------------------------------------------------------
    // Ai
    this.addChild(new AISpawner(this, new PVector(width/2-800, 50)));
    //this.addChild(new AISpawner(this, new PVector(width/2+800, 50)));

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
    planetPos = planet.getPosition().get();
    updateChildren();
    ui.action();
    mini.action();
    handleKeyPresses();
    fill(255);
    textAlign(LEFT);
    text(frameRate, 5, mini.getPosition().y+mini.getSize().y+textAscent()+5);
    if (tracking) {
      PVector focusPoint = new PVector(playerzor.getPosition().x-width/2 +s.x/2, playerzor.getPosition().y-height/2 +s.y/2);   // ToDo: move this into it's own method  
      setFocus(convertToLocal(focusPoint));
      this.movePointTowardsPoint(pos, new PVector(width/2+1, height/2), trackSpeed);
    }
    //println(convertToLocal(playerzor.getPosition()).x);
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
  void updateChildren()
  {
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
              if (dist(m.getPosition().x, m.getPosition().y, planetPos.x, planetPos.y)<30) {
                if (!m.isExploding())
                  planet.dealDamage(m.getDamage());
                m.explode();
              }
              if (dist(m.getPosition().x, m.getPosition().y, playerzor.getPosition().x, playerzor.getPosition().y)<50) {
                if (!m.isExploding())
                  playerzor.dealDamage(m.getDamage());
                m.explode();
              }
            }
            else { // if belongs to player
              ArrayList ailist = this.getChildrenByType("Ai");

              if (m.needsRetarget()) // only applies to missiles
              {
                if (ailist.size() >0) // if the target is dead then aquire a new target
                  m.setTarget((Entity)ailist.get(ailist.size()-1));
                else
                  m.setTarget(null);
              }

              for (int t = 0; t < ailist.size(); t++)
              {
                Ship s = (Ship)ailist.get(t);
                if (distV(m.getPosition(), s.getPosition())<30) {
                  m.explode();
                  s.dealDamage(5);
                }
              }
            }
            if (m.isExpired()) {
              m = null;
              this.getChildren().remove(i);
            }
          }else if ( e.getType() == "Sun" ) {
            // I guess I don't really need to do anything here
            Planetary pl = (Planetary)e;
            mini.displayPoint(pl.getPosition(), color(255, 255, 0), 25);
            mini.displayPoint(pl.getChild(0).getPosition(), color(100, 200, 170), 5);
            pl.action();
            if (pl.getChild(0).getLife()<=0) {
              ui.notify("Your planet is dead."); //todo: find out which life bar was totaled.
            }
          } else if ( e.getType() == "Platform" ) {
            Platform t = (Platform)e;
            mini.displayPoint(t.getPosition(), color(0, 0, 255), 2);
            if (t.targIsDead()) {
              ArrayList temp = this.getChildrenByType("Projectile");
              temp.addAll(this.getChildrenByType("Ai"));
              if (temp != null)
                t.aquireTarget(temp);
            }
            t.action();
            t.fire();
          }          else if (e.getType() == "Ai") {
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
              ArrayList temp = this.getChildrenByType("Ai");
              if (temp != null)
                p.aquireTarget(temp);
            }
          }
          else {
            // Other type checks go right here
            e.action();
          }
           

          
        }
        else {
          e.action();
        }
      }
    }
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
        this.addChild(new StandardPlatform(new PVector(playerzor.getPosition().x, playerzor.getPosition().y), new PVector(20, 20)));
        //this.addChild(new MobilePlatform(new PVector(playerzor.getPosition().x, playerzor.getPosition().y), new PVector(20, 20), this, playerzor, 25));

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

// This file is for useful functions and classes that might need to be used all over the app. 

/* * * *
 * Returns true if the point pt is inside the 
 * rectangle specified by pos and s (upper left/width/height)
 */

// Check if a point is in a rectangle. Currently just checks mouse, too lazy to fix this. 
boolean pointInRect(PVector pt, PVector pos, PVector s)
{
  if (pt.x >= pos.x && pt.x < s.x+pos.x && pt.y >= pos.y && pt.y <= s.y+pos.y)
  {
    return true;
  }
  return false;
}

// Draw a line starting at a point at a given angle to a given length
void lineFromPointLengthAngle(float x, float y, float len, float angle)
{
  float x2;
  float y2;
  float a = angle * PI/180;
  x2 = x + len * cos(a);
  y2 = y + len * sin(a);
  line(x, y, x2, y2);
}

// Draw a cross with lines - PVector edition
void drawCross(PVector p, int lnLen) {
 line(p.x-lnLen, p.y, p.x+lnLen, p.y);
 line(p.x, p.y-lnLen, p.x, p.y+lnLen);
}

// Draw a cross with lines - x/y coords edition
void drawCross(float x, float y, int lnLen) {
 line(x-lnLen, y, x+lnLen, y);
 line(x, y-lnLen, x, y+lnLen);
}

// Random timer I stole from somewhere, because programmers jack shit
class Timer {

  int savedTime; // When Timer started
  int totalTime; // How long Timer should last

  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }

  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis();
  }

  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } 
    else {
      return false;
    }
  }
}

float distV(PVector p1, PVector p2)
{
  return dist(p1.x,p1.y,p2.x,p2.y);
}

float AngleTo(PVector f, PVector p)
{
  float xp = f.x - p.x;
  float yp = f.y - p.y;

  float desiredAngle = atan2(yp, xp); // this is the angle to the target
  return desiredAngle*= 180/PI;
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

///////////////
// ** Other functions to write **
// PointInCircle
// CircleCircleCollisionTest
// RectRectCollisionTest
// RectCircleCollisionTest
// 


// Because processing doesn't allow static variables
boolean Up = false;
boolean Down = false;
boolean Left = false;
boolean Right = false;
boolean Fire = false;
boolean d = false;
boolean f = false;

// mouse stuff
float mX;
float mY;

// get mousePressed positions,
// set Pos to currentMousePos - mousePressedPos relative to original position
void mousePressed()
{
  mX = mouseX;
  mY = mouseY;
}

// handle key presses
void keyPressed()
{
  if (keyCode == LEFT)
    Left = true;
  if (keyCode == RIGHT)
    Right = true;
  if (keyCode == UP)
    Up = true;
  if (keyCode == DOWN)
    Down = true;
  if (key == 'a')
    Fire = true;
  if (key == 'd')
    d = true;
  if (key == 'f')
    f = true;
}

// handle key releases
void keyReleased()
{
  if (keyCode == LEFT)
    Left = false;
  if (keyCode == RIGHT)
    Right = false;
  if (keyCode == UP)
    Up = false;
  if (keyCode == DOWN)
    Down = false;
  if (key == 'a')
    Fire = false;
  if (key == 'd')
    d = false;
  if (key == 'f')
    f = false;
}

class LoadCore extends IAppStates
{
  LoadCore()
  {
    nextAppStates = 0;
    println("Loading core resources...");
  }
  void action()
  {
    // Load images and sounds or something
    setNextState(1);
  }
}

///////////////////////////////////////////////
// This is the Menu state, it controls and manages
// the creation and deletion of individual menuScenes
// Should also do transitions between menus. 
///////////////////////////////////////////////

// TODO: • Make MenuButton a subclass of MenuItem. We want support for items other than buttons.
//       • Reverse the order of the buttons to make the addition process more user friendly
//       • Come up with a more consitant naming scheme
//       • Add flash to black/white transition.

class Menu extends IAppStates
{
  // enum value
  String nextScene;

  // currently displaying scene
  MenuScene currentScene;

  // scene which is about to be displayed. 
  // If someone thinks of a name that better describes what this does please let me know
  MenuScene newScene;

  Menu()
  {
    println("Entering main menu...");
    nextAppStates = 1;
    // Create the Main scene
    currentScene = createNewScene("Main");
    nextScene = currentScene.getNextScene();
  }
  void action()
  {
    // overview:
    // check if the scene has changed it's nextscene variable.
    // if it has, create the new scene underneath the current.
    //  –› Transition the old scene off of the canvas and then delete it.
    //  –› Display the new scene.
    // if it hasn't, keep looping. 

    // update the newScene if it exists
    if (newScene != null) {
      newScene.action();
      //if (currentScene.doFadeOut(20))
      if (currentScene.doSlideOut(50))
      {
        currentScene = newScene;
        newScene = null;
      }
    }

    // Display a menu and implement a menu state system.
    currentScene.action();

    if (currentScene.getNextScene() != nextScene) {
      newScene = createNewScene(currentScene.getNextScene());

      if (currentScene != null)
        nextScene = currentScene.getNextScene();
    }
    //setNextState(AppStates.Game);
  }

  MenuScene createNewScene(String scene)
  {
//    // Switch returns scene based on enum
    if ( scene == "Play") {
      setNextState(2);
      return null;
    }
    else if (scene == "Main") {
      return new mm_Main();
    }
    else if (scene == "Options") {
      return new mm_Opts();
    }
    else if (scene == "Derp") {
      return new mm_Derp();
    }else if(scene == "Help"){
            return new mm_Help();
    }else if(scene == "Exit"){
            setNextState(4);
    //  return null;
    }
 return null;

  }
}

/* * * *
 * MenuButton holds a text value and performes an
 * action when clicked. If it's going to trigger a
 * scene change it'll return an enum value which will
 * be picked up by the mainMenu state and then created.
 * OVERLOAD: Takes callback object, calls callbackMethod() onClick;
 */
// Note: could extend entity for maximum oop
class MenuButton
{
  // TODO: background/rollover/click images.
  PVector pos = new PVector(0, 0); 
  PVector s; //size
  String label; // the text label of the button
  boolean isCallbackButton = false; // does the button execute a callback?
  color c, oc; // color and original color
  String targetScene; 
  callbackObject callback; // object which gets called if this = callbackButton
  MenuScene parentScene;

  MenuButton(String t, String sc, PVector size, MenuScene parent) {
    s=size;
    label = t;
    targetScene = sc;
    c = oc = color(100, 100, 100);
    parentScene = parent;
  }

  // overload if you need to run actual code;
  MenuButton(String t, PVector size, callbackObject cbo) {
    label = t;
    s=size;
    callback = cbo;
    isCallbackButton = true;
    c = oc =  color(100, 100, 100);
  }

  void update() {
    this.display();
    this.checkMouse();
  }

  void display() {
    // draw a rectangle at pos with width/length of s. Draw text on top of that.
    fill(c);
    rect(pos.x, pos.y, s.x, s.y);
    fill(255);
    textAlign(CENTER);
    text(label, pos.x + s.x/2, pos.y + s.y/2);
  }

  void setPosition(PVector p) {
    pos=p;
  }

  PVector getPosition() {
    return pos;
  }

  void setSize(PVector si) {
    s = si;
  }

  PVector getSize() {
    return s;
  }

  void setColor(color col)
  {
    c = col;
  }

  color getColor() {
    return c;
  }

  void action()
  {
    if (isCallbackButton)
      callback.callbackMethod();
    else {
      parentScene.setNextScene(targetScene);
      println(targetScene);
    }
    mousePressed = false;
  }

  void checkMouse() {
    // should probably sel col on click, call action on release
    if (pointInRect(new PVector(mouseX, mouseY), this.getPosition(), this.getSize())) {
      if (mousePressed) {
        this.setColor(color(red(this.getColor())+120, green(this.getColor()), blue(this.getColor())));
        this.action();
      }
    } 
    else {
      if (!mousePressed)
        this.setColor(oc);
    }
  }
}

/* * * *
 * Because processing doesn't seem to support passing functions as parameters 
 * we're going to have to pass in an object that has a method which can be called. 
 * USAGE: Please subclass this and overwrite the callbackMethod() with whatever 
 * code needs to be called. 
 */
abstract class callbackObject
{
  callbackObject() {
  }
  void callbackMethod()
  {
    // Overwrite this
  }
}

abstract class MenuScene 
{
  PVector pos;
  ArrayList buttons; 
  String title;
  PVector buttonSize; // Change this to adjust button size
  color bgCol = color(30); 
  String nextScene;
  String transDir = "Down";

  MenuScene() {
    buttons = new ArrayList();
    pos = new PVector(0, 0);
  }

  void setNextScene(String m) {
    nextScene = m;
  }
  String getNextScene() {
    return nextScene;
  }

  // Consider renaming to more generic layoutItems()
  void layoutButtons() {
    // Formula for buffer distance in a vertically oriented stack of evenly spaced rectangular objects
    // 
    // H - (N*X)
    // ---------  =  D
    //  (N+1)
    //
    // H = height of screen
    // N = number of items
    // X = height of items 
    // D = buffer dist
    int boxHeight = (int)buttonSize.y;
    int place = 0;
    int bufferDistance = int(height - (buttons.size() * boxHeight))/(buttons.size()+1);
    for (int i = buttons.size()-1; i >= 0; i--) {
      MenuButton b = (MenuButton)buttons.get(i);
      place += bufferDistance;
      b.setPosition(new PVector(width/2 - buttonSize.x/2, place));
      place += boxHeight;
    }
  }

  void addButton(String t, String scene, PVector bSize, MenuScene parent) {
    MenuButton m = new MenuButton(t, scene, bSize, parent);
    buttons.add(m);
  }

  void addCBButton(String t, PVector bSize, callbackObject c) {
    MenuButton m = new MenuButton(t, bSize, c);
    buttons.add(m);
  }

  void action() {
    drawBackground();
    for (int i = buttons.size()-1; i >= 0; i--) {
      MenuButton b = (MenuButton)buttons.get(i);
      b.update();
    }
    drawTitle();
  }

  void drawTitle() {
    textAlign(CENTER);
    fill(255);
    text(title, pos .x + width/2, pos.y + height/20); //  should be positioned better
  }

  void drawBackground() {
    fill(bgCol);
    rect(pos.x, pos.y, width, height);
  }
  boolean doFadeOut(int speed)
  {
    for (int i = buttons.size()-1; i >= 0; i--) {
      MenuButton b = (MenuButton)buttons.get(i);
      b.setColor(color(red(b.getColor()), green(b.getColor()), blue(b.getColor()), alpha(b.getColor()) - speed ));
      println(alpha(b.getColor()));
    }
    bgCol = color(red(bgCol), green(bgCol), blue(bgCol), alpha(bgCol) - speed);

    if (alpha(bgCol) <= 0)
      return true;
    else 
      return false;
  }

  boolean doSlideOut(int speed) {
    PVector tvec = new PVector(0, 0);

    if (transDir == "Up") {
      tvec.y = -speed;
      if (pos.y+height < 0)
        return true;
    }
    else if (transDir == "Down") {
      tvec.y = speed;
      if (pos.y > height)
        return true;
    }
    else if (transDir == "Left") {
      tvec.x = -speed;
      if (pos.x + width < 0)
        return true;
    }
    else if (transDir == "Right") {
      tvec.x = speed;
      if (pos.x > width)
        return true;
    }
    else {
      return false;
    }


    for (int i = buttons.size()-1; i >= 0; i--) {
      MenuButton b = (MenuButton)buttons.get(i);
      b.setPosition(new PVector(b.getPosition().x + tvec.x, b.getPosition().y + tvec.y));
    }
    pos.x += tvec.x;
    pos.y += tvec.y;
    return false;
  }

  boolean derp=false; // Think of a better way to do this when you aren't so tired. 

  boolean doSlideIn(int speed) {
    PVector tvec = new PVector(0, 0);
    if (!derp) {
      for (int i = buttons.size()-1; i >= 0; i--) {
        MenuButton b = (MenuButton)buttons.get(i);

        if (transDir == "Left")
          b.setPosition(new PVector(b.getPosition().x + width, b.getPosition().y));
        else if (transDir == "Down")
          b.setPosition(new PVector(b.getPosition().x, b.getPosition().y-height));
      }
      //pos.x += tvec.x;
      if (transDir == "Left")
        pos.x += width;
      else if (transDir == "Down")
        pos.y -= height;

      derp = true;
    }

    if (transDir == "Up") {
      tvec.y = -speed;
      if (pos.y+height < 0)
        return true;
    }
    else if (transDir == "Down") {
      tvec.y = speed;
      if (pos.y > 0) 
        pos.y = 0;
        return true;
    }
    else if (transDir == "Left") {
      tvec.x = -speed;
      if (pos.x < 0) 
        pos.x = 10;
        return true;
    }
    else if (transDir == "Right") {
            tvec.x = speed;
      if (pos.x > width)
        return true;

    }
    else {
      return false;
    }

    for (int i = buttons.size()-1; i >= 0; i--) {
      MenuButton b = (MenuButton)buttons.get(i);
      if (transDir == "Left") {
        if (b.getPosition().x + 90 > width/2)
          b.setPosition(new PVector(b.getPosition().x + tvec.x, b.getPosition().y + tvec.y));
      }
      else {
        b.setPosition(new PVector(b.getPosition().x + tvec.x, b.getPosition().y + tvec.y));
      }
    }
    pos.x += tvec.x;
    pos.y += tvec.y;
    return false;
  }
}

/* * *
 * mm_Main is the main menu scene,
 * has buttons (play, options, help) 
 */
class mm_Main extends MenuScene
{
  mm_Main()
  {
    title = "Main Menu";
    transDir = "Left";
    nextScene = "Main";
    buttonSize = new PVector(200, 50);
    bgCol = color(100, 50, 50);
    // Add menu items in the constructor, reverse order
    this.addButton("Quit", "Exit", buttonSize, this);
    this.addButton("Help", "Help", buttonSize, this);
    this.addButton("Options", "Options", buttonSize, this);
    this.addButton("Play", "Play", buttonSize, this);
    // Then call layoutButtons();
    this.layoutButtons();
  }
  void action()
  {
    super.action();
  }
}

/* * * *
 * mm_Help is the help/instructions menu. Should have a text box or something with instructions
 */
class mm_Help extends MenuScene
{
  mm_Help()
  {
    title = "";
    nextScene = "Help";
    transDir = "Up";

    bgCol = color(32, 128, 64);
    buttonSize = new PVector(200, 50);
    this.addButton("Return", "Main", buttonSize, this);
    this.addButton("derp", "Derp", buttonSize, this);

    this.layoutButtons();
  }
}

class mm_Derp extends MenuScene
{
  mm_Derp()
  {
    title = "Derp";
    nextScene = "Derp";

    transDir = "Right";
    bgCol = color (128, 64, 32);
    buttonSize = new PVector(200, 50);
    this.addButton("Return", "Main", buttonSize, this);
    this.addButton("Blurrrgh", "Help", buttonSize, this);
    this.addButton("Meep", "Help", buttonSize, this);
    this.layoutButtons();
  }
}

/* * *
 * mm_Opts is the options menu,
 * lets you adjust sound/speed/whatever
 * Need to implement sliders and toggles. 
 */
class mm_Opts extends MenuScene
{
  mm_Opts()
  {
    title = "Options";
    nextScene = "Options";

    transDir = "Right";
    bgCol = color (128, 64, 32);
    buttonSize = new PVector(200, 50);
    this.addButton("Return", "Main", buttonSize, this);
    this.addButton("Blurrrgh", "Help", buttonSize, this);
    this.addButton("Meep", "Help", buttonSize, this);
    this.layoutButtons();
  }
  void action()
  {
    super.action();
  }
}
class Minimap extends UIItem
{
  private int scanRange = 500;
  private ArrayList lst = new ArrayList();
  Minimap(PVector p, PVector siz, color bg)
  {
    pos = p;
    s = siz;
    col = bg;
  }
  void action()
  {
    display();
  }
  void display()
  {
    stroke(255);
    fill(0);
    rect(pos.x, pos.y, s.x, s.y);
    stroke(255);
    // draw center crosshairs
    drawCross(pos.x+s.x/2, pos.y+s.y/2, 5);
    stroke(0);
    fill(255,255,0);
    for (int i = 0; i < lst.size(); i++)
    {
      PointColor p = (PointColor)lst.get(i);
      stroke(p.col);
      strokeWeight(p.sw);
      if (pointInRect(p.pt, pos, s))
        point(p.x, p.y);
      strokeWeight(1);
      stroke(0);
    }
    lst = new ArrayList();
  }

  void displayPoint(PVector p, color c, float sw)
  {
    lst.add(new PointColor(new PVector(map(p.x, 0-scanRange, width+scanRange, pos.x, pos.x+s.x), map(p.y, 0-scanRange, height+scanRange, pos.y, pos.y+s.y)), c, sw));
  }
}

// why doesn't processing have structs?
class PointColor
{
  public PVector pt;
  public float x, y, sw;
  public color col;
  PointColor(PVector p, color c, float strokeWidth)
  {
    col=c;
    pt=p;
    x=p.x;
    y=p.y;
    sw = strokeWidth;
  }
}
///////////////////////////////////////////////
// A planetary body, orbits a point in a circle or ellipse
///////////////////////////////////////////////

// TODO: • Consider adding support for some kind of dynamic gravity system

class Planetary extends Entity
{
  protected int r; // radius of object
  protected int or; // radius of orbit
  protected float angle = 0;// angle of object on orbit
  protected float rotSpeed;
  protected boolean isOrbital; // does this body orbit a point?
  boolean selected = false;

  // construct with the radius of th circle, color of circle, orgin of orbit, and radius of orbit. 
  Planetary(int bodyRadius, color c, int orbitRadius, PVector org, float speed, boolean o )
  {
    r = bodyRadius;
    or = orbitRadius;
    orgin = org;
    col = c;
    rotSpeed = speed;
    pos = new PVector(0, 0);
    isOrbital = o;
  }

  void action()
  {
    if (isOrbital)
      this.rotateAroundOrgin();
    this.display();
  }

  void rotateAroundOrgin()
  {
    //println("meep");
    angle += rotSpeed;
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
  float getRadius() {
    return r;
  }

  boolean isClicked()
  {
    if (mousePressed) {
      if (dist(mouseX, mouseY, pos.x, pos.y)<r) {
        selected = true;
      }
    }
    return false;
  }
}

/* * * *
 * I hope this doesn't get too bloated
 * Classes for planet and Sun, sun supports a number of planets
 */
class Sun extends Planetary
{
  ArrayList planets = new ArrayList();
  Sun(int bodyRadius, color c, int orbitRadius, PVector org, float speed, boolean orbits)
  {
    super(bodyRadius, c, orbitRadius, org, speed, orbits);
    type = "Sun";
     sprt = loadImage("SunResized.png");
  }

  void action()
  {
    super.action();
    this.updateChildren();
    this.display();
    this.centerChildren();
  }

  void centerChildren()
  {
    if (this.getChildren().size()>0) {
      for (Iterator<Entity> i=this.getChildren().iterator(); i.hasNext();) {
        Entity e=i.next();
        e.setOrgin(this.getPosition());
      }
    }
  }   

  ArrayList getPlanets()
  {
    return planets;
  }
  void display()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    scale(1, 1);
    imageMode(CENTER);
    image(sprt, 0, 0);
    popMatrix();
    
  }

  void addPlanet(Planet p) // this does the same thing as addChild(); :\
  {
    this.addChild(p);
  }
}

class Planet extends Planetary
{
  int t = 500; // time between life boosts in ms
  int l = 10; // how much does the life go up each tick
  Timer lifeTimer;
  boolean b = false;

  Planet(int bodyRadius, color c, int orbitRadius, PVector org, float speed, boolean orbits, int life)
  {
    super(bodyRadius, c, orbitRadius, org, speed, orbits);
    type = "Planet";
    setTotalLife(life);
    lifeTimer = new Timer(t); // every t ms, life will go up some.
  }
  void action()
  {
    // Regen health slowly
    if (b) {
      if (this.getLife() < this.getMaxLife()-1)
        this.setLife(this.getLife()+l);
      lifeTimer = new Timer(t);
      lifeTimer.start();
      b=false;
    }
    if (lifeTimer.isFinished()) {       // Reset if finished
      b = true;
    }

    //currentLife -= 10;
    super.action();
  }

//  void display()
//  {
//    pushMatrix();
//    translate(pos.x, pos.y);
//    scale(0.1, 0.1);
//    imageMode(CENTER);
//    image(sprt, 0, 0);
//    popMatrix();
//  }
}

///////////////////////////////////////////////
//  This file contains the various types of defense platform
//  used in the game. They all inherit from the Platform class.
///////////////////////////////////////////////

class Platform extends Entity
{
  int damage;
  float range;
  int rof;
  Timer t = new Timer(rof);
  Entity target;

  Platform()
  {
  }

  void action()
  {
  }

  void display()
  {
  }

  void fireAtTarget()
  {
  }

  boolean targIsDead() {
    return true;
  }

  void aquireTarget(ArrayList a) {
  }

  void fire() {
  }
}

// Rename to Point Defense platform
class StandardPlatform extends Platform
{
  int damage = 5;
  float range = 1200;
  int rof = 1; // rof in ms
  Timer t = new Timer(rof);
  Entity target;

  StandardPlatform(PVector p, PVector si)
  {
    super();
    type = "Platform";
    pos = p;
    s = si;
  }

  void action() {
    this.display();
  }
  void display() {
    fill(255, 255, 0);
    stroke(0);
    //quad(pos.x-s.x/2, pos.y, pos.x,pos.y-s.y/2,pos.x+s.x/2,pos.y,pos.x,pos.y+s.y/2); // draw a rhombus
    rect(pos.x-s.x/2, pos.y-s.y/2, s.x, s.y); 

    line(pos.x-s.x/2, pos.y, pos.x+s.x/2, pos.y);
    line(pos.x, pos.y-s.y/2, pos.x, pos.y+s.y/2);

    // line(pos.x,pos.y+s.y/2,pos.x+s.x,pos.y+s.y/2);
  }
  // will go through all objects in arrayList and select the closest one to target
  void aquireTarget(ArrayList a) {
    float closestDistance = range; 
    Entity temp;
    for (int i = 0; i < a.size(); i++) { 
      Entity h = (Entity)a.get(i);
      float d = distV(pos, h.getPosition());
      if (!h.isTargeted() || h.getType() == "Ai") {
        if (d < closestDistance) {
          closestDistance = d;
          target = h;
         if ((int)random(10)>8) // This adds some randomness to the selection process. 
            break;// I think it makes the results look nicer and the ai look smarter
        }
      }
    }
  }
  boolean hasNoTarget()
  {
    return (target == null);
  }
  boolean targIsDead() {
    if (target != null)
      return target.isExpired();
    else return true;
  } 

  boolean targetInRange()
  {
    if ( dist(pos.x, pos.y, target.getPosition().x, target.getPosition().y) < range)
      return true;
    else return false;
  }

  boolean b = false;
  void fire() {
    if (b) {                    // Try to optimize if spare time == have
      if (!targIsDead()) {      // Don't fire on a dead target
        if (targetInRange()) {  // Only fire if in range, do this once per shot, not every frame
          target.setTargeted(true); // mark the target as targeted so other platforms won't waste time firing on it.
          stroke(random(55)+200, random(100)+100, random(200));
          strokeWeight(1);
          line(pos.x, pos.y, target.getPosition().x, target.getPosition().y);
          // // Optional fancy graphics
          // strokeWeight(4);
          // stroke(0, 100, 255);
          // line(pos.x, pos.y, target.getPosition().x, target.getPosition().y);
          // strokeWeight(1);
          // stroke(255, 255, 255);
          // line(pos.x, pos.y, target.getPosition().x, target.getPosition().y);
          target.dealDamage(damage); // Deal dmg to target
          t = new Timer(rof);  // reset timer
          t.start();
        }
      }
      b = false;
    }
    if (t.isFinished()) {       // Reset if finished
      b = true;
    }
  }
}  

class MissilePlatform extends Platform
{
  Entity parent;
  int damage = 50;
  float range = 200;
  int rof = 1; // rof in ms
  Timer t = new Timer(rof);
  Entity target;

  MissilePlatform(PVector p, PVector si, Entity par)
  {
    super();
    type = "Platform";
    pos = p;
    s = si;
    parent = par;
  }

  void action() {
    this.display();
  }

  void display() {
    fill(200, 255, 0);
    stroke(0);
    ellipse(pos.x, pos.y, s.x, s.y);
  }

  boolean hasNoTarget()
  {
    return (target == null);
  }

  boolean targIsDead() {
    if (target != null)
      return target.isExpired();
    else return true;
  } 

  boolean targetInRange()
  {
    if ( dist(pos.x, pos.y, target.getPosition().x, target.getPosition().y) < range)
      return true;
    else return false;
  }

  void aquireTarget(ArrayList a) {
    float closestDistance = range; 
    Entity temp;
    for (int i = 0; i < a.size(); i++) { 
      Entity h = (Entity)a.get(i);
      float d = dist(pos.x, pos.y, h.getPosition().x, h.getPosition().y);
      if (d < closestDistance) {
        closestDistance = d;
        target = h;
        if ((int)random(6)>3) // This adds some randomness to the selection process. 
          break;// I think it makes the results look nicer and the ai look smarter
      }
    }
  }

  void fire() {
    if (!targIsDead()) {      // Don't fire on a dead target
      if (targetInRange()) {  // Only fire if in range, do this once per shot, not every frame
        noFill();
        stroke(random(55)+200, random(55)+200, 0);
        strokeWeight(1);
        bezier(pos.x, pos.y, random(pos.x-width/5, pos.x+width/5), random(pos.y-width/5, pos.y+width/5), random(pos.x-width/5, pos.x+width/5), random(pos.y-width/5, pos.y+width/5), target.getPosition().x, target.getPosition().y);
        target.dealDamage(damage);
      }
    }
  }
}

//class Torpedo extends Projectile
//{
//  Torpedo()
//  {
//  }
//}


class PulsePlatform extends Platform
{
}

class TorpedoPlatform extends Platform
{
  TorpedoPlatform(PVector p, PVector si)
  {
    super();
  }
}
//------------------------------------------------------------------------------------
//
//class MobilePlatform extends Platform
//{
//  Entity tracktarg;
//  Entity target;
//  Entity parent;
//  float speed;
//  float angle;
//  int turnSpeed;
//  int rad;
//  PVector tPos = new PVector();
//  MobilePlatform(PVector p, PVector si, Entity par, Entity track, int spd)
//  {
//    super();
//    type = "Platform";
//    tracktarg = track;
//    speed = 0.1;
//    angle = 0;
//    turnSpeed = 20;
//    parent = par;
//    pos = p;
//    s = si;
//    range = 300;
//    damage = 1;
//    rad = 50 + (int)random(-10,10);
//    vel = new PVector(-10, -10);
//  }
//
//  void action()
//  {
//    speed = 0.1;
//    rotateAroundOrgin();
//    movePointTowardsPoint(pos,tPos, speed);
//    display();
//  }
//  void movePointTowardsPoint(PVector p1, PVector p2, float moveDist) {
//    // only call this when we have to move the rect...
//    if (p1.x+s.x/2 != p2.x || p1.y+s.y/2 != p2.y) {
//      // calculate difference between points
//      PVector v  = new PVector(p2.x-p1.x, p2.y-p1.y);
//      // add the delta and the current position and multiply by a scale factor, then subtract the focus divided by 1 over the distance. Makes sense. 
//      this.setPosition(new PVector( ((p1.x+v.x*moveDist)-((s.x/2))/(1/moveDist)), ((p1.y+v.y*moveDist)-((s.y/2))/(1/moveDist))) );
//    }
//  }
//
//  void display()
//  {
//    stroke(0);
//    fill(255, 255, 0);
//    ellipseMode(CENTER);
//    ellipse(pos.x, pos.y, s.x, s.y);
//    fill(0);
//    drawCross(pos.x, pos.y, (int)s.x/2);
//  }
//
//  void rotateAroundOrgin()
//  {
//    angle += 10;
//    float xDistance = sin(angle * PI/180)*rad;
//    float yDistance = cos(angle * PI/180)*rad;
//    float xDisCalculated = tracktarg.getPosition().x + xDistance;
//    float yDisCalculated = tracktarg.getPosition().y + yDistance;
//    tPos.x = xDisCalculated;
//    tPos.y = yDisCalculated;
//  }
//
//  void aquireTarget(ArrayList a) {
//    float closestDistance = range; 
//    Entity temp;
//    for (int i = 0; i < a.size(); i++) { 
//      Entity h = (Entity)a.get(i);
//      float d = dist(pos.x, pos.y, h.getPosition().x, h.getPosition().y);
//      if (!h.isTargeted() || h.getType() == "Ai") {
//        if (d < closestDistance) {
//          closestDistance = d;
//          target = h;
//          if ((int)random(10)>8) // This adds some randomness to the selection process. 
//            break;// I think it makes the results look nicer and the ai look smarter
//        }
//      }
//    }
//  }
//  boolean hasNoTarget()
//  {
//    return (target == null);
//  }
//  boolean targIsDead() {
//    if (target != null)
//      return target.isExpired();
//    else return true;
//  } 
//
//  boolean targetInRange()
//  {
//    if ( dist(pos.x, pos.y, target.getPosition().x, target.getPosition().y) < range)
//      return true;
//    else return false;
//  }
//
//  boolean b = false;
//  void fire() {
//    if (b) {                    // Try to optimize if spare time == have
//      if (!targIsDead()) {      // Don't fire on a dead target
//        if (targetInRange()) {  // Only fire if in range, do this once per shot, not every frame
//          target.setTargeted(true); // mark the target as targeted so other platforms won't waste time firing on it.
//          stroke(random(55)+200, random(100)+100, random(200));
//          strokeWeight(1);
//          line(pos.x, pos.y, target.getPosition().x, target.getPosition().y);
//          // // Optional fancy graphics
//          // strokeWeight(4);
//          // stroke(0, 100, 255);
//          // line(pos.x, pos.y, target.getPosition().x, target.getPosition().y);
//          // strokeWeight(1);
//          // stroke(255, 255, 255);
//          // line(pos.x, pos.y, target.getPosition().x, target.getPosition().y);
//          target.dealDamage(damage); // Deal dmg to target
//          t = new Timer(rof);  // reset timer
//          t.start();
//        }else{
//          target = null;
//        }
//      }
//      b = false;
//    }
//    if (t.isFinished()) {       // Reset if finished
//      b = true;
//    }
//  }
//}

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
  String owner = ""; // default to none
  boolean needsNewTarget = false;
  Entity targ;
  //PImage splosionSprt; // the explosion graphic

  Projectile(PVector p, int rng, int spd, int dmg, float ang, PImage graphic)
  {
    setTotalLife(1); // default to 10;
    type = "Projectile";
    pos = p.get();
    savedTime = millis(); // init dat
    range = rng;
    damage = dmg;
    vel = spd;
    angle = ang;
    if (graphic != null)
      sprt = graphic;
  }

  void setOwner(String s) {
    owner = s;
  }
  String getOwner() {
    return owner;
  }

  void explode() {
  }

  boolean needsRetarget() {
    return needsNewTarget;
  }

  void setTarget(Entity t) {
    targ = t;
  }
  void action() {
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
  float getTotalDistanceTraveled() {
    return distTraveled;
  }
  boolean isExploding() {
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

  // Alternate constructor with owner string.
  Bullet(PVector p, int rng, int spd, int dmg, float ang, color c, String own)
  {
    super(p, rng, spd, dmg, ang, null);
    col = c;
    setTotalLife(1);
    // sprt = loadImage("Plasma2.png");
    owner = own;
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
      stroke(col);
      fill(col);
      strokeWeight(5);
      lineFromPointLengthAngle(pos.x,pos.y,10,angle);
      stroke(0);
      strokeWeight(1);
    //  ellipse(pos.x, pos.y, 10, 10);
//         pushMatrix();
//          translate(pos.x, pos.y);
//          rotate(radians(angle));
//          rect(0,0,10,3);
//      //    imageMode(CENTER);
//      //        tint(random(255),255,120);
//      //
//      //    image(sprt, 0, 0);
//      //    tint(255);
//          popMatrix();
//          stroke(0);
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
    if (explody < 30)
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

  // Alternate constructor with owner string.
  HomingMissile(PVector p, int rng, int velocity, float tspeed, Entity target, String own)
  {
    super(p, rng, velocity, 1, 0, null);
    
    setTotalLife(1);
    turnSpeed = tspeed;
    col = color(random(255), random(255), random(255));
    if (target!=null)
      angle = AngleTo(pos, target.getPosition());
    targ = target;
    owner = own;
  }

  void setAngle(float a) {
    angle = a;
  }
  void action()
  {
    if (targ != null && !targ.isExpired()) { // don't try and track a nonexistant target
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
    else { // if target is gone, try to retarget
      needsNewTarget = true;
      pos.x += vel * cos(radians(angle)) ; // just fly straight
      pos.y += vel * sin(radians(angle)) ;      

      display();
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
    if (explody < 30)
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

///////////////////////////////////////////////
// Different types of Ship. Player and AI classes defined here.
// All inherit from Ship base, which inherits from Entity.
///////////////////////////////////////////////

class Ship extends Entity
{
  int wep = 0;         // this should be an object. 
  float speed = 1;      // Speed of the ship
  float turnSpeed = 10;  // How fast can it turn
  PImage sprt;      // What sprite should it use
  float angle = 0;      // The current angle
  float accel=1;      // Speed of acceleration
  float maxSpeed=30;   // Speed cap
  int rof = 500;      // rate of fire, currently broken
  int range = 100;      // set when switching weapons, how far can the bullet go
  //String wep;       // Which weapon does it use.
  Entity targ;    // Ai will seek target and fire upon it, Player's target will be selectable
  Entity parent; // the game scene which bullets will be added to
  Ship(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite, Entity pa)
  {
    speed = 0;
    turnSpeed = turnSpd;
    accel = accelSpd;
    maxSpeed = maxSpd;
    pos = p;
    sprt = sprite;
    parent = pa;
  }
  float getAngle() {
    return angle;
  }
  int getSpeed() {
    return (int)speed;
  } // merge with getVelocity in Entity
  float getMaxSpeed()
  {
    return maxSpeed;
  }
  //  void setWeapon(String w)
  //  {
  //    wep = w;
  //  }
  boolean hasNoTarget()
  {
    return (targ == null);
  }
  void aquireTarget(ArrayList a) {
  }
  boolean targIsDead() {
    if (targ != null)
      return targ.isExpired();
    else return true;
  } 

  void cycleWeps()
  {
    int numWeps = 3;
    wep = ((wep+1) < numWeps) ? wep+1 : 0;
  }
  int getWep() {
    return wep;
  }
  void setTarget(Entity t)
  {
    targ = t;
  }
  void fire()
  {
    switch (wep) {
    case 0:      // fire a homing missile that tracks the target
      range = 2000;
     // if (targ !=null) {
        for (int i = 0; i < 5; i++) {
          HomingMissile h = new HomingMissile(new PVector( pos.x +random(-10, 10), pos.y+random(-10, 10)), range, 30, 30, targ, type); // todo: Incorperate setAngle into constructor
          h.setAngle(angle);  
          parent.addChild(h);
        }
      //}
      break;
    case 1:      // fire the standard gun
      range = 1000;
     // for (int i = 0; i < 5; i++) {
        parent.addChild(new Bullet(/*Position:*/pos, /*Range:*/range, /*Speed:*/20, /*Damage:*/50, /*Angle:*/angle+random(-5, 5), color(255, 0, 255), type));
     // }
      break;
    case 2:       // do a circular explosion thingy
      range = 1000;
      for (int i = 0; i < 360; i+= 30) {
        parent.addChild(new Bullet(/*Position:*/pos, /*Range:*/range, /*Speed:*/2, /*Damage:*/1, /*Angle:*/angle+i, color(100, 255, 55), type));
      }
      break;
    default:
      break;
    }
  }
}

// Simple player class
class Player extends Ship
{
  Player(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite, Entity pa)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite, pa);
    type = "Player"; 
    s = new PVector(20, 20);
    wep =1;
    setTotalLife(400); // SET LIFE TOTAL HERE
  }

  int t = 500; // time between life boosts in ms
  int l = 10; // how much does the life go up each tick
  Timer lifeTimer = new Timer(500);

  void action()
  {
    pos.x += cos(radians(angle))*speed;
    pos.y += sin(radians(angle))*speed;

    if (lifeTimer.isFinished()) {
      if (this.getLife() < this.getMaxLife()-1)
        this.setLife(this.getLife()+l);
      lifeTimer = new Timer(500);
      lifeTimer.start();
    }
    checkKeys();
    display();
  }

  void display()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(radians(angle));
    imageMode(CENTER);
    image(sprt, 0, 0);
    popMatrix();
  }

  void checkKeys()
  {
    if ( Left)
      angle -= turnSpeed;

    if ( Right)
      angle += turnSpeed;

    if ( Up)
    {
      speed += accel;
      if (speed > maxSpeed) {
        speed = maxSpeed;
      }
    }
    if ( Down && speed > 0) {
      speed -= accel;
      if ( speed < 0)
        speed = 0;
    }
  }

  void aquireTarget(ArrayList a) {
    if (a.size()>0) {
      targ = (Entity)a.get((int)random(0, a.size()));
    }else{
      targ = null; 
    }
  }
}

class AISpawner extends Entity // hell, everything extends this... not good oop
{
  int aiPerWave = 2; // increase over time
  int timeBetweenWaves = 2; // In seconds, decrease over time
  PVector spawnPoint; // generate at a random point on a circle that surrounds the play area. 
  int aiType; // this should be random, and eventually become a mixture. 
  float timeOfLastSpawn; // keep track of when to spawn
  float timeSinceLastSpawn;
  ArrayList targets = new ArrayList();
  MainGame parent;

  AISpawner(MainGame parent_entity, PVector p)
  {
    parent = parent_entity;
    timeOfLastSpawn = 0; 
    timeSinceLastSpawn =10000; 
    pos = p; // temporary solution
    type = "SpawnPoint";
  }

  void action()
  {
    updateAI();
    display();
    if (timeSinceLastSpawn > timeBetweenWaves*1000)
      spawnWave(aiPerWave, (int)random(3));

    timeSinceLastSpawn = millis() - timeOfLastSpawn;
  }

  void display()
  {
    stroke(200);
    strokeWeight(5);
    noFill();
    ellipse(pos.x, pos.y, 50, 50); // draw a spawnPoint marker
    fill(255);
    strokeWeight(1);
    stroke(0);
  }

  void updateAI()
  {
    // parent should do this.
  }

  void spawnWave(int num, int type)
  {
    parent.getUI().notify("Wave incoming!!");
    targets.addAll(parent.getChildrenByType("Platform")); // get all the stuff from the parent
    targets.add(((Entity)parent.getChildrenByType("Sun").get(0)).getChild(0)); // this is hacky
    targets.addAll(parent.getChildrenByType("Player"));
    for (int i = 0; i < aiPerWave; i++)
    {
      AI a = new StandardEnemy(new PVector(pos.x + random(-25, 25), pos.y + random(-25, 25)), 10, 1, 20, null, parent);   // create a new ai
      a.aquireTarget(targets);      // give targets to the ai
      parent.addChild(a);            // add it to the parent.
    }
    //aiPerWave += 1; // increase by x each wave
    if (timeBetweenWaves>2) // don't spawn too fast...
      timeBetweenWaves -= 0; // decrease time by 1 second
    timeSinceLastSpawn = 0;
    timeOfLastSpawn = millis();
    targets.clear();
  }
}

// AI Classes:
class AI extends Ship
{
  AI(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite, Entity pa)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite, pa);
    type = "Ai";
  }

  boolean targetInRange()
  {
    if ( dist(pos.x, pos.y, targ.getPosition().x, targ.getPosition().y) < /*wep.getrange()*/500)
      return true;
    else return false;
  }

  void aquireTarget(ArrayList a)
  {
    String s = "";
    int sel = (int)random(90);
    // choose either player, turret, or planet. Planet should have higher priority. 

    if (sel <30) { 
      s = "Planet";
    } 
    else if (sel < 60) {
      s = "Player";
    } 
    else if (sel < 90) {
      s = "Platform";
    }

    targ = (Entity)a.get((int)random(0, a.size()));
    //    for (int i = 0; i < a.size(); i++) { 
    //      Entity h = (Entity)a.get(i);
    //      if (h.getType() == s)
    //      {
    //        if ( s == "Platform" ) {
    //          if ((int)random(10) < 7) {
    //            targ = h; // if it's a platform then choose a random one.
    //            break;
    //          }
    //        }
    //        else { // generally guarenteed to be only one player/planet
    //          if (targ != null)
    //            targ = h;
    //          break;
    //        }
    //        println(targ);
    //      }
    //    }
  }

  void fire()
  {
    super.fire();
  }
}


// These pirates form fleets, flock around target and shoot
// Boid logic
class BoidPirate extends AI
{
  BoidPirate(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite, Entity pa)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite, pa);
  }
}

// The standard enemy ai simply flys towards its target, firing when in range. 
// Logic similar to homing missile
class StandardEnemy extends AI
{
  Timer t = new Timer(500);
  int explody = 0;
  StandardEnemy(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite, Entity pa)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite, pa);
    setTotalLife(150);
    wep = 1;//(int)random(3);
    type = "Ai";
    s = new PVector(10, 10);
  }

  boolean b = false;
  boolean exploding = false;
  void action()
  {
    if (!exploding) {
      seekTarget();
      display();
      if (b) {                    // Try to optimize if spare time == have
        if (!targIsDead()) {      // Don't fire on a dead target
          if (targetInRange()) {  // Only fire if in range, do this once per shot, not every frame
            fire();
            // targ.dealDamage(1); // no
            t = new Timer(rof);  // reset timer
            t.start();
          }
        }
        b = false;
      }
      if (t.isFinished()) {       // Reset if finished
        b = true;
      }
      if (currentLife <=0)
        explode();
    }
    else {
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
    fill(random(200, 250), random(200, 255), 0, random(50, 250));
    ellipse(pos.x, pos.y, explody, explody);
    stroke(1);
  }


  void display()
  {
    fill(map(currentLife, 0, maxLife, 255, 0), map(currentLife, 0, maxLife/5, 0, 255), 0);
    noStroke();
    rect(pos.x, pos.y-20, 20*(float)currentLife/maxLife, 2);
    stroke(0);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(radians(angle));
    rectMode(CENTER);
    fill(100, 90, 120);
    stroke(0);
    rect(0, 0, s.x, s.y);
    rectMode(CORNER);
    popMatrix();
  }
  void seekTarget() // can be extracted, used by both homing missile and ai
  { 
    if (targ != null) {
      PVector targetPosition = targ.getPosition();
      PVector thrust = new PVector(0, 0); // forward direction vector.
      thrust.x = 1 * cos(radians(angle));
      thrust.y = 1   * sin(radians(angle));      
      float sign = beringAsMagnitudeCubic2d(pos, thrust, targetPosition);
      if ( sign < 0) {
        angle -= turnSpeed;
      }
      else if (sign > 0) {
        angle += turnSpeed;
      }
      pos.x += thrust.x;
      pos.y += thrust.y;
    }
  }
}
// Fly straight at their target and detonate when they reach it
// Straight homing missile logic, explode when dist < 1
class BombShip extends AI
{
  BombShip(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite, Entity pa)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite, pa);
  }
}

// hang out at a distance and fire long range missiles/lasers
// Homing missile logic, stop at fixed dist and begin firing
class LongRangeFrigate extends AI
{
  LongRangeFrigate(PVector p, float turnSpd, float accelSpd, float maxSpd, PImage sprite, Entity pa)
  {
    super(p, turnSpd, accelSpd, maxSpd, sprite, pa);
  }
}

///////////////////////////////////////////////
// Star field object generates a random
// field of points in a given area and draws them
///////////////////////////////////////////////
class StarField extends Entity
{
  protected ArrayList stars;
  protected int nStars;
  StarField(int numStars) {
    stars = new ArrayList();
    nStars = numStars;
    pos = new PVector(0, 0);
  }

  void generateField() {
    for (int i = 0; i < nStars; i++) {
      PVector n = new PVector(random(width*2)-width/2, random(height*2)-height/2);
      stars.add(n);
      //  println("Bleh");
    }
  }

  void action() {
    this.display();
  }

  void display() {
    stroke(255);
    for (int i = stars.size()-1; i > 0; i--) { 
      PVector n =(PVector) stars.get(i);
      point(n.x, n.y);
    }
    stroke(0);
  }

  void setPosition(PVector p) {
    for (int i = stars.size()-1; i > 0; i--) { 
      PVector n =(PVector) stars.get(i);
      stars.set(i, new PVector(n.x -(pos.x-p.x)/2, n.y + (p.y - pos.y)/2));
    }
  }
}

///////////////////////////////////////////////
// This file contains the UI_Layer class
///////////////////////////////////////////////

// The planet health bar goes at the top of the screen. It is a quad with slanted sides. It is red with pink stripes
// Health of platforms float above them
// Your money is a text value
// there is a gold bar with light yellow stripes
// All these things are contained within the UI layer, a stationary layer that holds UI elements and recieves mouseClicks

// TODO:
//       Implement a drag and drop method.
//       Get placement working. 
//       Major overhaul. It's coming. eventually...
// Generic UI Item
class UIItem extends Entity {
  boolean checkClick()
  {
    return false;
  }
}

// Healthbar class is a bar that decreases in length when the object it is attached to takes damage
class HealthBar extends UIItem
{
  Entity parent;
  float maxLife, currLife;
  HealthBar(PVector po, PVector si, Entity p)
  {
    // Pass the healthBar a parent object, healthbar will get the lifeTotal and currentLife and display them. 
    parent = p;
    maxLife = parent.getMaxLife();
    pos = po;
    s = si;
    currLife = 1000;
  }

  void action()
  {
    // Is it economical to do this each frame?
    // Could save some processing if we didn't update each frame.
    currLife = parent.getLife();
    if (currLife < 0)
      currLife = 0;
    this.display();
  }

  void setLife(int l)
  {
    currLife = l;
  }
  void display()
  {
    // Draw a bar with a length proportiional to the percentage of life remaining
    // Color shift could use work though...
    fill(map(currLife, 0, maxLife, 255, 0), map(currLife, 0, maxLife/5, 0, 255), 0);
    textAlign(LEFT);
    rect(pos.x, pos.y, s.x*(currLife/maxLife), s.y);
    if (currLife>0)
      fill(255);
    else
      fill(255, 0, 0);
    text(parent.getType()+": "+(int)currLife, pos.x+5+s.x*(currLife/maxLife), pos.y+textAscent()+4);
  }
  Entity getParent() {
    return parent;
  }
}

// Add: Money display, drawer for platforms, info box, sound controls, pauseButton. UI overlay with fancy imgs or whatever

// Techincally not really an entity, decided not to inherit
class UILayer 
{ 
  Minimap mini;
  ArrayList items;
  Notifier nfier;

  UILayer()
  {
    //It's static
    //pos = new PVector(0, 0);
    items = new ArrayList();
    nfier  = new Notifier();
  }

  void addUIItem(UIItem t)
  {
    items.add(t);
  }

  void action()
  {
    // Draw the addable items (healthbar, string, etc)
    for (int i = items.size()-1; i >= 0; i--) {
      UIItem e = (UIItem)items.get(i);
      e.action();
    }

    nfier.action();
  }

  void notify(String s)
  {
    nfier.addMsg(new UIString(s, new PVector(0, 0), 800));
  }

  void setPlayerWep(int w)
  {
  }
}

class Notifier extends UIItem
{
  ArrayList msgs;
  Notifier()
  {
    msgs = new ArrayList();
  }

  void addMsg(UIString str)
  {
    msgs.add(str);
    layoutMsgs();
  }

  void action() {
    this.display();
  }
  void display() {
    for (int i = 0; i < msgs.size(); i++) {
      UIString u = (UIString)msgs.get(i);
      u.action();
      u.doFade(); // animate fade in/out
      if (u.isExpired()) {
        u = null;
        msgs.remove(i); 
        layoutMsgs();
      }
    }
  }

  void layoutMsgs()
  {
    for (int i = 0; i < msgs.size(); i++) {
      UIString u = (UIString)msgs.get(i);
      u.setPosition(new PVector(width-textWidth(u.getText()), (i*20)));
    }
  }
}

// Contains a number of panels, these are clickable and do things
class UITray extends UIItem
{
  ArrayList items = new ArrayList();
  PVector boxSize = new PVector(width/10, height/10);
  UITray(PVector po, PVector si)
  {
    pos = po;
    s = si;
    type = "UITray";
    // when clicked, set placement type. on click, place that type and then reset.
//    class cbo extends callbackObject
//    {
//      String t;
//      cbo(String s) {
//        t=s;
//      }
//      void callbackMethod()
//      {
//        println(t);
//      }
//    }

    //this.addItem(new UIString("Controls"));
    this.addItem(new UIString("A to fire"));
    this.addItem(new UIString("S to reset life"));
    this.addItem(new UIString("D to change weps"));
    this.addItem(new UIString("F to place turret"));
    this.addItem(new UIString("G to clear turrets"));

    //     this.addItem(new UIBox(boxSize, new cbo("Three"), new StandardPlatform(new PVector(100, 100), new PVector(20, 20))));
    //    this.addItem(new UIBox(boxSize, new cbo("Three"), new StandardPlatform(new PVector(100, 100), new PVector(20, 20))));
    //    this.addItem(new UIBox(boxSize, new cbo("Four"), new StandardPlatform(new PVector(100, 100), new PVector(20, 20))));
  }

  void action()
  {
    this.display();
  }

  int w = width; 
  int h = height;

  void display()
  {
    drawUIBg();
    drawUIItems();

    // If the width has changed resize the boxes and lay them out
    if (w != width || h!= height) {
      boxSize = new PVector(width/10, width/10);
      layoutItems();
    }
    w = width; 
    h = height;
  }

  void drawUIBg()
  {
    fill(100, 100, 100, 100);
    stroke(0);
    rect(0, height-height/10, width, 150);
  }

  void drawUIItems()
  {
    for (int i = 0; i < items.size(); i++)
    {
      UIItem b = (UIItem)items.get(i);
      b.action();
      if (mousePressed) {
        b.checkClick();
      }
    }
  }

  void addItem(UIItem u) 
  {
    items.add(u);
    layoutItems();
  }

  void layoutItems()
  {
    int boxHeight = (int)boxSize.x;

    int place = 0;
    int bufferDistance = int(width - (items.size() * boxHeight))/(items.size()+1);
    for (int i = 0; i < items.size(); i++) {
      UIItem b = (UIItem)items.get(i);
      place += bufferDistance;
      b.setPosition(new PVector(place, height - height/10));
      b.setSize(boxSize);
      place += boxHeight;
    }
  }
}

class UIString extends UIItem
{
  String txt;
  int alphaCol = 255;
  int fadeTime = 0;
  boolean doneFadingIn = false;
  Timer t;
  UIString(String s)
  {
    txt=s;
    pos = new PVector (0, 0);
    type = "UIString";
  }

  UIString(String s, PVector po)
  {
    txt=s;
    pos = po;
    type = "UIString";
  }

  UIString(String s, PVector po, int fTime)
  {
    txt=s;
    pos = po;
    alphaCol = 0;
    fadeTime = fTime; // how long does it stay onscreen before fading out
    type = "UIString";
  }
  String getText() {
    return txt;
  }
  void action()
  {
    fill(255, 255, 255, alphaCol);
    this.display();
  }

  void doFade()
  {
    if (alphaCol < 255 && !doneFadingIn) {
      alphaCol +=25;
    }
    else {
      doneFadingIn = true;
      if (t == null) {
        t= new Timer(fadeTime);
        t.start();
      }
      if (t.isFinished()) {
        alphaCol-=25;
        if (alphaCol<0)
          expired = true;
      }
    }
  }
  void display()
  {
    textAlign(CENTER);
    text(txt, pos.x, pos.y+textDescent()+textAscent());
  }
}

// It's a little boxy thing that you click on and stuff
class UIBox extends UIItem
{
  PImage img;
  Platform pl;
  callbackObject cbo;
  UIBox( PVector si, callbackObject callback, Platform p)
  {
    cbo = callback;
    s = si;
    pl = p;
  }

  void action()
  {
    this.display();
  }

  void display()
  {
    fill(200);
    rect(pos.x, pos.y, s.x, s.y);
    //pl.setPosition(new PVector(pos.x+s.x/2, pos.y+s.y/2));
    //pl.display();
  }

  boolean checkClick()
  {
    if (pointInRect(new PVector(mouseX, mouseY), pos, s))
    {
      cbo.callbackMethod();
      return true;
    }
    else return false;
  }
}


class UIWepBox extends UIItem {  
  UIWepBox() {
  }

  void action() {
    this.display();
  }
  void display() {
  }

  void setWeapon() {
  }
}


