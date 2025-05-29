import fisica.*;

// https://web.archive.org/web/20140802193416/http://wiki.processing.org/w/Fisica_/_JBox2D_physics_engine#FCircle
// https://mycours.es/fisica/
// https://github.com/rikrd/fisica/blob/master/src/fisica/FBody.java
// https://haphub.github.io/hAPI_Fisica/class_f_blob.html


// TODOS:
// LIMIT GRAVITY FLIPS
// MODE FRAMEWORK
// LEVEL SYSTEM
// FOLLOWING CAMERA
// BUTTONS AND GATES
// BOXES
// MOVING PLATFORMS (CLASS)


// level colours
color TRANSPARENT = color(0,0,0,0);
color SPIKE_UP = #ed1c24;
color SPIKE_DOWN = #ff7e00;
color TOP_LEFT = #048200;
color LEFT_EDGE = #7dbf7a;
color TOP_EDGE = #00ff11;
color TOP_RIGHT = #fbff00;
color RIGHT_EDGE = #00e0f0;
color MIDDLE = #6b4200;
color BOTTOM_EDGE = #0062ff;
color BOTTOM_LEFT = #d400ff;
color BOTTOM_RIGHT = #ffa826;
color STAR_COLOR = #6200ff;

// tile images
PImage TOP_LEFT_TILE;
PImage LEFT_EDGE_TILE;
PImage TOP_EDGE_TILE;
PImage TOP_RIGHT_TILE;
PImage RIGHT_EDGE_TILE;
PImage MIDDLE_TILE;
PImage BOTTOM_EDGE_TILE;
PImage BOTTOM_LEFT_TILE;
PImage BOTTOM_RIGHT_TILE;

PImage spikeDownImg;
PImage spikeUpImg;
PImage[] starImgs;

PImage backgroundImg;

PImage level1Map;

// world
FWorld world;
FBody[][] tiles;
int normalGravityStrength = 1000;
int fallingGravityStrength = 1300;
boolean isGravityFlipped = false;
int gridSize = 50;

FStar star;
int starSize = 120;

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
  noSmooth();
  
  smileFont = createFont("NotoSans-Regular", 64, true, "◕‿◕".toCharArray());
  surprisedFont = createFont("NotoSans-Regular", 64, true, "˃⤙˂".toCharArray());
  
  backgroundImg = loadImage("background.png");
  
  TOP_LEFT_TILE = scaleImage(loadImage("tile1.png"), gridSize, gridSize);
  LEFT_EDGE_TILE = scaleImage(loadImage("tile8.png"), gridSize, gridSize);
  TOP_EDGE_TILE = scaleImage(loadImage("tile2.png"), gridSize, gridSize);
  TOP_RIGHT_TILE = scaleImage(loadImage("tile3.png"), gridSize, gridSize);
  RIGHT_EDGE_TILE = scaleImage(loadImage("tile10.png"), gridSize, gridSize);
  MIDDLE_TILE = scaleImage(loadImage("tile9.png"), gridSize, gridSize);
  BOTTOM_EDGE_TILE = scaleImage(loadImage("tile17.png"), gridSize, gridSize);
  BOTTOM_LEFT_TILE = scaleImage(loadImage("tile16.png"), gridSize, gridSize);
  BOTTOM_RIGHT_TILE = scaleImage(loadImage("tile18.png"), gridSize, gridSize);
  
  spikeDownImg = scaleImage(loadImage("spike_down.png"), gridSize, gridSize);
  spikeUpImg = scaleImage(loadImage("spike_up.png"), gridSize, gridSize);
  
  starImgs = new PImage[13];
  for(int i = 0; i < starImgs.length; i++) {
    starImgs[i] = loadImage("star" + (i+1) + ".png");
    starImgs[i] = scaleImage(starImgs[i], starSize, starSize);
  }
  
  level1Map = loadImage("level1Map.png");
  
  Fisica.init(this);
  setupScene();

}

void setupScene() {
  isGravityFlipped = false;
  
  world = new FWorld();
  world.setGravity(0, normalGravityStrength);
  world.setGrabbable(false);

  tiles = new FBody[level1Map.width][level1Map.height];

  for (int x = 0; x < level1Map.width; x++) {
    for (int y = 0; y < level1Map.height; y++) {
      color c = level1Map.get(x, y);
      if (c == TRANSPARENT) continue;

      FBody cell;

      if      (c == SPIKE_UP)        cell = new FSpike(gridSize, gridSize, spikeUpImg);
      else if (c == SPIKE_DOWN)      cell = new FSpike(gridSize, gridSize, spikeDownImg);
      else if (c == STAR_COLOR)      { star = new FStar(gridSize, gridSize, starImgs); cell = star; }
      else if (c == TOP_LEFT)        cell = makeTile(TOP_LEFT_TILE);
      else if (c == LEFT_EDGE)       cell = makeTile(LEFT_EDGE_TILE);
      else if (c == TOP_EDGE)        cell = makeTile(TOP_EDGE_TILE);
      else if (c == TOP_RIGHT)       cell = makeTile(TOP_RIGHT_TILE);
      else if (c == RIGHT_EDGE)      cell = makeTile(RIGHT_EDGE_TILE);
      else if (c == MIDDLE)          cell = makeTile(MIDDLE_TILE);
      else if (c == BOTTOM_EDGE)     cell = makeTile(BOTTOM_EDGE_TILE);
      else if (c == BOTTOM_LEFT)     cell = makeTile(BOTTOM_LEFT_TILE);
      else if (c == BOTTOM_RIGHT)    cell = makeTile(BOTTOM_RIGHT_TILE);
      else                           cell = new FBox(gridSize, gridSize);

      cell.setStroke(0, 0, 0, 0);
      cell.setStatic(true);   
      cell.setPosition(x * gridSize + gridSize/2, y * gridSize + gridSize/2);
      world.add(cell);

      tiles[x][y] = cell;
    }
  }

  player = new FBlob();
  player.setAsCircle(200, 300, 80, 25);
  player.setStroke(0, 0, 0, 0);
  player.setFill(159, 236, 191);
  player.setName("player");
  world.add(player);
}
FBox makeTile(PImage img) {
  FBox t = new FBox(gridSize, gridSize);
  t.attachImage(img);
  return t;
}


void draw() {
  background(backgroundImg);

  isGrounded = isGrounded();
  handlePlayerMovement();
  handleGravity();
  handlePlayerCollisions();
  updateObjects();

  world.step();
  alignTiles();
  world.draw();
  drawPlayerFace();
  
  //world.drawDebug();
  //world.drawDebugData();
}

void updateObjects() {
  star.update();
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
      break;
    }
    else if(contact.contains("star")) {
      setupScene();
      break;
    }
  }
}
void alignTiles() {
  for (int x = 0; x < tiles.length; x++) {
    for (int y = 0; y < tiles[0].length; y++) {
      FBody cell = tiles[x][y];
      if (cell != null) {
        cell.setPosition(x * gridSize + gridSize/2, y * gridSize + gridSize/2);
      }
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

PImage scaleImage(PImage src, int w, int h) {
  PImage out = createImage(w, h, ARGB);
  out.loadPixels();
  src.loadPixels();

  for (int y = 0; y < h; y++) {
    int sy = int(y * src.height / (float) h); 
    for (int x = 0; x < w; x++) {
      int sx = int(x * src.width / (float) w);
      out.pixels[y * w + x] = src.pixels[sy * src.width + sx];
    }
  }
  out.updatePixels();
  return out;
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
