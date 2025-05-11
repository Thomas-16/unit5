
float cueAngle = -PI/2; 
float cueLength = 180;
float pull = 0;
final float MAX_PULL = 60;
boolean charging = false; 
boolean shooting = false;
int shootF = 0;   
final int SHOOT_FRAMES = 6; 
float charge = 0;  
final float MAX_CHARGE = 60;
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

void setup() {
  size(800, 1000, P2D);
  
  redScore = 0;
  blueScore = 0;
  scoreFont = createFont("calibrib.ttf", 80);

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
  background(#ffffff);
  drawTable();
  
  for (Hole h : holes) h.update();

  // physics
  for (int i = 0; i < balls.size(); i++) {
    Ball ball = balls.get(i);
    ball.update();
    for (int j = i+1; j < balls.size(); j++) collision(ball, balls.get(j));
    ball.display();
  }
  
  // check if any ball is in a hole
  ArrayList<Integer> ballsToBeRemoved = new ArrayList<Integer>();
  for(Hole hole : holes) {
    for(int i = 0; i < balls.size(); i++) {
      if(hole.isBallWithinHole(balls.get(i)) && !balls.get(i).isWhiteBall) {
        ballsToBeRemoved.add(i);
      }
    }
  }
  
  for(int i = 0; i < ballsToBeRemoved.size(); i++) {
    Ball ballToRemove = balls.get(ballsToBeRemoved.get(i) - i);
    if(ballToRemove.isRedBall) {
      redScore++;
    } else {
      blueScore++;
    }
    balls.remove(ballToRemove);
  }
  
  // cue stick logic
  if (areBallsStill() && charging) {  // keep pulling back
    if (charge < MAX_CHARGE) {
      charge++;
      pull = map(charge, 0, MAX_CHARGE, 0, MAX_PULL);
    }
  }

  if (shooting) {  // forward shove
    float t = (float)shootF / SHOOT_FRAMES;
    pull = lerp(shootStartPull, 0, t);
    shootF++;
    if (shootF >= SHOOT_FRAMES) {
      shooting = false;
      pull     = 0;
    }
  }

  // draw cue when balls are still OR during charge / shove
  if (areBallsStill() || charging || shooting) drawCue();
  
  // score texts
  textSize(80);
  textAlign(CENTER);
  textFont(scoreFont);
  
  fill(RED_COLOR);
  text(redScore, width/2 -80, 80);
  fill(BLUE_COLOR);
  text(blueScore, width/2 +80, 80);
  
}

void drawCue() {
  PVector dir = PVector.fromAngle(cueAngle).normalize();
  
  PVector tip  = PVector.add(whiteBall.pos, PVector.mult(dir, -(whiteBall.r + pull)));
  PVector butt = PVector.add(tip, PVector.mult(dir, -cueLength));

  stroke(181, 130, 70);
  strokeWeight(8);
  line(tip.x, tip.y, butt.x, butt.y);
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
  if (areBallsStill() && !charging && !shooting) {
    cueAngle = atan2(whiteBall.pos.y - mouseY, whiteBall.pos.x - mouseX);
  }
}

void keyPressed() {
  if (key == ' ' && areBallsStill() && !shooting) {
    charging = true;
    charge   = 0;
    pull     = 0;
  }
}

void keyReleased() {
  if (key == ' ' && charging) {
    PVector dir = PVector.fromAngle(cueAngle).normalize();
    whiteBall.velocity = dir.mult(charge * 0.4f);

    charging = false;
    shooting = true;
    shootF = 0;
    shootStartPull = pull;
  }
}


void drawTable() {
  stroke(#000000);
  strokeWeight(7);
  fill(110, 57, 43);
  rectMode(CENTER);
  rect(width/2, height/2, 600, 800, 30);

  strokeWeight(10);
  fill(0,196,99);
  rect(width/2, height/2, 500, 700, 30);
}


void collision(Ball a, Ball b) {
  PVector delta = PVector.sub(b.pos, a.pos);
  float dist = delta.mag();
  float minDist = a.r + b.r;

  if (dist >= minDist || dist == 0) return;

  // overlap correction
  float overlap = minDist - dist;
  PVector n = delta.copy().div(dist);   // collision unit vector
  a.pos.add(PVector.mult(n, -overlap * 0.5));
  b.pos.add(PVector.mult(n,  overlap * 0.5));

  PVector relVel = PVector.sub(b.velocity, a.velocity);
  float vn = relVel.dot(n);          
  if (vn > 0) return;       

  float j = -(1 + 0.96) * vn / (1 / a.m + 1 / b.m);
  PVector impulse = PVector.mult(n, j);

  a.velocity.sub(PVector.mult(impulse, 1 / a.m));
  b.velocity.add(PVector.mult(impulse, 1 / b.m));
}
