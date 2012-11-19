int n = 5;
int e = 7;

ArrayList<Vertex> vList;
boolean[][] edges;
boolean isSimulating = false;
void setup() {
  size(500, 500);
  background(255);
  // edges = new ArrayList<ArrayList<boolean>>();

  createObjects();
}

void createObjects(){
  edges = new boolean[n][n];
  for(int i = 0; i < n; i++){
    for(int j = 0; j < n; j++){
      edges[i][j] = false;
    }
  }

  int eTemp = e;
  while(eTemp > 0) // add some edges
  {
    int a = floor(random(n));
    int b = floor(random(n));
    if(a==b || edges[a][b])
      continue;
    edges[a][b] = true;
    edges[b][a] = true;
    eTemp--;

  }
  vList = new ArrayList<Vertex>();
  for(int i = 0; i < n; i++){
    Vertex v = new Vertex();
    v.x = floor(random(500));
    v.y = floor(random(500));
    vList.add(v);
  }
}
void draw() {
  background(255);
  if(isSimulating){
    boolean done = reflow();
    if(done)
      isSimulating = false;
  }
  for(int i = 0; i < n; i++){
    for(int j = 0; j < n; j++){
      if(!edges[i][j])
        continue;
      fill(0, 0, 0);
      line(vList.get(i).x, vList.get(i).y, vList.get(j).x, vList.get(j).y);
    }
    vList.get(i).draw();
  }
}

boolean reflow(){
  PVector totalEnergy = new PVector(0.0, 0.0);
  float dis = 0.0;
  for(int i = 0; i < n; i++){
    Vertex v = vList.get(i);
    // Vertex u;
    v.net_force.x = 0.0;
    v.net_force.y = 0.0;
    // v.velocity.x = v.velocity.y = 0.0;
    for (int j = 0; j<n; j++){
      if(i == j)
        continue;
      Vertex u = vList.get(j);

      // squared distance between "u" and "v" in 2D space
      float dsq = ((v.x-u.x)*(v.x-u.x)+(v.y-u.y)*(v.y-u.y));
      // println(dsq);
      // counting the repulsion between two vertices
      if(dsq == 0.0)
        dsq = 0.001f;
      float coul = 200 / dsq;
      v.net_force.x += coul * (v.x-u.x);
      v.net_force.y += coul * (v.y-u.y);
    }
    for(int j = 0; j < n; j++) // loop through edges
    {
      if(!edges[i][j])
        continue;
      Vertex u = vList.get(j);
       // countin the attraction
      v.net_force.x += 0.02*(u.x - v.x);
      v.net_force.y += 0.02*(u.y - v.y);
    }
  }
  // println("Total energy: " + totalEnergy.x + " " + totalEnergy.y);
  // println(dis);
  for(int i=0; i < n; i++) // set new positions
  {
    Vertex v = vList.get(i);
    if(v.isDragged)
    {
      v.x = mouseX;
      v.y = mouseY;
    }
    else
    {
      // counting the velocity (with damping 0.85)
      v.velocity.x = (v.velocity.x + v.net_force.x)*0.85;
      v.velocity.y = (v.velocity.y + v.net_force.y)*0.85;
      // println("fx: "+v.net_force.x+" fy:"+v.net_force.y);
      // println("vx: "+v.velocity.x+" vy:"+v.velocity.y);
      dis += abs(v.net_force.x) + abs(v.net_force.y);
      totalEnergy.x = totalEnergy.x + (v.velocity.x*v.velocity.x);
      totalEnergy.y = totalEnergy.y + (v.velocity.y*v.velocity.y);

      v.x += v.velocity.x;
      v.y += v.velocity.y;
      v.x = constrain(v.x, 0, 500);
      v.y = constrain(v.y, 0, 500);
      // println("posx: "+v.velocity.x+" posy: "+v.velocity.y);

    }
  }
  if(dis < e*0.5)
  // if(totalEnergy.x < 0.01 && totalEnergy.y < 0.01)
    return true;
    // return true;

  return false;
}

void mousePressed()
{
  for (Vertex v : vList){
    if(v.hitTest(mouseX, mouseY)){
      v.isDragged = true;
      isSimulating = true;
      break;
    }

  }
}
void mouseReleased(){
  for (Vertex v : vList){
    if(v.isDragged){
      v.isDragged = false;
      break;
    }
  }
}

void keyPressed(){
  if(key == 's'){
    for (Vertex v : vList){
      v.x = floor(random(500));
      v.y = floor(random(500));
    }
    isSimulating = true;
  }
  else if (key == 'n') {
    createObjects();
  }

}

class Vertex {
  int x;
  int y;
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
