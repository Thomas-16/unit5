
// level colors
color TRANSPARENT = color(0,0,0,0);
color PLAYER_COLOR = #000000;
color SPIKE_UP = #ed1c24;
color SPIKE_DOWN = #ff7e00;
color STAR_COLOR = #6200ff;

color TOP_LEFT = #048200;
color LEFT_EDGE = #7dbf7a;
color TOP_EDGE = #00ff11;
color TOP_RIGHT = #fbff00;
color RIGHT_EDGE = #00e0f0;
color MIDDLE = #6b4200;
color BOTTOM_EDGE = #0062ff;
color BOTTOM_LEFT = #d400ff;
color BOTTOM_RIGHT = #ffa826;


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
PImage platformImg;

PImage backgroundImg;

PImage[] mapImgsArr;

PFont font;

// world
int level;
FWorld world;
FBody[][] tiles;
int normalGravityStrength = 1000;
int fallingGravityStrength = 1300;
boolean isGravityFlipped = false;
int gridSize = 50;
PVector playerSpawnPos;
int flipsLeft;
ArrayList<FPlatform> platforms;
int deaths;

FStar star;
int starSize = 120;

FPlayer player;

PFont smileFont;
PFont surprisedFont;

// input
boolean aKeyDown, dKeyDown, spaceKeyDown;

float lastJumpTime = 0;
boolean isFacingRight;
boolean isGrounded;

