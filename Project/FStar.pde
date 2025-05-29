
class FStar extends FBox {
  private PImage[] images;
  private int frame = 0;
  
  public FStar(float width, float height, PImage[] images) {
    super(width, height);
    this.images = images;
    
    this.setName("star");
  }
  
  public void update() {
    if(frame == images.length) frame = 0;
    if(frameCount % 8 == 0) {
      attachImage(images[frame]);
      frame++;
    }
  }
  
}
