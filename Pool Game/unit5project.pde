import fisica.*;


// https://web.archive.org/web/20140802193416/http://wiki.processing.org/w/Fisica_/_JBox2D_physics_engine#FCircle
// https://mycours.es/fisica/
// https://github.com/rikrd/fisica/blob/master/src/fisica/FBody.java

FWorld world;

// objects
FBox b;
FCircle circle;
 
void setup() {
  size(1200, 800, P2D);
 
  Fisica.init(this);
  world = new FWorld();
  
  world.setEdges();
  world.setGrabbable(false);
  world.setGravity(0, 800);
  
  
  b = new FBox(80, 80);
  b.setRotation(PI/5);
  b.setPosition(width/2, 100);
  world.add(b);
  
  circle = new FCircle(80);
  circle.setPosition(width/2, height/2);
  world.add(circle);
  
}

void draw() {
  background(240);
  
  if(random(1) < 0.005) {
    b.addImpulse(b.getPosition().x, b.position.y);
  }
  
  world.step();
  world.draw();
  world.drawDebug();
  world.drawDebugData();
}
