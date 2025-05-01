// https://www.google.com/search?q=2d+collision+balls+calculation+game+dev&newwindow=1&sca_esv=1740ddc3d2160827&rlz=1C1GCEA_enCA1147CA1147&sxsrf=AHTn8zreBLZQFdc_TJMGAZrO5fYOmyj_jA%3A1746127446112&ei=VsoTaJTQBoul0PEPxsbC8QE&ved=0ahUKEwiU06HR_4KNAxWLEjQIHUajMB4Q4dUDCBA&uact=5&oq=2d+collision+balls+calculation+game+dev&gs_lp=Egxnd3Mtd2l6LXNlcnAiJzJkIGNvbGxpc2lvbiBiYWxscyBjYWxjdWxhdGlvbiBnYW1lIGRldjIHECEYoAEYCjIHECEYoAEYCkicG1C4A1jOFnADeAGQAQCYAXygAbUJqgEEMTUuMbgBA8gBAPgBAZgCE6ACzArCAgoQABiwAxjWBBhHwgIFECEYoAHCAgUQIRifBcICBBAhGBWYAwCIBgGQBgiSBwQxNy4yoAfTQ7IHBDE0LjK4B6oK&sclient=gws-wiz-serp

color white = #ffffff;
color black = #000000;
color darkPurple = #42213d;
color blue = #3272fc;
color pink = #f57fef;

// ball variables
float x1, y1, ballD;
PVector v1, a1;
float x2, y2;
PVector v2, a2;



void setup() {
  size(800, 800, P2D);
  x1 = width/3 * 2;
  y1 = height/2;
  x2 = width/3 * 2;
  y2 = height/2;
  ballD = 60;
  
  v1 = new PVector(random(-6, 6), random(-6, 6));
  a1 = new PVector(0, 1);
  v2 = new PVector(random(-6, 6), random(-6, 6));
  a2 = new PVector(0, 1);
}

void draw() {
  background(darkPurple);

  strokeWeight(4);
  stroke(white);
  fill(pink);
  circle(x1, y1, ballD);
  fill(#008000);
  circle(x2, y2, ballD);

  if (y1 - ballD/2 <= 0) {
    v1.y *= -0.94;
    y1 = ballD/2;
  }
  if (y1 + ballD/2 >= height) {
    v1.y *= -0.94;
    y1 = height - ballD/2;
  }
  if (x1 - ballD/2 <= 0) {
    v1.x *= -0.94;
    x1 = ballD/2;
  }
  if(x1 + ballD/2 >= width ) {
    v1.x *= -0.94;
    x1 = width - ballD/2;
  }
  
  if (y2 - ballD/2 <= 0) {
    v2.y *= -0.94;
    y2 = ballD/2;
  }
  if (y2 + ballD/2 >= height) {
    v2.y *= -0.94;
    y2 = height - ballD/2;
  }
  if (x2 - ballD/2 <= 0) {
    v2.x *= -0.94;
    x2 = ballD/2;
  }
  if(x2 + ballD/2 >= width ) {
    v2.x *= -0.94;
    x2 = width - ballD/2;
  }
  
  if(dist(x1, y1, x2, y2) <= ballD) {
    PVector pos1 = new PVector(x1, y1);
    PVector pos2 = new PVector(x2, y2);
    PVector distVector = pos1.sub(pos2);
    
    PVector n = distVector.div(mag(distVector.x, distVector.y));

  }
  
  x1 += v1.x;
  y1 += v1.y;
  x2 += v2.x;
  y2 += v2.y;
  
  //PVector aVector = new PVector(mouseX - ballX, mouseY - ballY);
  //aVector.normalize();

  //vx += aVector.x;
  //vy += aVector.y;
  v1.x += a1.x;
  v1.y += a1.y;
  v2.x += a2.x;
  v2.y += a2.y;
}
