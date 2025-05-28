import fisica.*;

// https://web.archive.org/web/20140802193416/http://wiki.processing.org/w/Fisica_/_JBox2D_physics_engine#FCircle
// https://mycours.es/fisica/
// https://github.com/rikrd/fisica/blob/master/src/fisica/FBody.java
// https://haphub.github.io/hAPI_Fisica/class_f_blob.html


// TODOS:
// MOVING PLATFORMS (CLASS)
// BUTTONS AND GATES
// BOXES
// MODE FRAMEWORK
// FOLLOWING CAMERA
// LEVEL SYSTEM
// PARRALAX BACKGROUND


// level colours
final color TRANSPARENT = color(0,0,0,0);
final color BLUE = #2f3699;
final color SPIKE_UP_COLOR = #ed1c24;
final color SPIKE_DOWN_COLOR = #ff7e00;

PImage spikeDownImg;
PImage spikeUpImg;

PImage level1Map;

// world
FWorld world;
int normalGravityStrength = 1000;
int fallingGravityStrength = 1300;
boolean isGravityFlipped = false;


// objects
FBox b;
FCircle circle;

// player
FBlob player;
int jumpStrength = 550;

PFont smileFont;
PFont surprisedFont;

// input
boolean aKeyDown, dKeyDown, spaceKeyDown;

float lastJumpTime = 0;
boolean isFacingRight = true;
boolean isGrounded;


void setup() {
  size(1800, 1000, P2D);
  
  smileFont = createFont("NotoSans-Regular", 64, true, "◕‿◕".toCharArray());
  surprisedFont = createFont("NotoSans-Regular", 64, true, "˃⤙˂".toCharArray());
  
  spikeDownImg = loadImage("spike_down.png");
  spikeUpImg = loadImage("spike_up.png");
  
  level1Map = loadImage("level1Map.png");
  
  Fisica.init(this);
  setupScene();

}

void setupScene() {
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
      
      if(c == TRANSPARENT) continue;
      
      FBody cell;
      if(c == SPIKE_UP_COLOR) {
        cell = new FSpike(gridSize, gridSize, spikeUpImg);
      }
      else if(c == SPIKE_DOWN_COLOR) {
        cell = new FSpike(gridSize, gridSize, spikeDownImg);
      }
      else {
        cell = new FBox(gridSize + 2, gridSize + 2);
        cell.setFill(red(c), green(c), blue(c));
      }
      cell.setStroke(0,0,0,0);
      cell.setStatic(true);
      cell.setPosition(x * gridSize + 12, y * gridSize + 12);
      world.add(cell);
    }
  }

  player = new FBlob();
  player.setAsCircle(200, 300, 80, 25);
  player.setStroke(0,0,0,0);
  player.setFill(159, 236, 191);
  player.setName("player");
  world.add(player);
}

void draw() {
  background(240);

  isGrounded = isGrounded();
  handlePlayerMovement();
  handleGravity();
  handlePlayerCollisions();

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
  for (int i = 0; i < player.getVertexBodies().size(); i++) {
    ((FBody)player.getVertexBodies().get(i)).adjustVelocity(changeAmt, 0);
  }
  
  if (spaceKeyDown) {
    if(millis() - lastJumpTime > 80 && isGrounded) {
      for (int i = 0; i < player.getVertexBodies().size(); i++) {
        ((FBody)player.getVertexBodies().get(i)).setVelocity(0, isGravityFlipped ? jumpStrength : -jumpStrength);
        lastJumpTime = millis();
      }
    }
  }
  
}
void handleGravity() {
  int targetGravity = normalGravityStrength;
  // if is falling
  if(isGravityFlipped ? getBlobAvgVelocity().y < 0 : getBlobAvgVelocity().y > 0) {
    targetGravity = fallingGravityStrength;
  } else {
    targetGravity = normalGravityStrength;
  }
  
  if(isGravityFlipped) targetGravity = -targetGravity;
  
  world.setGravity(0, targetGravity);
}
void handlePlayerCollisions() {
  ArrayList<FContact> contacts = getPlayerContacts();
  for(FContact contact : contacts) {
    if(contact.contains("spike")) {
      setupScene();
    }
  }
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
    for (Object vObj : player.getVertexBodies()) {
      FBody v = (FBody) vObj;
      if (v.getY() > lowestY) lowestY = v.getY();
    }
  
    for (Object vObj : player.getVertexBodies()) {
      FBody v = (FBody) vObj;
      if (abs(v.getY() - lowestY) > 12) continue; 
  
      for (Object cObj : v.getContacts()) {
        FContact c = (FContact) cObj;
        FBody other = (c.getBody1() == v) ? c.getBody2() : c.getBody1();
  
        if (other != null && player.getVertexBodies().contains(other)) continue;
  
        return true;
      }
    }
    return false;  
  }
  // gravity is flipped
  else {
    float highestY = 99999; 
    for (Object vObj : player.getVertexBodies()) {
      FBody v = (FBody) vObj;
      if (v.getY() < highestY) highestY = v.getY();
    }
  
    for (Object vObj : player.getVertexBodies()) {
      FBody v = (FBody) vObj;
      if (abs(v.getY() - highestY) > 12) continue; 
  
      for (Object cObj : v.getContacts()) {
        FContact c = (FContact) cObj;
        FBody other = (c.getBody1() == v) ? c.getBody2() : c.getBody1();
  
        if (other != null && player.getVertexBodies().contains(other)) continue;
  
        return true;
      }
    }
    return false;  
  }
}

ArrayList<FContact> getPlayerContacts() {
  ArrayList<FContact> contacts = new ArrayList<FContact>();
  ArrayList<FBody> verts = player.getVertexBodies();
  for (FBody v : verts) {
    ArrayList<FContact> vc = v.getContacts(); 
    for (FContact c : vc) {
      contacts.add(c);
    }
  }
  return contacts;
}

PVector getBlobAvgVelocity() {
  float xVelSum = 0;
  float yVelSum = 0;

  for (Object vertexObj : player.getVertexBodies()) {
    FBody vertex = (FBody) vertexObj;
    xVelSum += vertex.getVelocityX();
    yVelSum += vertex.getVelocityY();
  }
  return new PVector(xVelSum / player.getVertexBodies().size(), yVelSum / player.getVertexBodies().size());
}

PVector getBlobCenterPos() {
  float sumX = 0, sumY = 0;
  
  for (Object vertexObj : player.getVertexBodies()) {
    FBody vertex = (FBody) vertexObj;
    sumX += vertex.getX();
    sumY += vertex.getY();
  }
  return new PVector(sumX / player.getVertexBodies().size(), sumY / player.getVertexBodies().size());
}
