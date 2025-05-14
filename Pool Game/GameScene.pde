void GameDraw() {
  background(isRedTurn ? redBackground : blueBackground);
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
  
  // if all balls are gone
  if(redScore >= 8 || blueScore >= 7) {
    mode = GAMEOVER;
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
      pull = 0;
    }
  }

  // draw cue when balls are still OR during charge / shove
  if (areBallsStill() || charging || shooting) drawCue();
  
  // balls just stopped
  if(areBallsStill() && !ballsStillLastFrame) {
    isRedTurn = !isRedTurn;
  }
  
  // draw trajectory
  if(areBallsStill()) {
    drawTrajectory();
  }
  
  // score texts
  textSize(80);
  textAlign(CENTER);
  textFont(scoreFont);
  
  fill(RED_COLOR);
  text(redScore, width/2 -80, 80);
  fill(BLUE_COLOR);
  text(blueScore, width/2 +80, 80);
  
  ballsStillLastFrame = areBallsStill();
}


void drawCue() {
  PVector dir = PVector.fromAngle(cueAngle).normalize();
  
  PVector tip = PVector.add(whiteBall.pos, PVector.mult(dir, -(whiteBall.r + pull + 10)));
  PVector butt = PVector.add(tip, PVector.mult(dir, -cueLength));

  stroke(181, 130, 70);
  strokeWeight(8);
  line(tip.x, tip.y, butt.x, butt.y);
}

void drawTrajectory() {
  PVector dir = PVector.fromAngle(cueAngle).normalize();
  
  for(int i = 0; i < 1000; i+= 20) {
    PVector lineStart = PVector.add(whiteBall.pos, PVector.mult(dir, (whiteBall.r + 10 + i)));
    PVector lineEnd = PVector.add(lineStart, PVector.mult(dir, 10));
    
    stroke(0, 0, 0, 100);
    strokeWeight(3);
    
    line(lineStart.x, lineStart.y, lineEnd.x, lineEnd.y);
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


void GameMousePressed() {
  if (areBallsStill() && !charging && !shooting) {
    cueAngle = atan2(whiteBall.pos.y - mouseY, whiteBall.pos.x - mouseX);
  }
}
void GameMouseDragged() {
  GameMousePressed();
}
void GameKeyPressed() {
  if (key == ' ' && areBallsStill() && !shooting) {
    charging = true;
    charge = 0;
    pull = 0;
  }
  if(key == TAB) {
    mode = PAUSED;
  }
}
void GameSceneKeyReleased() {
  if (key == ' ' && charging) {
    PVector dir = PVector.fromAngle(cueAngle).normalize();
    whiteBall.velocity = dir.mult(charge * 0.6f);

    charging = false;
    shooting = true;
    shootF = 0;
    shootStartPull = pull;
  }
}



void collision(Ball a, Ball b) {
  PVector delta = PVector.sub(b.pos, a.pos);
  float dist = delta.mag();
  float minDist = a.r + b.r;

  if (dist >= minDist || dist == 0) return;

  PVector n = delta.copy().div(dist);   // collision unit vector
  PVector relVel = PVector.sub(b.velocity, a.velocity);
  float vn = relVel.dot(n);          
  if (vn > 0) return;       

  float j = -(1.96) * vn / (1 / a.m + 1 / b.m);
  PVector impulse = PVector.mult(n, j);

  a.velocity.sub(PVector.mult(impulse, 1 / a.m));
  b.velocity.add(PVector.mult(impulse, 1 / b.m));
}
