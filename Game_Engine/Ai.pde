///////////////////////////////////////////////
// Different types of Ai defined here.
// All inherit from AI.
///////////////////////////////////////////////

class AI extends Entity
{
  
}

// These pirates form fleets, flock around target and shoot
// Boid logic
class BoidPirate extends AI
{
  
}

// Fly straight at their target and detonate when they reach it
// Straight homing missile logic, explode when dist < 1
class BombShip extends AI
{
  
}

// hang out at a distance and fire long range missiles/lasers
// Homing missile logic, stop at fixed dist and begin firing
class LongRangeFrigate extends AI
{
  
}
