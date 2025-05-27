import fisica.*;

// https://web.archive.org/web/20140802193416/http://wiki.processing.org/w/Fisica_/_JBox2D_physics_engine#FCircle
// https://mycours.es/fisica/
// https://github.com/rikrd/fisica/blob/master/src/fisica/FBody.java
// https://haphub.github.io/hAPI_Fisica/class_f_blob.html


// TODOS:
// MOVING PLATFORMS (CLASS)
// SPIKES (CLASS)
// BUTTONS AND GATES
// BOXES
// MODE FRAMEWORK
// FOLLOWING CAMERA
// LEVEL SYSTEM


// level colours
final color TRANSPARENT = color(0,0,0,0);
final color BLUE = #2f3699;

PImage level1Map;

// world
FWorld world;
int normalGravityStrength = 1000;
int fallingGravityStrength = 1300;
boolean isGravityFlipped = false;;

// objects
FBox b;
FCircle circle;

// player
FBlob blob;
int jumpStrength = 550;

PFont smileFont;
PFont surprisedFont;

// input
boolean aKeyDown, dKeyDown, spaceKeyDown;

float lastJumpTime = 0;s
boolean isFacingRight = true;
boolean isGrounded;


void setup() {
  size(1800, 1000, P2D);
  
  level1Map = loadImage("level1Map.png");

  Fisica.init(this);
  world = new FWorld();

  world.setEdges();
  world.setGrabbable(false);
  world.setGravity(0, normalGravityStrength);
  world.setEdgesFriction(0);
  
  rectMode(CORNER);
  int gridSize = 51;
  for(int x = 0; x < level1Map.width; x++) {
    for(int y = 0; y < level1Map.height; y++) {
      color c = level1Map.get(x, y);
      if(c != TRANSPARENT) {
        FBox cell = new FBox(gridSize + 2, gridSize + 2);
        cell.setFill(red(c), green(c), blue(c));
        cell.setStroke(0,0,0,0);
        cell.setStatic(true);
        cell.setPosition(x * gridSize, y * gridSize);
        world.add(cell);
        
      }
    }
  }

  b = new FBox(80, 80);
  b.setPosition(1400, 950);
  b.setFriction(1000);
  b.setStatic(true);
  world.add(b);

  circle = new FCircle(80);
  circle.setPosition(width/2, height/2);
  circle.setFriction(1000);
  world.add(circle);

  blob = new FBlob();
  blob.setAsCircle(200, 300, 80, 25);
  blob.setStroke(0,0,0,0);
  blob.setFill(159, 236, 191);
  world.add(blob);
  
  smileFont = createFont("NotoSans-Regular", 64, true, "◕‿◕".toCharArray());
  surprisedFont = createFont("NotoSans-Regular", 64, true, "˃⤙˂".toCharArray());

}

void draw() {
  background(240);

  isGrounded = isGrounded();
  handlePlayerMovement();
  handleGravity();

  world.step();
  world.draw();
  drawPlayerFace();
  
  //world.drawDebug();
  //world.drawDebugData();
}


void handlePlayerMovement() {
  float targetVelocity = 0;

  if (aKeyDown && !dKeyDown) {
    targetVelocity = -330;
    isFacingRight = false;
  }
  if (dKeyDown && !aKeyDown) {
    targetVelocity = 330;
    isFacingRight = true;
  }
  if (!aKeyDown && !dKeyDown) {
    targetVelocity = 0;
  }

  float avgXVel = getBlobAvgVelocity().x;
  //println("avg x vel: " + avgXVel);
  float changeAmt = (targetVelocity - avgXVel) * 0.15;
  //println("change amt " + changeAmt);
  for (int i = 0; i < blob.getVertexBodies().size(); i++) {
    ((FBody)blob.getVertexBodies().get(i)).adjustVelocity(changeAmt, 0);
  }
  
  if (spaceKeyDown) {
    if(millis() - lastJumpTime > 80 && isGrounded) {
      for (int i = 0; i < blob.getVertexBodies().size(); i++) {
        ((FBody)blob.getVertexBodies().get(i)).setVelocity(0, isGravityFlipped ? jumpStrength : -jumpStrength);
        lastJumpTime = millis();
      }
    }
  }
  
}
void handleGravity() {
  int targetGravity = normalGravityStrength;
  if(getBlobAvgVelocity().y > 0) {
    targetGravity = fallingGravityStrength;
  } else {
    targetGravity = normalGravityStrength;
  }
  
  if(isGravityFlipped) targetGravity = -targetGravity;
  
  world.setGravity(0, targetGravity);
}

void drawPlayerFace() {
  pushMatrix();
  translate(getBlobCenterPos().x + (isFacingRight ? 4 : -4), getBlobCenterPos().y + (isGravityFlipped ? -6 : 6));
  scale(isFacingRight ? -0.5 : 0.5, isGravityFlipped ? -0.5 : 0.5);
  
  textFont(isGrounded ? smileFont : surprisedFont);
  textAlign(CENTER);
  fill(0);
  text(isGrounded ? "◕‿◕" : "˃⤙˂", 0, 0);
  
  popMatrix();
}


void keyPressed() {
  if (key == 'a') aKeyDown = true;
  if (key == 'd') dKeyDown = true;
  if (key == ' ') spaceKeyDown = true;
  
  if(key == 'g') {
    isGravityFlipped = !isGravityFlipped;
  }
}
void keyReleased() {
  if (key == 'a') aKeyDown = false;
  if (key == 'd') dKeyDown = false;
  if (key == ' ') spaceKeyDown = false;
}


boolean isGrounded() {
  if(!isGravityFlipped) {
    float lowestY = -99999; 
    for (Object vObj : blob.getVertexBodies()) {
      FBody v = (FBody) vObj;
      if (v.getY() > lowestY) lowestY = v.getY();
    }
  
    for (Object vObj : blob.getVertexBodies()) {
      FBody v = (FBody) vObj;
      if (abs(v.getY() - lowestY) > 12) continue; 
  
      for (Object cObj : v.getContacts()) {
        FContact c = (FContact) cObj;
        FBody other = (c.getBody1() == v) ? c.getBody2() : c.getBody1();
  
        if (other != null && blob.getVertexBodies().contains(other)) continue;
  
        return true;
      }
    }
    return false;  
  }
  // gravity is flipped
  else {
    float highestY = 99999; 
    for (Object vObj : blob.getVertexBodies()) {
      FBody v = (FBody) vObj;
      if (v.getY() < highestY) highestY = v.getY();
    }
  
    for (Object vObj : blob.getVertexBodies()) {
      FBody v = (FBody) vObj;
      if (abs(v.getY() - highestY) > 12) continue; 
  
      for (Object cObj : v.getContacts()) {
        FContact c = (FContact) cObj;
        FBody other = (c.getBody1() == v) ? c.getBody2() : c.getBody1();
  
        if (other != null && blob.getVertexBodies().contains(other)) continue;
  
        return true;
      }
    }
    return false;  
  }
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

PVector getBlobCenterPos() {
  float sumX = 0, sumY = 0;
  
  for (Object vertexObj : blob.getVertexBodies()) {
    FBody vertex = (FBody) vertexObj;
    sumX += vertex.getX();
    sumY += vertex.getY();
  }
  return new PVector(sumX / blob.getVertexBodies().size(), sumY / blob.getVertexBodies().size());
}
