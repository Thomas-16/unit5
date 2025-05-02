//// Lawrence Mo
//// February 12th, 2025
//// Block 2-4
//// Title: CITY NIGHT SKY

float moonX = -120;
int XpositionHouse = 100;
int XpositionHouse1 = 160;
int XpositionHouse2 = 200;
int XpositionHouse3 = 280;
int XpositionHouse4 = 30;
int XpositionHouse5 = -30;

int XpositionHouseA = 500;
int XpositionHouseB = 560;
int XpositionHouseC = 600;
int XpositionHouseD = 680;
int XpositionHouseE = 430;
int XpositionHouseF = 370;

int XpositionHouseG = 900;
int XpositionHouseH = 960;
int XpositionHouseI = 1000;
int XpositionHouseJ = 1080;
int XpositionHouseK = 830;
int XpositionHouseL = 770;

int XpositionHouseM = 1300;
int XpositionHouseN = 1360;
int XpositionHouseO = 1400;
int XpositionHouseP = 1480;
int XpositionHouseQ = 1230;
int XpositionHouseR = 1170;
int XpositionHouseS = 1600;

//int RoadtilesU = -350;
int RoadtilesV = 0;
int RoadtilesX = 216;
int RoadtilesY = 216 * 2;
int RoadtilesZ = 216 * 3;
int RoadtilesA = 216 * 4;
int RoadtilesB = 216 * 5;
int RoadtilesC = 216 * 6;
int RoadtilesD = 216 * 7;


float Star1, Star2, Star3, Star4, Star5;
float Star6, Star7, Star8, Star9, Star10;

float StarsLocations1, StarsLocations2, StarsLocations3, StarsLocations4;
float StarsLocations5, StarsLocations6, StarsLocations7, StarsLocations8, StarsLocations9, StarsLocations10;

void setup() {
  size(1300, 800); //w, h
  Star1 = random(0, width);
  Star2 = random(0, width);
  Star3 = random(0, width);
  Star4 = random(0, width);
  Star5 = random(0, width);

  Star6 = random(0, width);
  Star7 = random(0, width);
  Star8 = random(0, width);
  Star9 = random(0, width);
  Star10 = random(0, width);

  StarsLocations1 = random(0, 250);
  StarsLocations2 = random(0, 250);
  StarsLocations3 = random(0, 250);
  StarsLocations4 = random(0, 250);
  StarsLocations5 = random(0, 250);
  StarsLocations6 = random(0, 250);
  StarsLocations7 = random(0, 250);
  StarsLocations8 = random(0, 250);
  StarsLocations9 = random(0, 250);
  StarsLocations10 = random(0, 250);
}



