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
    // println(frameRate);

    currentScene.action();
    // Call this to signal that the game should end\
    //setNextState(AppStates.Exit);

    
    if(mousePressed){
      if(scenePos == null)
      scenePos = currentScene.getPosition(); // this becomes the original position
      PVector difference = new PVector( mouseX - mX, mouseY - mY);
      //PVector newPos = new PVector(); 
      
      // Three styles of scrolling:
      // TODO: Add boundry scrolling. Arrow scrolling.
      
      //currentScene.setPosition(new PVector(mouseX-width/2, mouseY-height/2)); // absolute positioning based on mouse
      //currentScene.setPosition(new PVector(currentScene.getPosition().x - difference.x, currentScene.getPosition().y - difference.y)); // Relative positioning with cont. scrolling
      //currentScene.setPosition(new PVector(scenePos.x + difference.x, scenePos.y + difference.y)); // Touchscreen-style controls - more natural
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
  PVector focus;

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

  void setFocus(PVector focusPoint)
  {
    // reset to 0 before transform
    this.setPosition(new PVector(0,0));
    this.setPosition(new PVector(focusPoint.x + width/2 - this.getPosition().x, focusPoint.y + height/2-this.getPosition().y));
  }
}

class MainGame extends GameScene
{

  StarField sf = new StarField(300);
  Sun sun = new Sun(200,                           // Diameter of body
                    color(255, 220, 40),           // Color
                    250,                           // Orbital Diameter
                    new PVector(width/2, height/2),// Orgin
                    1,                             // Rotational speed
                    false);                        // Does it orbit?
                    
  MainGame()
  {
    sf.generateField();
    this.addChild(sf);
    sun.setPosition(new PVector(width/2,height/2));
    Planet planet = new Planet(50, color(100, 200, 170), 250, new PVector(width/2, height/2), 1, true);
      // planet.setPosition(new PVector(20,20));
    sun.addPlanet(planet);
    this.addChild(sun);
  } 
  
  PVector scenePos = null;
  boolean derp = true;
  Timer t;
  void action()
  {

    fill(0);
    rect(0, 0, width, height);
    updateChildren();   
    
    
      Sun s = (Sun)this.getChild(1);
      Planet p = (Planet)s.getChild(0);
      PVector planetPos = p.getPosition().get();
//
//    PVector mPos = new PVector(mouseX-width/2, mouseY-height/2); // position of mouse relative to center of screen
//
//    PVector diff = new PVector(planetPos.x + this.getPosition().x, planetPos.y +this.getPosition().y);
//    
//    // to get the global coords of the planet, subtract from it's position the position of the scene.
//    PVector globalCoords = new PVector(planetPos.x - this.getPosition().x, planetPos.y - this.getPosition().y);
//   // PVector mD = new PVector(mouseX - this.getPosition().x - width/2, mouseY -this.getPosition().y - height/2);
//
//    // ellipse(diff.x,diff.y,20,20);
//    println(this.getPosition() + " "+ globalCoords +" " + planetPos);
//    
//    // this.setPosition(this.);
//    this.setPosition(new PVector(diff.x, diff.y));

  // Something is seriously messed up with this code, PLEASE FIX ME:
  if(derp){
    t = new Timer(1);
    t.start();
    this.setPosition(new PVector((float)(planetPos.x -this.getPosition().x - width/2)*-1, (float)(planetPos.y -this.getPosition().y - height/2)*-1));
    derp = false;
   }
   if(t.isFinished())
   {
    derp = true; 
   }
   println(this.getPosition());

    //fill(255, 220, 40);
    //ellipse(this.getPosition().x/2+width/2, this.getPosition().y+height/2, 200, 200); // Sun. Should be an object
    //println(this.getChildren().size());
    //sf.action();
    //planet.setOrgin(this.getChild(0).getPosition()); // planet
    //planet.action();
    
    //PVector pp = planet.getPosition();

//    // Update Children. I forsee problems with methods, maybe solve by casting
//    for (int i = this.getChildren().size()-1; i > 0; i--) { 
//      HomingMissile m = (HomingMissile)this.getChildren().get(i);
//      m.action(new PVector(pp.x, pp.y));
//
//      if (dist(m.getPosition().x, m.getPosition().y, pp.x, pp.y) < planet.getRadius())
//      {
//        m.explode(); 
//       // planet.takeDamage();
//      }
//      if (m.isExpired())
//        this.getChildren().remove(i);
//    }
//
//    // Constantly spawn missiles around planet
//    for (int i = 0; i < 2; i++) {
//      HomingMissile h = new HomingMissile(new PVector(sun.getPosition().x +random(-100, 100), sun.getPosition().y+random(-100, 100)), 10, 10);
//      //mList.add(h);
//      this.addChild(h);
//    }
//
//    if (mousePressed) {
//      for (int i = 0; i < 5; i++) {
//        HomingMissile h = new HomingMissile(new PVector(mouseX +random(-100, 100), mouseY+random(-100, 100)), 10, 10, new PVector( 900, 900));
//        println(new PVector( this.getPosition().x + 200, this.getPosition().y+200));
//        //mList.add(h);
//        this.addChild(h);
//      }
//    }
  }
}
// The BFG goes on the planet...
// Consider inheriting from an abstract gun/turret class.
class BFG extends Entity
{
}

