class Vertex {
  float x;
  float y;
  PVector velocity;
  PVector net_force;
  boolean isDragged = false;

  int radius = 10;
  public Vertex(){
    velocity = new PVector(0.0, 0.0);
    net_force = new PVector(0.0, 0.0);
  }
  void draw() {
    ellipseMode(CENTER);
    fill(255,0,0);
    // println("x: "+x+" y: "+y);
    ellipse(x, y, radius, radius);
  }

  boolean hitTest(int mx, int my){
    if(mx > x-radius && mx < x+radius
      && my > y-radius && my < y+radius){
      return true;
    }
    return false;
  }
}
