final float BALL_R      = 20;    
final float FRICTION    = 0.98;  // velocity decay
final float BOUNCE_DAMP = 0.90;  // velocity kept after rail impact
final float RESTITUTION = 0.96;  // ball–ball bounciness

class Ball {
  PVector pos, velocity;
  color col;
  float r = BALL_R, m = 1;
  boolean isWhiteBall;
  boolean isRedBall;

  Ball(PVector p, PVector v, color c, boolean w, boolean r) {
    pos = p.copy();
    velocity = v.copy();
    col = c;
    isWhiteBall = w;
    isRedBall = r;
  }

  void update() {
    // friction (rolling resistance)
    velocity.mult(FRICTION);
    if (velocity.magSq() < 0.01) velocity.set(0, 0);

    pos.add(velocity);
    collideRails();
  }

  void display() {
    stroke(0);
    strokeWeight(4);
    fill(col);
    circle(pos.x, pos.y, r*2);
  }

  // hit the cushions
  void collideRails() {
    float left   = width/2f - 250 + r;
    float right  = width/2f + 250 - r;
    float top    = height/2f - 350 + r;
    float bottom = height/2f + 350 - r;

    if (pos.x < left)  { pos.x = left;  velocity.x *= -BOUNCE_DAMP; }
    if (pos.x > right) { pos.x = right; velocity.x *= -BOUNCE_DAMP; }
    if (pos.y < top)   { pos.y = top;   velocity.y *= -BOUNCE_DAMP; }
    if (pos.y > bottom){ pos.y = bottom;velocity.y *= -BOUNCE_DAMP; }
  }
}
