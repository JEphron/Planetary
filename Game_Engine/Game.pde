///////////////////////////////////////////////
// This is the game state. It is the state where all of 
// the game logic, drawing, and interaction take place. 
// 
///////////////////////////////////////////////

// TODO: • Stuff
//       • More stuff
//       • Stop being lazy with comments
//       • Implement targeting algorithm
//       • Implement particle system
//       • for (Iterator<Entity> i=this.getChildren().iterator(); i.hasNext();) {
//       • minimap

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
  PVector focus = new PVector(0,0);

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

class MainGame extends GameScene
{

  StarField sf = new StarField(300);
  Sun sun = new Sun(200, color(255, 220, 40), 250, new PVector(width/2, height/2), 1, false);                     
  Planet planet;            
  MainGame()
  {
    sf.generateField();
    this.addChild(sf);
    sun.setPosition(new PVector(width/2, height/2));
    s = new PVector(600, 600);
    planet = new Planet(50, color(100, 200, 170), 250, new PVector(width/2, height/2), 1, true);
    sun.addPlanet(planet);
    this.addChild(sun);
  } 

  PVector scenePos = null;
  boolean derp = true;
  Timer t;

  // GAME LOGIC:
  void action()
  {

    fill(0);
    rect(0, 0, width, height);
    updateChildren();   


    Sun s = (Sun)this.getChild(1);
    Planet p = (Planet)s.getChild(0);
    PVector planetPos = p.getPosition().get();

    // Always try to update the position
    this.movePointTowardsPoint(this.getPosition(), new PVector(width/2, height/2));

    // Something is seriously messed up with this code, PLEASE FIX ME:
    if (derp) {
      t = new Timer(1);
      t.start();
      this.setFocus(convertToLocal(planetPos));
      derp = false;
    }
    if (t.isFinished())
    {
      derp = true;
    }
  }
  
  // Move the rect towards a point with decreasing speed
  PVector movePointTowardsPoint(PVector p1, PVector p2) {
    float moveDist = 0.2;
    // only call this when we have to move the rect...
    if (p1.x+s.x/2 != p2.x || p1.y+s.y/2 != p2.y) {

      // calulate difference between points
      PVector v  = new PVector(p2.x-p1.x, p2.y-p1.y);

      // add the distance and the current position and multiply by a scale factor, then subtract to get the point you want
      this.setPosition(new PVector( ((p1.x+v.x*moveDist)-((s.x/2)+focus.x)/(1/moveDist)), ((p1.y+v.y*moveDist)-((s.y/2)+focus.y)/(1/moveDist))) );

      // doesn't need to return, this is stupid
      return new PVector(p1.x+(v.x)*0.2, p1.y+(v.y)*0.2);
    }

    return p1;
  }

  // Overwrite this so we can do some updatin.
  void updateChildren()
  {
    if (this.getChildren().size()>0) {
      for (Iterator<Entity> i=this.getChildren().iterator(); i.hasNext();) {
        Entity e=i.next();
        e.action();
      }
    }
  }
}
// The BFG goes on the planet...
// Consider inheriting from an abstract gun/turret class.
class BFG extends Entity
{
}
