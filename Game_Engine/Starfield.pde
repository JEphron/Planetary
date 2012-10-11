///////////////////////////////////////////////
// Star field object generates a random
// field of points in a given area and draws them
///////////////////////////////////////////////
class StarField extends Entity
{
  ArrayList stars;
  int nStars;
  StarField(int numStars)
  {
    stars = new ArrayList();
    nStars = numStars;
    pos = new PVector(0, 0);
  }

  void generateField()
  {
    for (int i = 0; i < nStars; i++) {
      PVector n = new PVector(random(width*2)-width/2, random(height*2)-height/2);
      stars.add(n);
      //  println("Bleh");
    }
  }

  void action()
  {
    this.display();
  }

  void display()
  {
    stroke(255);
    for (int i = stars.size()-1; i > 0; i--) { 
      PVector n =(PVector) stars.get(i);
      point(n.x, n.y);
    }
    stroke(0);
  }

  void setPosition(PVector p) {
    {
      for (int i = stars.size()-1; i > 0; i--) { 
        PVector n =(PVector) stars.get(i);
        stars.set(i, new PVector(n.x -(pos.x-p.x)/2, n.y + (p.y - pos.y)/2));
      }
    }
  }
}
