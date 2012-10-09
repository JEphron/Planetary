//All vectors (except dimensions) have their x value as forward motion, and their y value as upward motion 
public float GRAVITYCONSTANT=6.673;

class newObject extends Entity{
  boolean isSphere;
  float density;  
  float radius;
  PVector position=new PVector(0,0);
  PVector dimensions=new PVector(0,0);
  PVector centerofGravity=new PVector(0,0);
  PVector netVelocity=new PVector(0,0); 
  PVector exertedVelocity=new PVector(0,0); 
  PVector netAcceleration=new PVector(0,0);
  PVector exertedAcceleration=new PVector(0,0);
  PVector netForce=new PVector(0,0); 
  PVector exertedForce=new PVector(0,0); 
  PVector netGravity=new PVector(0,0);
  PVector exertedGravity=new PVector(0,0);
  PVector collisionForce=new PVector(0,0);
  
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
  PVector getNetVelocity(){
    return netVelocity;
  }
  PVector getExertedVelocity(){
    return exertedVelocity;
  }
  PVector getNetAcceleration(){
   return netAcceleration;
  }
  PVector getExertedAcceleration(){
    return exertedAcceleration;
  }
  PVector getNetForce(){
   return netForce;
  }
  PVector getExertedForce(){
   return exertedForce;
  }
  PVector getNetGravity(){
   return netGravity;
  }
  PVector getExertedGravity(){
   return exertedGravity;
  }
  
  /*void changeVelocity(PVector a){
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
  }*/
  void calcGravity(){}
  void calcForce(int b){//b is the number of objects there are
  for(int a=0;a>b;a++){
      //gravity+exertedforce+collision+
    }
  }
  void calcAcceleration(){
    
  }
  void calcVelocity(){
    
  }
  
  
  
  
}