void draw() {
  // Night Sky Background
  background(20, 10, 50); // Background color

  // Draw gradient
  drawGradient();

  //Blur for gradient
  //filter(BLUR, 8);

  // Stars
  fill(255);
  ellipse(Star1, StarsLocations1, 3, 3);
  ellipse(Star2, StarsLocations2, 4, 4);
  ellipse(Star3, StarsLocations3, 3, 3);
  ellipse(Star4, StarsLocations4, 4, 4);
  ellipse(Star5, StarsLocations5, 3, 3);

  //2nd Set of Stars
  ellipse(Star6, StarsLocations6, 3, 3);
  ellipse(Star7, StarsLocations7, 4, 4);
  ellipse(Star8, StarsLocations8, 3, 3);
  ellipse(Star9, StarsLocations9, 4, 4);
  ellipse(Star10, StarsLocations10, 3, 3);


  // Moon glow
  MoonGlow(moonX, 100); //Glow

  // Update moon position
  moonX = moonX + 0.5;
  if (moonX > width + 100) {  // Reset position
    moonX = - 100;
  }
 
 //Ground level + Roadtiles
  fill(73, 80, 87);
  rect(0, 700, 1300, 5); //x, y, w, h
  
  fill(108, 117, 125);
  rect(0, 720, 1300, 90); //x, y, w, h
  
  //1st tile
  fill(203, 182, 74);
  ellipse(RoadtilesX, 760, 120, 15);

  RoadtilesX = RoadtilesX + 3;
  if (RoadtilesX > width + 100) {
    RoadtilesX = - 100;
  }
  
  //2nd tile
  fill(203, 182, 74);
  ellipse(RoadtilesY, 760, 120, 15);

  RoadtilesY = RoadtilesY + 3;
  if (RoadtilesY > width + 100) {
    RoadtilesY = - 100;
  }
  
  //3rd tile
  fill(203, 182, 74);
  ellipse(RoadtilesZ, 760, 120, 15);

  RoadtilesZ = RoadtilesZ + 3;
  if (RoadtilesZ > width + 100) {
    RoadtilesZ = - 100;
  }
  
  //4th tile
  fill(203, 182, 74);
  ellipse(RoadtilesA, 760, 120, 15);

  RoadtilesA = RoadtilesA + 3;
  if (RoadtilesA > width + 100) {
    RoadtilesA = - 100;
  }
  
  //5th tile
  fill(203, 182, 74);
  ellipse(RoadtilesB, 760, 120, 15);

  RoadtilesB = RoadtilesB + 3;
  if (RoadtilesB > width + 100) {
    RoadtilesB = - 100;
  }
  
  //6th tile
  fill(203, 182, 74);
  ellipse(RoadtilesC, 760, 120, 15);

  RoadtilesC = RoadtilesC + 3;
  if (RoadtilesC > width + 100) {
    RoadtilesC = - 100;
  }
  

  //Gap tiles
  fill(203, 182, 74);
  ellipse(RoadtilesV, 760, 120, 15);

  RoadtilesV = RoadtilesV + 3;
  if (RoadtilesV > width + 100) {
    RoadtilesV = - 100;
  }
  
  
  
  
  

  // Buildings
  fill(20); //r, g, b
  rect(XpositionHouse, 600, 60, 100); //x, y , w, h
  fill(76, 78, 85);
  rect(XpositionHouse1, 580, 40, 120); //x, y , w, h
  fill(31, 33, 44);
  rect(XpositionHouse2, 530, 80, 170); //x, y , w, h
  fill(44, 48, 67);
  rect(XpositionHouse3, 550, 90, 150); //x, y , w, h

  //Building between gaps
  fill(31, 34, 49); //r, g, b
  rect(XpositionHouse4, 520, 70, 180); //x, y , w, h
  fill(44, 48, 67);
  rect(XpositionHouse5, 590, 60, 110); //x, y , w, h

  //Movements of the houses
  XpositionHouse = XpositionHouse + 5;
  if (XpositionHouse > width + 150) {
    XpositionHouse = -200;
  }

  XpositionHouse1 = XpositionHouse1 + 5;
  if (XpositionHouse1 > width + 150) {
    XpositionHouse1 = -200;
  }

  XpositionHouse2 = XpositionHouse2 + 5;
  if (XpositionHouse2 > width + 150) {
    XpositionHouse2 = -200;
  }

  XpositionHouse3 = XpositionHouse3 + 5;
  if (XpositionHouse3 > width +150) {
    XpositionHouse3 = -200;
  }

  XpositionHouse4 = XpositionHouse4 + 5;
  if (XpositionHouse4 > width +150) {
    XpositionHouse4 = -200;
  }

  XpositionHouse5 = XpositionHouse5 + 5;
  if (XpositionHouse5 > width +150) {
    XpositionHouse5 = -200;
  }


  //2nd set of buildings
  fill(20); //r, g, b
  rect(XpositionHouseA, 600, 60, 100); //x, y , w, h
  fill(76, 78, 85);
  rect(XpositionHouseB, 580, 40, 120); //x, y , w, h
  fill(31, 33, 44);
  rect(XpositionHouseC, 530, 80, 170); //x, y , w, h
  fill(44, 48, 67);
  rect(XpositionHouseD, 550, 90, 150); //x, y , w, h

  //Building between gaps
  fill(31, 34, 49); //r, g, b
  rect(XpositionHouseE, 520, 70, 180); //x, y , w, h
  fill(44, 48, 67);
  rect(XpositionHouseF, 590, 60, 110); //x, y , w, h

  //Movements of the houses
  XpositionHouseA = XpositionHouseA + 5;
  if (XpositionHouseA > width + 150) {
    XpositionHouseA = -200;
  }

  XpositionHouseB = XpositionHouseB + 5;
  if (XpositionHouseB > width + 150) {
    XpositionHouseB = -200;
  }

  XpositionHouseC = XpositionHouseC + 5;
  if (XpositionHouseC > width + 150) {
    XpositionHouseC = -200;
  }

  XpositionHouseD = XpositionHouseD + 5;
  if (XpositionHouseD > width +150) {
    XpositionHouseD = -200;
  }

  XpositionHouseE = XpositionHouseE + 5;
  if (XpositionHouseE > width +150) {
    XpositionHouseE = -200;
  }

  XpositionHouseF = XpositionHouseF + 5;
  if (XpositionHouseF > width +150) {
    XpositionHouseF = -200;
  }


  //3rd set of buildings
  fill(20); //r, g, b
  rect(XpositionHouseG, 600, 60, 100); //x, y , w, h
  fill(76, 78, 85);
  rect(XpositionHouseH, 580, 40, 120); //x, y , w, h
  fill(31, 33, 44);
  rect(XpositionHouseI, 530, 80, 170); //x, y , w, h
  fill(44, 48, 67);
  rect(XpositionHouseJ, 550, 90, 150); //x, y , w, h

  //Building between gaps
  fill(31, 34, 49); //r, g, b
  rect(XpositionHouseK, 520, 70, 180); //x, y , w, h
  fill(44, 48, 67);
  rect(XpositionHouseL, 590, 60, 110); //x, y , w, h

  //Movements of the houses
  XpositionHouseG = XpositionHouseG + 5;
  if (XpositionHouseG > width + 150) {
    XpositionHouseG = -200;
  }

  XpositionHouseH = XpositionHouseH + 5;
  if (XpositionHouseH > width + 150) {
    XpositionHouseH = -200;
  }

  XpositionHouseI = XpositionHouseI + 5;
  if (XpositionHouseI > width + 150) {
    XpositionHouseI = -200;
  }

  XpositionHouseJ = XpositionHouseJ + 5;
  if (XpositionHouseJ > width +150) {
    XpositionHouseJ = -200;
  }

  XpositionHouseK = XpositionHouseK + 5;
  if (XpositionHouseK > width +150) {
    XpositionHouseK = -200;
  }

  XpositionHouseL = XpositionHouseL + 5;
  if (XpositionHouseL > width +150) {
    XpositionHouseL = -200;
  }


  //4th set of buildings
  fill(20); //r, g, b
  rect(XpositionHouseM, 600, 60, 100); //x, y , w, h
  fill(76, 78, 85);
  rect(XpositionHouseN, 580, 40, 120); //x, y , w, h
  fill(31, 33, 44);
  rect(XpositionHouseO, 530, 80, 170); //x, y , w, h
  fill(44, 48, 67);
  rect(XpositionHouseP, 550, 90, 150); //x, y , w, h

  //Building between gaps
  fill(31, 34, 49); //r, g, b
  rect(XpositionHouseQ, 520, 70, 180); //x, y , w, h
  fill(44, 48, 67);
  rect(XpositionHouseR, 590, 60, 110); //x, y , w, h

  //Individual House
  fill(31, 33, 44);
  rect(XpositionHouseS + 90, 530, 90, 170); //x, y, w, h

  //Movements of the houses
  XpositionHouseM = XpositionHouseM + 5;
  if (XpositionHouseM > width + 150) {
    XpositionHouseM = -200;
  }

  XpositionHouseN = XpositionHouseN + 5;
  if (XpositionHouseN > width + 150) {
    XpositionHouseN = -200;
  }

  XpositionHouseO = XpositionHouseO + 5;
  if (XpositionHouseO > width + 150) {
    XpositionHouseO = -200;
  }

  XpositionHouseP = XpositionHouseP + 5;
  if (XpositionHouseP > width +150) {
    XpositionHouseP = -200;
  }

  XpositionHouseQ = XpositionHouseQ + 5;
  if (XpositionHouseQ > width +150) {
    XpositionHouseQ = -200;
  }

  XpositionHouseR = XpositionHouseR + 5;
  if (XpositionHouseR > width +150) {
    XpositionHouseR = -200;
  }

  XpositionHouseS = XpositionHouseS + 5;
  if (XpositionHouseS > width +150) {
    XpositionHouseS = -200;
  }
  
  fill(255, 204, 100);
  
  //1st set of houses
  rect(XpositionHouse + 60, 590, 20, 20); //x, y, w, h
  rect(XpositionHouseA + 60, 590, 20, 20); //x, y, w, h
  rect(XpositionHouseG + 60, 590, 20, 20); //x, y, w, h
  rect(XpositionHouseM + 60, 590, 20, 20); //x, y, w, h
  
  //2nd set of houses
  rect(XpositionHouse1 + 50, 550, 20, 20); //x, y, w, h
  rect(XpositionHouseB + 50, 550, 20, 20); //x, y, w, h
  rect(XpositionHouseH + 50, 550, 20, 20); //x, y, w, h
  rect(XpositionHouseN + 50, 550, 20, 20); //x, y, w, h
  
  //3rd set of houses
  rect(XpositionHouse2 + 90, 570, 20, 20); //x, y, w, h
  rect(XpositionHouseC + 90, 570, 20, 20); //x, y, w, h
  rect(XpositionHouseI + 90, 570, 20, 20); //x, y, w, h
  rect(XpositionHouseO + 90, 570, 20, 20); //x, y, w, h
  
  //4th set of houses
  rect(XpositionHouse3 + 100, 600, 20, 20); //x, y, w, h
  rect(XpositionHouseD + 100, 600, 20, 20); //x, y, w, h
  rect(XpositionHouseJ + 100, 600, 20, 20); //x, y, w, h
  rect(XpositionHouseP + 100, 600, 20, 20); //x, y, w, h
  
  //5th set of houses
  rect(XpositionHouse4 + 90, 620, 20, 20); //x, y, w, h
  rect(XpositionHouseE + 90, 620, 20, 20); //x, y, w, h
  rect(XpositionHouseK + 90, 620, 20, 20); //x, y, w, h
  rect(XpositionHouseQ + 90, 620, 20, 20); //x, y, w, h
  
  //6th set of houses
  rect(XpositionHouse5 + 70, 570, 20, 20); //x, y, w, h
  rect(XpositionHouseF + 70, 570, 20, 20); //x, y, w, h
  rect(XpositionHouseL + 70, 570, 20, 20); //x, y, w, h
  rect(XpositionHouseR + 70, 570, 20, 20); //x, y, w, h
  
  //Extra sets of windows
  rect(XpositionHouse + 60, 620, 20, 20); //x, y, w, h
  rect(XpositionHouseA + 60, 620, 20, 20); //x, y, w, h
  rect(XpositionHouseG + 60, 620, 20, 20); //x, y, w, h
  rect(XpositionHouseM + 60, 620, 20, 20); //x, y, w, h
  
  rect(XpositionHouse + 60, 650, 20, 20); //x, y, w, h
  rect(XpositionHouseA + 60, 650, 20, 20); //x, y, w, h
  rect(XpositionHouseG + 60, 650, 20, 20); //x, y, w, h
  rect(XpositionHouseM + 60, 650, 20, 20); //x, y, w, h
  
  //2nd 
  rect(XpositionHouse1 + 50, 580, 20, 20); //x, y, w, h
  rect(XpositionHouseB + 50, 580, 20, 20); //x, y, w, h
  rect(XpositionHouseH + 50, 580, 20, 20); //x, y, w, h
  rect(XpositionHouseN + 50, 580, 20, 20); //x, y, w, h
  
  rect(XpositionHouse1 + 50, 610, 20, 20); //x, y, w, h
  rect(XpositionHouseB + 50, 610, 20, 20); //x, y, w, h
  rect(XpositionHouseH + 50, 610, 20, 20); //x, y, w, h
  rect(XpositionHouseN + 50, 610, 20, 20); //x, y, w, h
  
  rect(XpositionHouse1 + 80, 580, 20, 20); //x, y, w, h
  rect(XpositionHouseB + 80, 580, 20, 20); //x, y, w, h
  rect(XpositionHouseH + 80, 580, 20, 20); //x, y, w, h
  rect(XpositionHouseN + 80, 580, 20, 20); //x, y, w, h
  
  rect(XpositionHouse1 + 80, 610, 20, 20); //x, y, w, h
  rect(XpositionHouseB + 80, 610, 20, 20); //x, y, w, h
  rect(XpositionHouseH + 80, 610, 20, 20); //x, y, w, h
  rect(XpositionHouseN + 80, 610, 20, 20); //x, y, w, h
  
  //3rd 
  rect(XpositionHouse2 + 120, 600, 20, 20); //x, y, w, h
  rect(XpositionHouseC + 120, 600, 20, 20); //x, y, w, h
  rect(XpositionHouseI + 120, 600, 20, 20); //x, y, w, h
  rect(XpositionHouseO + 120, 600, 20, 20); //x, y, w, h

  rect(XpositionHouse2 + 120, 570, 20, 20); //x, y, w, h
  rect(XpositionHouseC + 120, 570, 20, 20); //x, y, w, h
  rect(XpositionHouseI + 120, 570, 20, 20); //x, y, w, h
  rect(XpositionHouseO + 120, 570, 20, 20); //x, y, w, h
  
  rect(XpositionHouse2 + 150, 600, 20, 20); //x, y, w, h
  rect(XpositionHouseC + 150, 600, 20, 20); //x, y, w, h
  rect(XpositionHouseI + 150, 600, 20, 20); //x, y, w, h
  rect(XpositionHouseO + 150, 600, 20, 20); //x, y, w, h

  rect(XpositionHouse2 + 150, 570, 20, 20); //x, y, w, h
  rect(XpositionHouseC + 150, 570, 20, 20); //x, y, w, h
  rect(XpositionHouseI + 150, 570, 20, 20); //x, y, w, h
  rect(XpositionHouseO + 150, 570, 20, 20); //x, y, w, h
}

