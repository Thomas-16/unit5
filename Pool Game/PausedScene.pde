void PausedDraw() {
  fill(0);
  textSize(160);
  text("Paused", width/2, height/2);
}

void PausedKeyPressed() {
  if (key == ' ' && areBallsStill() && !shooting) {
    charging = true;
    charge = 0;
    pull = 0;
  }
  if(key == TAB) {
    mode = GAME;
  }
}
