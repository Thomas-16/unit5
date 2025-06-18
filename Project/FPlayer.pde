class FPlayer extends FBlob {
  private int speed = 300;
  private int jumpStrength = 520;
  
  public FPlayer(float spawnPosX, float spawnPosY) {
    super();
    
    this.setAsCircle(spawnPosX, spawnPosY, 80, 25);
    this.setStroke(0, 0, 0, 0);
    this.setFill(159, 236, 191);
    this.setName("player");
  }
  
  public void update(){
    handleMovement();
  }
  
  private void handleMovement() {
    float targetVelocity = 0;
  
    if (aKeyDown && !dKeyDown) {
      targetVelocity = -speed;
      isFacingRight = false;
    }
    if (dKeyDown && !aKeyDown) {
      targetVelocity = speed;
      isFacingRight = true;
    }
    if (!aKeyDown && !dKeyDown) {
      targetVelocity = 0;
    }
  
    float avgXVel = getPlayerVelocity().x;
    //println("avg x vel: " + avgXVel);
    float changeAmt = (targetVelocity - avgXVel) * 0.15;
    //println("change amt " + changeAmt);
    for (int i = 0; i < this.getVertexBodies().size(); i++) {
      ((FBody)this.getVertexBodies().get(i)).adjustVelocity(changeAmt, 0);
    }
    
    if (spaceKeyDown) {
      if(millis() - lastJumpTime > 80 && isGrounded) {
        for (int i = 0; i < this.getVertexBodies().size(); i++) {
          FBody vertexBody = (FBody)this.getVertexBodies().get(i);
          vertexBody.setVelocity(vertexBody.getVelocityX(), isGravityFlipped ? jumpStrength : -jumpStrength);
          lastJumpTime = millis();
        }
      }
    }
  }
  
  public PVector getPlayerVelocity() {
    float xVelSum = 0;
    float yVelSum = 0;
  
    for (Object vertexObj : this.getVertexBodies()) {
      FBody vertex = (FBody) vertexObj;
      xVelSum += vertex.getVelocityX();
      yVelSum += vertex.getVelocityY();
    }
    return new PVector(xVelSum / this.getVertexBodies().size(), yVelSum / this.getVertexBodies().size());
  }
  public PVector getPlayerCenterPos() {
    float sumX = 0, sumY = 0;
    
    for (Object vertexObj : this.getVertexBodies()) {
      FBody vertex = (FBody) vertexObj;
      sumX += vertex.getX();
      sumY += vertex.getY();
    }
    return new PVector(sumX / this.getVertexBodies().size(), sumY / this.getVertexBodies().size());
  }
  public ArrayList<FContact> getPlayerContacts() {
    ArrayList<FContact> contacts = new ArrayList<FContact>();
    ArrayList<FBody> verts = this.getVertexBodies();
    for (FBody v : verts) {
      ArrayList<FContact> vc = v.getContacts(); 
      for (FContact c : vc) {
        contacts.add(c);
      }
    }
    return contacts;
  }
  
  public boolean isGrounded() {
    if(!isGravityFlipped) {
      float lowestY = -99999; 
      for (Object vObj : player.getVertexBodies()) {
        FBody v = (FBody) vObj;
        if (v.getY() > lowestY) lowestY = v.getY();
      }
    
      for (Object vObj : player.getVertexBodies()) {
        FBody v = (FBody) vObj;
        if (abs(v.getY() - lowestY) > 10) continue; 
    
        for (Object cObj : v.getContacts()) {
          FContact c = (FContact) cObj;
          FBody other = (c.getBody1() == v) ? c.getBody2() : c.getBody1();
    
          if (other != null && player.getVertexBodies().contains(other)) continue;
    
          return true;
        }
      }
      return false;  
    }
    // gravity is flipped
    else {
      float highestY = 99999; 
      for (Object vObj : player.getVertexBodies()) {
        FBody v = (FBody) vObj;
        if (v.getY() < highestY) highestY = v.getY();
      }
    
      for (Object vObj : player.getVertexBodies()) {
        FBody v = (FBody) vObj;
        if (abs(v.getY() - highestY) > 10) continue; 
    
        for (Object cObj : v.getContacts()) {
          FContact c = (FContact) cObj;
          FBody other = (c.getBody1() == v) ? c.getBody2() : c.getBody1();
    
          if (other != null && player.getVertexBodies().contains(other)) continue;
    
          return true;
        }
      }
      return false;  
    }
  }
  
}
