int n = 5;
int e = 7;

ArrayList<Vertex> vList;
boolean[][] edges;
boolean isSimulating = false;
void setup() {
  size(500, 500);
  background(255);

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

    v.net_force.x = 0.0;
    v.net_force.y = 0.0;

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
       // counting the attraction
      v.net_force.x += 0.02*(u.x - v.x);
      v.net_force.y += 0.02*(u.y - v.y);
    }
  }
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
      // dis += abs(v.net_force.x) + abs(v.net_force.y);
      totalEnergy.x = totalEnergy.x + (v.velocity.x*v.velocity.x);
      totalEnergy.y = totalEnergy.y + (v.velocity.y*v.velocity.y);

      v.x += v.velocity.x;
      v.y += v.velocity.y;
      v.x = constrain(v.x, 0, 500);
      v.y = constrain(v.y, 0, 500);
    }
  }
  float lenTotalEnergy = sqrt(totalEnergy.x * totalEnergy.x
                              + totalEnergy.y * totalEnergy.y);
  if(lenTotalEnergy < 0.01)
    return true;

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
