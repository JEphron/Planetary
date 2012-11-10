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

