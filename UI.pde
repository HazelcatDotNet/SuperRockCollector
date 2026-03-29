void drawUi() {
  imageMode(CORNER);
  image(background, 0, 0, width, height);
  
  drawMaisy();

  textSize(corner / 3);
  textAlign(LEFT);
  String totalRocksText = int(totalRocks) + "\nrocks";
  fill(0, 0, 0);
  text(totalRocksText, corner / 3, corner / 3);
  // circle(corner, corner, 5);
}

void loadUiImages() {
  background = loadImage("data/art/background.png");
  maisy1 = loadImage("data/art/maisy1.png");
  maisy2 = loadImage("data/art/maisy2.png");
}

void drawMaisy() {
  int phase = (millis() / 500) % 2;
  PImage maisyImage = (phase == 0) ? maisy1 : maisy2;

  imageMode(CENTER);
  image(maisyImage, screenSize / 2, corner / 2, corner, corner);
}

// returns whether or not the mouse is on the maisy box
boolean mouseOnMaisy() {
  float centerX = screenSize / 2;
  float centerY = corner / 2;
  float halfSize = corner / 2;
  
  if (mouseX >= centerX - halfSize && mouseX <= centerX + halfSize &&
      mouseY >= centerY - halfSize && mouseY <= centerY + halfSize) {
        return true;
  }
  
  return false;
}