void gameSceneSetup() {
  font = createFont("ByteBounce.ttf", 64);
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
  platformImg = scaleImage(loadImage("platform.png"), gridSize * 3, gridSize);
  
  starImgs = new PImage[13];
  for(int i = 0; i < starImgs.length; i++) {
    starImgs[i] = loadImage("star" + (i+1) + ".png");
    starImgs[i] = scaleImage(starImgs[i], starSize, starSize);
  }
  
  level = 0;
  deaths = 0;
  
  Fisica.init(this);
  setupScene();
}
void setupScene() {
  isGravityFlipped = false;
  isFacingRight = true;
  
  if(level == 0) {
    flipsLeft = 0;
  } else if(level == 1) {
    flipsLeft = 2;
  } else if(level == 2) {
    flipsLeft = 1;
  } else if(level == 3) {
    flipsLeft = 4;
  } else if(level == 4) {
    flipsLeft = 4;
  }
  
  world = new FWorld();
  world.setGravity(0, normalGravityStrength);
  world.setGrabbable(false);
  world.setEdges(color(0,0,0,0));
  
  PImage mapImg = mapImgsArr[level];
  tiles = new FBody[mapImg.width][mapImg.height];

  for (int x = 0; x < mapImg.width; x++) {
    for (int y = 0; y < mapImg.height; y++) {
      color c = mapImg.get(x, y);
      
      if (c == PLAYER_COLOR){
        playerSpawnPos = new PVector(x * gridSize + gridSize/2, y * gridSize + gridSize/2);
        continue;
      }
      
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
  
  // platforms
  platforms = new ArrayList<FPlatform>();
  if(level == 0) {
    platforms.add(new FPlatform(new PVector(27*50 + 25, 16*50 + 25), new PVector(27*50 + 25, 16*50 + 25), new PVector(11*50 + 25, 16*50 + 25), 150, 50, 3, 1000));
  } else if(level == 2) {
    platforms.add(new FPlatform(new PVector(19*50 + 25, 15*50 + 25), new PVector(19*50 + 25, 15*50 + 25), new PVector(7*50 + 25, 15*50 + 25), 150, 50, 3, 1000));
    platforms.add(new FPlatform(new PVector(23*50 + 25, 2*50 + 25), new PVector(23*50 + 25, 2*50 + 25), new PVector(30*50 + 25, 2*50 + 25), 150, 50, 3, 1000));
  } else if(level == 3) {
    platforms.add(new FPlatform(new PVector(20*50 + 25, 4 * 50 + 25), new PVector(26*50 + 25, 4 * 50 + 25), new PVector(10*50 + 25, 4 * 50 + 25), 150, 50, 3, 1000));
    platforms.add(new FPlatform(new PVector(27*50 + 25, 12 * 50 + 25), new PVector(27*50 + 25, 12 * 50 + 25), new PVector(17*50 + 25, 12 * 50 + 25), 150, 50, 2, 1000));
    platforms.add(new FPlatform(new PVector(4*50 + 25, 12 * 50 + 25), new PVector(4*50 + 25, 12 * 50 + 25), new PVector(14*50 + 25, 12 * 50 + 25), 150, 50, 2, 1000));
  } else if(level == 4) {
    platforms.add(new FPlatform(new PVector(7*50 + 25, 20*50 + 25), new PVector(7*50 + 25, 20*50 + 25), new PVector(7*50 + 25, -1*50 + 25), 150, 50, 3, 0));
    platforms.add(new FPlatform(new PVector(11*50 + 25, 6*20/7*50 + 25), new PVector(11*50 + 25, 20*50 + 25), new PVector(11*50 + 25, -1*50 + 25), 150, 50, 3, 0));
    platforms.add(new FPlatform(new PVector(15*50 + 25, 5*20/7*50 + 25), new PVector(15*50 + 25, 20*50 + 25), new PVector(15*50 + 25, -1*50 + 25), 150, 50, 3, 0));
    platforms.add(new FPlatform(new PVector(19*50 + 25, 4*20/7*50 + 25), new PVector(19*50 + 25, 20*50 + 25), new PVector(19*50 + 25, -1*50 + 25), 150, 50, 3, 0));
    platforms.add(new FPlatform(new PVector(23*50 + 25, 3*20/7*50 + 25), new PVector(23*50 + 25, 20*50 + 25), new PVector(23*50 + 25, -1*50 + 25), 150, 50, 3, 0));
    platforms.add(new FPlatform(new PVector(27*50 + 25, 2*20/7*50 + 25), new PVector(27*50 + 25, 20*50 + 25), new PVector(27*50 + 25, -1*50 + 25), 150, 50, 3, 0));
    platforms.add(new FPlatform(new PVector(31*50 + 25, 1*20/7*50 + 25), new PVector(31*50 + 25, 20*50 + 25), new PVector(31*50 + 25, -1*50 + 25), 150, 50, 3, 0));
  }
  
  for(FPlatform platform : platforms) {
    world.add(platform);
  }

  player = new FPlayer(playerSpawnPos.x, playerSpawnPos.y);
  world.add(player);
  
}
FBox makeTile(PImage img) {
  FBox t = new FBox(gridSize, gridSize);
  t.attachImage(img);
  return t;
}

void gameSceneDraw() {
  background(backgroundImg);

  isGrounded = player.isGrounded();
  handleGravity();
  updateObjects();
  handlePlayerCollisions();

  world.step();
  alignTiles();
  world.draw();
  drawPlayerFace();
  drawUI();
  
  //world.drawDebug();
  //world.drawDebugData();
}

void updateObjects() {
  player.update();
  star.update();
  for(FPlatform platform : platforms) {
    platform.update();
  }
}

void handlePlayerCollisions() {
    ArrayList<FContact> contacts = player.getPlayerContacts();
    for(FContact contact : contacts) {
      if(contact.contains("spike")) {
        playerDies();
        break;
      }
      else if(contact.contains("star")) {
        loadLevel(level+1);
        break;
      } else if(contact.contains("platform") && isGrounded) {
        FPlatform platform;
        if(contact.getBody1().getName().equals("platform")) {
          platform = (FPlatform) contact.getBody1();
        } else {
          platform = (FPlatform) contact.getBody2();
        }
        
        // add platform velocity to player position
        for (int i = 0; i < player.getVertexBodies().size(); i++) {
          ((FBody)player.getVertexBodies().get(i)).adjustPosition(platform.getVelocity().x, platform.getVelocity().y);
        }
        break;
      }
    }
  }

void drawUI() {
  textFont(font);
  textSize(80);
  textAlign(LEFT);
  text("Level " + (level+1) +"  Flips left: " + flipsLeft + "  Deaths: " + deaths, 60, 100);
}

void loadLevel(int level) {
  if(level < 0 || level >= mapImgsArr.length) {
    loadScene(START_SCENE);
    return;
  }
  
  this.level = level;
  deaths = 0;
  setupScene();
}
void playerDies() {
  deaths++;
  setupScene();
}

void handleGravity() {
  int targetGravity = normalGravityStrength;
  // if play is falling use a stronger gravity
  if(isGravityFlipped ? player.getPlayerVelocity().y < 0 : player.getPlayerVelocity().y > 0) {
    targetGravity = fallingGravityStrength;
  } else {
    targetGravity = normalGravityStrength;
  }
  
  if(isGravityFlipped) targetGravity = -targetGravity;
  
  world.setGravity(0, targetGravity);
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
  translate(player.getPlayerCenterPos().x + (isFacingRight ? 4 : -4), player.getPlayerCenterPos().y + (isGravityFlipped ? -6 : 6));
  scale(isFacingRight ? -0.5 : 0.5, isGravityFlipped ? -0.5 : 0.5);
  
  textFont(isGrounded ? smileFont : surprisedFont);
  textAlign(CENTER);
  fill(0);
  text(isGrounded ? "◕‿◕" : "˃⤙˂", 0, 0);
  
  popMatrix();
}

void gameSceneKeyPressed() {
  if (key == 'a') aKeyDown = true;
  if (key == 'd') dKeyDown = true;
  if (key == ' ') spaceKeyDown = true;
  
  if(key == 'g' && flipsLeft > 0) {
    isGravityFlipped = !isGravityFlipped;
    flipsLeft--;
  }
}
void gameSceneKeyReleased() {
  if (key == 'a') aKeyDown = false;
  if (key == 'd') dKeyDown = false;
  if (key == ' ') spaceKeyDown = false;
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
