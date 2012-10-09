//All vectors (except dimensions) have their x value as forward motion, and their y value as upward motion 
public float GRAVITYCONSTANT=6.673;

class newObject extends Entity{
  boolean isSphere;
  float density;  
  float radius;
  PVector dimensions=new PVector(0,0);
  PVector velocity=new PVector(0,0); 
  PVector acceleration=new PVector(0,0); 
  PVector force=new PVector(0,0); 
  PVector gravity=new PVector(0,0);
  
  float getRadius(){
     return radius; 
  }
  PVector getDimensions(){
    return dimensions;
  }
  float getMass(){
   if(isSphere){
     return density/(PI*radius*radius);
   }else{
    return density/(dimensions.x*dimensions.y); 
   }
  }
  PVector getVelocity(){
   return velocity;
  }
  PVector getAcceleration(){
   return acceleration;
  }
  PVector getForce(){
   return force;
  }
  PVector getGravity(){
   return gravity;
  }
  
  
  void changeVelocity(PVector a){
    velocity.add(a);
  }
  void changeAcceleration(PVector a){
    acceleration.add(a);
  }
  void changeForce(PVector a){
    force.add(a);
  }
  void changeGravity(PVector a){
    gravity.add(a);
  }
  void calcForces(int b){//b is the number of objects there are
  for(int a=0;a>b;a++){
    
    }  
  }
  void calcOrbit(int obj1,int obj2){
  //obj1 is orbited by obj2 
  }
}
