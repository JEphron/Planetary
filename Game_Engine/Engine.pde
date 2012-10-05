///////////////////////////////////////////////
//  This is the main Engine class. It should  
//  be crearted at the start of the program
//  It is resposible for managing, updating,
//  and switching states. 
///////////////////////////////////////////////

// TODO: • Stack based state switching.
//       • State level transitions. 

// Create with starting state and ending state: equiv to Handler
class Engine
{
  AppStates nextState;
  AppStates exitState;
  IAppStates appState;

  // Construct with a starting state and an ending state
  Engine(AppStates startState, AppStates endState) 
  {
    exitState = endState;
    nextState = startState;
    // start out with the initial start state.
    appState = createAppStates(nextState);

    handle();
  }

  void handle()
  {
    //////////////////
    // Create the state, 
    // run each tick and update scene
    // if expired, delete and create new scene

      // check if appState has been created and create it if it hasn't
    if (appState==null)
      appState = createAppStates(nextState);

    appState.action();

    // check to see if the state has declared a next state.
    // if it has, delete the current state and create a new one.
    if (appState.getNextState() != nextState)
    {
      nextState = appState.getNextState();

      appState = createAppStates(nextState);
    }
  }

  // Call this each frame, or don't. 
  void update()
  {
  }

  // Creates the new state.
  IAppStates createAppStates(AppStates state)
  {
    switch(state) {
    case LoadCore:
      return new LoadCore();

    case Menu:
      return new Menu();

    case Game:
      return new Game();

    case Exit:
      println("Done with app, exiting");
      exit();
      break;

    default:
      println("ERROR: Problem creating new app state, does it have a corrosponding switch case?");
      break;
    }
    return null;
  }
}

abstract class IAppStates
{
  // Holds the next app state
  AppStates nextAppStates;
  IAppStates()
  {
  }
  // Set the next state
  void setNextState(AppStates next) { 
    nextAppStates = next;
  }

  AppStates getNextState() {
    return nextAppStates;
  }

  // Do whatever the state does, state class should overwrite
  void action() {
  }
}

