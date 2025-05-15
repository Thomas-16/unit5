import fisica.*;


// https://web.archive.org/web/20140802193416/http://wiki.processing.org/w/Fisica_/_JBox2D_physics_engine#FCircle
// https://mycours.es/fisica/
// https://github.com/rikrd/fisica/blob/master/src/fisica/FBody.java
// https://haphub.github.io/hAPI_Fisica/class_f_blob.html

FWorld world;

// objects
FBox b;
FCircle circle;

FBlob blob;

// input
boolean aKeyDown, dKeyDown, spaceKeyDown;

void setup() {
  size(1200, 800, P2D);

  Fisica.init(this);
  world = new FWorld();

  world.setEdges();
  world.setGrabbable(false);
  world.setGravity(0, 800);
  world.setEdgesFriction(0);


  b = new FBox(80, 80);
  b.setRotation(PI/5);
  b.setPosition(width/2, 100);
  world.add(b);

  circle = new FCircle(80);
  circle.setPosition(width/2, height/2);
  world.add(circle);

  blob = new FBlob();
  blob.setAsCircle(200, 300, 80, 20);
  world.add(blob);

  blob.setFriction(0);
}

void draw() {
  background(240);

  handlePlayerMovement();

  world.step();
  world.draw();
  //world.drawDebug();
  //world.drawDebugData();
}


void handlePlayerMovement() {
  float targetVelocity = 0;

  if (aKeyDown && !dKeyDown) {
    targetVelocity = -330;
  }
  if (dKeyDown && !aKeyDown) {
    targetVelocity = 330;
  }
  if (!aKeyDown && !dKeyDown) {
    targetVelocity = 0;
  }

  float avgXVel = getBlobAvgVelocity().x;
  println("avg x vel: " + avgXVel);
  float changeAmt = (targetVelocity - avgXVel) * 0.15;
  println("change amt " + changeAmt);
  for (int i = 0; i < blob.getVertexBodies().size(); i++) {
    ((FBody)blob.getVertexBodies().get(i)).adjustVelocity(changeAmt, 0);
  }
  
  if(spaceKeyDown) {
    for (Object vertexObj : blob.getVertexBodies()) {
      FBody vertex = (FBody) vertexObj;
      vertex.addForce(blob.getX(), blob.getY(), blob.getX() - vertex.getX(), blob.getY() - vertex.getY());
    }
  }
  
}


void keyPressed() {
  if (key == 'a') aKeyDown = true;
  if (key == 'd') dKeyDown = true;
  if (key == ' ') spaceKeyDown = true;
}
void keyReleased() {
  if (key == 'a') aKeyDown = false;
  if (key == 'd') dKeyDown = false;
  if (key == ' ') spaceKeyDown = false;
}

PVector getBlobAvgVelocity() {
  float xVelSum = 0;
  float yVelSum = 0;

  for (Object vertexObj : blob.getVertexBodies()) {
    FBody vertex = (FBody) vertexObj;
    xVelSum += vertex.getVelocityX();
    yVelSum += vertex.getVelocityY();
  }
  return new PVector(xVelSum / blob.getVertexBodies().size(), yVelSum / blob.getVertexBodies().size());
}
