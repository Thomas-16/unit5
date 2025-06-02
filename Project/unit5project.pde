import fisica.*;

// https://web.archive.org/web/20140802193416/http://wiki.processing.org/w/Fisica_/_JBox2D_physics_engine#FCircle
// https://mycours.es/fisica/
// https://github.com/rikrd/fisica/blob/master/src/fisica/FBody.java
// https://haphub.github.io/hAPI_Fisica/class_f_blob.html


// TODOS:


final int START_SCENE = 0;
final int GAME_SCENE = 1;
int scene = START_SCENE;


void setup() {
  size(1800, 1000, P2D);
  noSmooth();
  
  loadScene(scene);
}

void draw() {
  switch(scene) {
    case START_SCENE:
      startSceneDraw();
      break;
    case GAME_SCENE:
      gameSceneDraw();
      break;
  }
}

void loadScene(int scene) {
  this.scene = scene;
  
  switch(scene) {
    case START_SCENE:
      startSceneSetup();
      break;
    case GAME_SCENE:
      gameSceneSetup();
      break;
  }
}


void keyPressed() {
  switch(scene) {
    case START_SCENE:
      
      break;
    case GAME_SCENE:
      gameSceneKeyPressed();
      break;
  }
}
void keyReleased() {
  switch(scene) {
    case START_SCENE:
      
      break;
    case GAME_SCENE:
      gameSceneKeyReleased();
      break;
  }
}
void mousePressed() {
  switch(scene) {
    case START_SCENE:
      startSceneMousePressed();
      break;
    case GAME_SCENE:
     
      break;
  }
}
void mouseReleased() {
  switch(scene) {
    case START_SCENE:
      startSceneMouseReleased();
      break;
    case GAME_SCENE:
      
      break;
  }
}
