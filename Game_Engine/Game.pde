///////////////////////////////////////////////
// This is the game state. It is the state where all of 
// the game logic, drawing, and interaction take place. 
// 
///////////////////////////////////////////////

// TODO: • Stuff
//       • More stuff
//       • Stop being lazy with comments
//       • Implement targeting algorithm

class Game extends IAppStates
{
  StarField sf = new StarField(300);
  Planetary planet = new Planetary(50, color(100, 200, 170), 250, new PVector(width/2, height/2), 1);
  ArrayList mList = new ArrayList();

  Game()
  {
    nextAppStates = AppStates.Game;
    println("Entering main game...");
    sf.generateField();
  }


  void action()
  {
    // Do game stuff

    //fill(32, 64, 128);
    fill(0);
    rect(0, 0, width, height);

    fill(255, 220, 40);
    ellipse(width/2, height/2, 200, 200); // Sun. Should be an object

    sf.action();
    planet.action(); // planet
    println(frameRate);

    PVector pp = planet.getPosition();

    for (int i = mList.size()-1; i > 0; i--) { 
      HomingMissile m = (HomingMissile)mList.get(i);
      m.action(new PVector(pp.x, pp.y));

      if (dist(m.getPosition().x, m.getPosition().y, pp.x, pp.y) < planet.getRadius())
      {
        m.explode(); 
        // planet.takeDamage();
      }
      if (m.isExpired())
        mList.remove(i);
    }

    // Constantly spawn missiles around planet
    for (int i = 0; i < 5; i++) {
     HomingMissile h = new HomingMissile(new PVector(planet.getPosition().x +random(-100,100), planet.getPosition().y+random(-100,100)), 10,10);
     mList.add(h);
     }

    if (mousePressed) {
      for (int i = 0; i < 5; i++) {
        HomingMissile h = new HomingMissile(new PVector(mouseX +random(-100, 100), mouseY+random(-100, 100)), 10, 10);
        mList.add(h);
      }
    }
    // Call this to signal that the game should end\
    //setNextState(AppStates.Exit);
  }
}

// The BFG goes on the planet...
class BFG extends Entity
{
}

