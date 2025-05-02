class Hole {
  PVector pos;
  int diameter;
  
  Hole(PVector pos, int diameter) {
    this.pos = pos;
    this.diameter = diameter;
  }
  
  public void update() {
    fill(#000000);
    circle(pos.x, pos.y, diameter);
  }
}
