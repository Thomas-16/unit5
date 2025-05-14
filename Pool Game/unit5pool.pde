float cueAngle = -PI/2; 
float cueLength = 180;
float pull = 0;
final float MAX_PULL = 60;
final int SHOOT_FRAMES = 6; 
final float MAX_CHARGE = 60;
boolean charging = false;
boolean shooting = false;
int shootF = 0;   
float charge = 0;  
float shootStartPull;

Hole[] holes;
ArrayList<Ball> balls;
Ball whiteBall;

// scores
int redScore;
int blueScore;
PFont scoreFont;

color BLUE_COLOR = color(0,102,255);
color RED_COLOR = color(255,36,0);
color redBackground = #ed634e;
color blueBackground = #b0d7ff;

boolean isRedTurn;
boolean ballsStillLastFrame = true;

// mode framework
int mode;
final int START = 0;
final int GAME = 1;
final int GAMEOVER = 2;
final int PAUSED = 3;


void setup() {
  size(800, 1000, P2D);
  
  redScore = 0;
  blueScore = 0;
  scoreFont = createFont("calibrib.ttf", 80);
  
  isRedTurn = true;
  mode = 1;

  holes = new Hole[6];
  holes[0] = new Hole(new PVector(width/2 + 250, height/2 - 350), 50);
  holes[1] = new Hole(new PVector(width/2 - 250, height/2 - 350), 50);
  holes[2] = new Hole(new PVector(width/2 + 250, height/2), 50);
  holes[3] = new Hole(new PVector(width/2 - 250, height/2), 50);
  holes[4] = new Hole(new PVector(width/2 + 250, height/2 + 350), 50);
  holes[5] = new Hole(new PVector(width/2 - 250, height/2 + 350), 50);

  // balls
  balls = new ArrayList<Ball>();

  // white ball
  whiteBall = new Ball(new PVector(width/2, height/2 + 250), new PVector(), color(255), true, false);
  balls.add(whiteBall);

  PVector rackOrigin = new PVector(width/2, height/2 - 100);
  int rows = 5;
  int blueCount = 0, redCount = 0;

  for (int r = 0; r < rows; r++) {
    for (int c = 0; c <= r; c++) {
      float x = rackOrigin.x + (r*BALL_R) - (c*BALL_R*2);
      float y = rackOrigin.y + r*BALL_R*sqrt(3);
      color col;
      boolean isRed;

      if (blueCount < 7 && (redCount >= 7 || random(1) < 0.5)) {
        col = color(BLUE_COLOR);
        blueCount++;
        isRed = false;
      }
      else {
        col = RED_COLOR;
        redCount++;
        isRed = true;
      }

      balls.add(new Ball(new PVector(x, y), new PVector(), col, false, isRed));
    }
  }
}

void draw() {
  switch(mode) {
    case START: break;
    case GAME: GameDraw(); break;
    case GAMEOVER: GameOverDraw(); break;
    case PAUSED: PausedDraw(); break;
  }
}

boolean areBallsStill() {
  for(Ball ball : balls) {
    if(ball.velocity.magSq() > 0.01) {
      return false;
    }
  }
  return true;
}

void mousePressed() {
  switch(mode) {
    case START: break;
    case GAME: GameMousePressed(); break;
    case GAMEOVER: break;
    case PAUSED: break;
  }
}
void mouseDragged() {
  switch(mode) {
    case START: break;
    case GAME: GameMouseDragged(); break;
    case GAMEOVER: break;
    case PAUSED: break;
  }
}

void keyPressed() {
  switch(mode) {
    case START: break;
    case GAME: GameKeyPressed(); break;
    case GAMEOVER: break;
    case PAUSED: PausedKeyPressed(); break;
  }
}

void keyReleased() {
  switch(mode) {
    case START: break;
    case GAME: GameSceneKeyReleased(); break;
    case GAMEOVER: break;
    case PAUSED: break;
  }
}
