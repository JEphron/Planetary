/*
//All vectors (except dimensions) have their x value as forward motion, and their y value as upward motion 
void constants(){
  float gravity=6.673;
  
}
void newObject(float d, boolean isSphere,float xcoord, float ycoord, float r){
  float density=d;
  if(isSphere){
    float radius=r;
    float getRadius(){
     return radius; 
    }
  }else{
    PVector dimensions=(xcoord,ycoord);
    PVector getDimensions(){
     return dimensions;
    }
  }
  PVector velocity=(0,0); 
  PVector acceleration=(0,0); 
  PVector force=(0,0); 
  PVector gravity=(0,0);
  
  float getMass(){
   return mass;
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
    velocity+=a;
  }
  void changeAcceleration(PVector a){
    acceleration+=a;
  }
  void changeForce(PVector a){
    force+=a;
  }
  void changeGravity(PVector a){
    gravity+=a;
  }
}
void calcForces(int b){//b is the number of objects there are
  for(int a=0;a>b;a++){
    
  }  
}
void calcOrbit(int obj1,int obj2){
  //obj1 is orbited by obj2 
}
*/
