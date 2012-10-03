
AppManager mgr;

void setup() {
  
  size(1000,1000);
  mgr = new AppManager();
  
}

void draw() {
  background(100);
  mgr.manage();
}


