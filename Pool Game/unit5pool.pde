
Hole[] holes;


void setup() {
  size(800, 1000, P2D);
  
  holes = new Hole[6];
  holes[0] = new Hole(new PVector(width/2 + 250, height/2 - 350), 50);
  holes[1] = new Hole(new PVector(width/2 - 250, height/2 - 350), 50);
  holes[2] = new Hole(new PVector(width/2 + 250, height/2), 50);
  holes[3] = new Hole(new PVector(width/2 - 250, height/2), 50);
  holes[4] = new Hole(new PVector(width/2 + 250, height/2 + 350), 50);
  holes[5] = new Hole(new PVector(width/2 - 250, height/2 + 350), 50);
  
}

void draw() {
  background(#ffffff);
  
  // draw pool table
  stroke(#000000);
  strokeWeight(7);
  fill(110, 57, 43);
  rectMode(CENTER);
  rect(width/2, height/2, 600, 800, 30);

  strokeWeight(10);
  fill(0,196,99);
  rect(width/2, height/2, 500, 700, 30);
  
  for(Hole hole : holes) {
    hole.update();
  }
}
