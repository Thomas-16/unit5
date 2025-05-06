
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
  whiteBall.velocity = new PVector(random(-10, 10), -50);
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
  
  if(areBallsStill()) {
    
  }
  
  // score texts
  textSize(80);
  textAlign(CENTER);
  textFont(scoreFont);
  
  fill(RED_COLOR);
  text(redScore, width/2 -80, 80);
  fill(BLUE_COLOR);
  text(blueScore, width/2 +80, 80);
  
}

boolean areBallsStill() {
  for(Ball ball : balls) {
    if(ball.velocity.magSq() > 0.01) {
      return false;
    }
  }
  return true;
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

  if (dist < minDist && dist > 0) {
    // position correction to avoid sinking
    float overlap = minDist - dist;
    PVector norm = delta.copy().normalize();
    a.pos.add(PVector.mult(norm, -overlap/2));
    b.pos.add(PVector.mult(norm,  overlap/2));

    // relative velocity along the normal
    PVector relVel = PVector.sub(b.velocity, a.velocity);
    float velAlongNormal = relVel.dot(norm);

    if (velAlongNormal > 0) return; // separating

    float e = RESTITUTION;
    float j = -(1+e) * velAlongNormal / (1/a.m + 1/b.m);
    PVector impulse = PVector.mult(norm, j);

    a.velocity.sub(PVector.mult(impulse, 1/a.m));
    b.velocity.add(PVector.mult(impulse, 1/b.m));
  }
}