//The glows + lights for gradient: Moon
void MoonGlow(float x, int y) {
  // Moon itself (center)
  fill(255, 255, 180);
  ellipse(x, y, 80, 80);

  // Layer 1: Glow
  fill(255, 255, 180, 80);
  ellipse(x, y, 120, 120); // Glow fades

  // Layer 2: Glow
  fill(255, 255, 180, 60);
  ellipse(x, y, 160, 160); // Glow fades 1

  // Layer 3: Glow
  fill(255, 255, 180, 40); //Glow fades 2
  ellipse(x, y, 200, 200);

  // Layer 4: Glow
  fill(255, 255, 180, 20); //Glow fades 3
  ellipse(x, y, 240, 240);
}

// Gradient
void drawGradient() {
  noStroke();

  // Layered gradient background
  fill(28, 31, 44);
  stroke(255);
  strokeWeight(0.7);
  line(0, 700, 800, 700); //x1, y1, x2, y2
  noStroke();
  rect(0, 0, width, 800);


  fill(101, 59, 255);
  rect(0, 0, width, 700);

  fill(72, 47, 253);
  rect(0, 0, width, 600);

  fill(51, 31, 253);
  rect(0, 0, width, 500);

  fill(33, 24, 239);
  rect(0, 0, width, 400);

  fill(32, 15, 192);
  rect(0, 0, width, 300);

  fill(27, 9, 169);
  rect(0, 0, width, 200);

  fill(17, 4, 120);
  rect(0, 0, width, 100);
}
