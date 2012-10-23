///////////////////////////////////////////////
//  This class is responsible for loading all the images and sounds and stuff and then 
//  distributing them to other classes that need them.
//  It is initialized in loadcore, where the resources
//  are loaded into memory. Fix this. 
///////////////////////////////////////////////

class ResourceManager
{
  // PImage platform1, platform2, platform3;

  ResourceManager()
  {
  }

  void action()
  {
  }

  void loadResources()
  {
    // try and load the resources
    for (Resource rs : Resource.values()) {
      loadImg(rs);
    }
  }

  PImage loadImg(Resource r)
  {
    return null;// fix this
  }
}
//  Missile, // genericize as AI. All ai should behave in a similar way
//  Sun,
//  Platform,
//  Planet,
//  Starfield

