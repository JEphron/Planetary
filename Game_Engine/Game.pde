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
  
class Game extends IAppStates
{
  GameScene currentScene;
  Game()
  {
    nextAppStates = AppStates.Game;
    println("Entering main game...");
    currentScene = new MainGame();
  }


  void action()
  {
    currentScene.action();
    // Call this to signal that the game should end\
    //setNextState(AppStates.Exit);
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
    // Where is the screen centered?
  }
}

class MainGame extends GameScene
{
  
  StarField sf = new StarField(300);
  Planetary planet = new Planetary(50, color(100, 200, 170), 250, new PVector(width/2, height/2), 1);
  ArrayList mList = new ArrayList();

  MainGame()
  {
    sf.generateField();
  }
  void action()
  {
    println(frameRate);

    fill(0);
    rect(0, 0, width, height);

    fill(255, 220, 40);
    ellipse(width/2, height/2, 200, 200); // Sun. Should be an object

    sf.action();

    planet.action(); // planet

    PVector pp = planet.getPosition();

    // Update Children. I forsee problems with methods, maybe solve by casting
    for (int i = this.getChildren().size()-1; i > 0; i--) { 
      HomingMissile m = (HomingMissile)this.getChildren().get(i);
      m.action(new PVector(pp.x, pp.y));

      if (dist(m.getPosition().x, m.getPosition().y, pp.x, pp.y) < planet.getRadius())
      {
        m.explode(); 
        // planet.takeDamage();
      }
      if (m.isExpired())
        this.getChildren().remove(i);
    }

    // Constantly spawn missiles around planet
    for (int i = 0; i < 5; i++) {
      HomingMissile h = new HomingMissile(new PVector(planet.getPosition().x +random(-100, 100), planet.getPosition().y+random(-100, 100)), 10, 10);
      //mList.add(h);
      this.addChild(h);
    }

    if (mousePressed) {
      for (int i = 0; i < 5; i++) {
        HomingMissile h = new HomingMissile(new PVector(mouseX +random(-100, 100), mouseY+random(-100, 100)), 10, 10);
        //mList.add(h);
        this.addChild(h);
      }
    }
    
  }
}
// The BFG goes on the planet...
// Consider inheriting from an abstract gun/turret class.
class BFG extends Entity
{
}

