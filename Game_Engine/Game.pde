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
  Planetary planet = new Planetary(50, color(100,200,170), 150, new PVector(width/2, height/2), 1);
  Game()
  {
    nextAppStates = AppStates.Game;
    println("Entering main game...");
    sf.generateField();
  }
  void action()
  {
    // Do game stuff
    // ...
    
     fill(32,64,128);
    //fill(0);
    rect(0 ,0,width,height);
    
    fill(255, 220, 40);
    ellipse(width/2, height/2, 200, 200); // Sun. Should be an object
    
    sf.action();
    planet.action(); // planet
    println(frameRate);
    // Call this to signal that the game should end\
    //setNextState(AppStates.Exit);
  }
  //GameScene createNewScene(mmScenes scene)
}

// The BFG goes on the planet...
class BFG extends Entity
{
  
}

/* * *
 * Yeah, we know what this does.
 */
class StarField extends Entity
{
  ArrayList stars;
  int nStars;
  StarField(int numStars)
  {
    stars = new ArrayList();
    nStars = numStars;
  }

  void generateField()
  {
    for (int i = 0; i < nStars; i++) {
      PVector n = new PVector(random(width), random(height));
      stars.add(n);
      println("Bleh");
    }
   
  }

  void action()
  {
    this.display();
  }

  void display()
  {
    stroke(255);
    for (int i = stars.size()-1; i > 0; i--) { 
      PVector n =(PVector) stars.get(i);
      point(n.x, n.y);
    }
    stroke(0);
  }
}

