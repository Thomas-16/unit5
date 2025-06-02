
int w = 150;
int h = 50;
int gap = 50;
int yLevel = 600;
int totalRowWidth;
int startX;

color fillCol = color(70, 180, 140);   // idle
color outlineCol = color(30,  90,  70);   // idle outline
color hoverOutlineCol = color(255, 220, 0);   // hovering
color clickFillCol = color(40, 140, 110);   // while pressed
int outlineW = 4;
int cornerRadius = 8;

RectButton[] levelButtons;

void startSceneSetup() {
  backgroundImg = loadImage("background.png");
  
  font = createFont("ByteBounce.ttf", 64);
  
  mapImgsArr = new PImage[] {
    loadImage("level1Map.png"), loadImage("level2Map.png"), loadImage("level3Map.png"), loadImage("level4Map.png"), loadImage("level5Map.png")
  };
  
  totalRowWidth = w * mapImgsArr.length + gap * (mapImgsArr.length - 1);
  startX = (width - totalRowWidth) / 2;
  
  levelButtons = new RectButton[mapImgsArr.length];
  for (int i = 0; i < mapImgsArr.length; i++) {
    int xPos = startX + i * (w + gap); 
  
    levelButtons[i] = new RectButton(xPos, yLevel, w, h, fillCol, outlineCol, hoverOutlineCol, clickFillCol, outlineW, cornerRadius);
  }
  
  for(int i = 0; i < levelButtons.length; i++) {
    final int level = i;
    levelButtons[i].setOnClick(() -> {
      loadScene(GAME_SCENE);
      loadLevel(level);
    });
  }
}

void startSceneDraw() {
  background(backgroundImg);
  
  textFont(font);
  textAlign(CENTER);
  textSize(180);
  fill(0);
  text("Gravity Flip  ", width/2, 300);
  
  for(RectButton button : levelButtons) {
    button.draw();
  }
  
  for (int i = 0; i < mapImgsArr.length; i++) {
    int xPos = startX + i * (w + gap); 
    
    textAlign(CENTER, CENTER);
    textSize(40);
    fill(0);
    text("Level " + (i+1), xPos, yLevel);
  }
}
void startSceneMousePressed() {
  for(RectButton button : levelButtons) {
    button.mousePressed();
  }
}
void startSceneMouseReleased() {
  for(RectButton button : levelButtons) {
    button.mouseReleased();
  }
}
