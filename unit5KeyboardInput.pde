color white = #ffffff;
color black = #000000;  
color darkPurple = #42213d;
color blue = #3272fc;
color pink = #f57fef;
color green = #61ee00;

// target
float x1, y1, x2, y2;
PVector dir1, dir2;

// ball variables
float ballX, ballY, ballD;
float vx, vy;

// key variables
boolean wKeyDown, aKeyDown, sKeyDown, dKeyDown;
boolean upDown, downDown, leftDown, rightDown;

void setup() {
  size(800, 800, P2D);  
  x1 = width / 2;
  y1 = height / 2;
  x2 = width / 2;
  y2 = height / 2;
  
  ballX = 100;
  ballY = height/2;
  ballD = 60;

  vx = random(4, 6);
  vy = random(4, 6);
}

void draw() {  
  background(darkPurple);
  
  strokeWeight(4);
  stroke(white);
  
  // player 1
  fill(pink);
  dir1 = new PVector(0, 0);
  if(wKeyDown) dir1.y -= 1;
  if(aKeyDown) dir1.x -= 1;
  if(sKeyDown) dir1.y += 1;
  if(dKeyDown) dir1.x += 1;
  
  dir1.normalize();
  x1 += dir1.x * 5;
  y1 += dir1.y * 5;
  circle(x1, y1, 100);
  
  // player 2
  fill(blue);
  dir2 = new PVector(0, 0);
  if(upDown) dir2.y -= 1;
  if(leftDown) dir2.x -= 1;
  if(downDown) dir2.y += 1;
  if(rightDown) dir2.x += 1;
  
  dir2.normalize();
  x2 += dir2.x * 5;
  y2 += dir2.y * 5;
  circle(x2, y2, 100);
  
  // ball
  strokeWeight(4);
  stroke(white);
  fill(green);
  circle(ballX, ballY, ballD);

  if (ballY - ballD/2 <= 0) {
    vy *= -1;
    ballY = ballD/2;
  }
  if (ballY + ballD/2 >= height) {
    vy *= -1;
    ballY = height - ballD/2;
  }
  if (ballX - ballD/2 <= 0) {
    vx *= -1;
    ballX = ballD/2;
  }
  if(ballX + ballD/2 >= width ) {
    vx *= -1;
    ballX = width - ballD/2;
  }
  
  if(dist(x1, y1, ballX, ballY) <= 50 + ballD/2) {
    PVector newV = new PVector(ballX - x1, ballY - y1);
    newV.normalize();
    newV.mult(mag(vx, vy));
    
    vx = newV.x;
    vy = newV.y;
  }
  
  ballX += vx;
  ballY += vy;
  
}

void keyPressed() {
  if(key == 'w') wKeyDown = true;
  if(key == 'a') aKeyDown = true;
  if(key == 's') sKeyDown = true;
  if(key == 'd') dKeyDown = true;
  
  if(keyCode == UP) upDown = true;
  if(keyCode == DOWN) downDown = true;
  if(keyCode == LEFT) leftDown = true;
  if(keyCode == RIGHT) rightDown = true;
}
void keyReleased() {
  if(key == 'w') wKeyDown = false;
  if(key == 'a') aKeyDown = false;
  if(key == 's') sKeyDown = false;
  if(key == 'd') dKeyDown = false;
  
  if(keyCode == UP) upDown = false;
  if(keyCode == DOWN) downDown = false;
  if(keyCode == LEFT) leftDown = false;
  if(keyCode == RIGHT) rightDown = false;
}
