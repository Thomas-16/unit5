class FPlatform extends FBox {
  private float speed;  
  private int waitMs;

  private PVector startPos, endPos, targetPos, dirVector = new PVector();
  private int dir = 1;
  private boolean waiting = false;
  private int startedWaitFrame = 0;      // millis() when started waiting

  public FPlatform(PVector currentPos, PVector startPos, PVector endPos, int w, int h, float speed, int waitMs) {
    super(w, h);
    this.startPos = startPos;
    this.endPos = endPos;
    this.targetPos = endPos;
    this.speed = speed;
    this.waitMs = waitMs;

    setPosition(currentPos.x, currentPos.y);
    setStatic(true);
    attachImage(platformImg);
    setName("platform");
  }

  public void update() {
    if (waiting) {
      if (millis() - startedWaitFrame >= waitMs) waiting = false;
      else { // waiting
        dirVector.set(0, 0);
        return;
      }
    }

    dirVector.set(targetPos.x - getX(), targetPos.y - getY()).normalize();
    adjustPosition(dirVector.x * speed, dirVector.y * speed);

    if (abs(getX() - targetPos.x) < speed && abs(getY() - targetPos.y) < speed) {
      setPosition(targetPos.x, targetPos.y); 
      waiting = true;
      startedWaitFrame = millis();

      dir *= -1;
      targetPos = (dir == 1) ? endPos : startPos;
    }
  }

  public PVector getVelocity() {
    return waiting ? new PVector(0, 0) : new PVector(dirVector.x * speed, dirVector.y * speed);
  }
}
