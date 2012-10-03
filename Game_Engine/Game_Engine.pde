/*************

Hierarchy:
---------
Setup - Creates engine
Engine - Manages states and transitions
State - Manages scene transitions and actions Ex. MenuState, GameState
Scene - Draws and manages elements Ex. Scene: level 1, Options Menu, handles higher level logic.
Element - Does individual logic and animation Ex: Enemy, Player, Pickup

**************/

Engine eng;
void setup()
{
  size(720, 400);
  //size(360, 480);// 480/360 = 1.3333...

  eng = new Engine(AppStates.LoadCore, AppStates.Exit);
}

void draw()
{
  fill(255);
  background(30);
  eng.handle();
}

