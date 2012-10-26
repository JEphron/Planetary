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
float mX;
float mY;
void setup()
{
  //size(720, 400);
  size(900, 900);
  frame.setResizable(true);

  // frameRate(5);
  //size(360, 480);// 480/360 = 1.3333...
  eng = new Engine(AppStates.LoadCore, AppStates.Exit);
}

void draw()
{
  fill(255);
  background(30);
  eng.handle();
}

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
    Input.Left = true;
  if (keyCode == RIGHT)
    Input.Right = true;
  if (keyCode == UP)
    Input.Up = true;
  if (keyCode == DOWN)
    Input.Down = true;
}

// handle key releases
void keyReleased()
{
  if (keyCode == LEFT)
    Input.Left = false;
  if (keyCode == RIGHT)
    Input.Right = false;
  if (keyCode == UP)
    Input.Up = false;
  if (keyCode == DOWN)
    Input.Down = false;
}
// CONVENTIONS: • Comments at the top of files should summerize the contents of the file
//              • Class names should be capitalized, methods should be camelCase

