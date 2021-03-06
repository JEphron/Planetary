/*************
 
 Hierarchy:
 ---------
 Setup - Creates engine
 Engine - Manages states and transitions
 State - Manages scene transitions and actions Ex. MenuState, GameState
 Scene - Draws and manages Entities Ex. Scene: level 1, Options Menu, handles higher level logic.
 Entity - Does individual logic and animation Ex: Enemy, Player, Pickup
 
 **************/

Engine eng;
void setup()
{
  //size(720, 400);
  size(900, 900);
  frame.setResizable(true);

  // frameRate(5);
  //size(360, 480);// 480/360 = 1.3333...
  eng = new Engine(0, 4);
}

void draw()
{
  fill(255);
  background(30);
  eng.handle();
}

// CONVENTIONS: • Comments at the top of files should summerize the contents of the file
//              • Class names should be capitalized, methods should be camelCase

