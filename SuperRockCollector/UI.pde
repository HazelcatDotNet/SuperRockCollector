boolean menuOpen = false;

void drawUi() {
  imageMode(CORNER);
  image(background, 0, 0, width, height);

  drawMaisy();

  textSize(corner / 3);
  String totalRocksText = int(totalRocks) + " rocks";
  fill(0, 0, 0);
  textAlign(LEFT, BASELINE);
  text(totalRocksText, corner / 6, corner / 2.5);
  
  drawLeftSideIcons();
}

void animateDrawing(PImage img1, PImage img2, float imgX, float imgY, float imgSizeX, float imgSizeY, int millisBetweenChanges) {
  int phase = (millis() / millisBetweenChanges) % 2;
  PImage imgToDraw = (phase == 0) ? img1 : img2;

  imageMode(CENTER);
  image(imgToDraw, imgX, imgY, imgSizeX, imgSizeY);
}

void loadRockImages() {
  for (int i = 0; i < rockFileNames.length; i++) {
    String rockFileName = rockFileNames[i];
    String filePath = dataPath("art/rocks") + "\\" + rockFileName + ".png";
    rockImages.put(rockFileName, loadImage(filePath));
  }
}

float upgradesButtonY() {
  return corner + corner / 2;
}

float upgradesButtonSize() {
  return corner * 0.8;
}

float iconsX() {
  return corner / 2;
}

void drawLeftSideIcons() {
  imageMode(CENTER);
  float iconsX = iconsX();
  float upgradesButtonY = upgradesButtonY();
  float upgradesButtonSize = upgradesButtonSize();
  animateDrawing(upgradesButton1, upgradesButton2, iconsX, upgradesButtonY, upgradesButtonSize, upgradesButtonSize, 500);
  textSize(leftSideIconsTextSize);
  textAlign(CENTER, CENTER);
  text("upgrades", iconsX, upgradesButtonY + upgradesButtonSize / 2 + leftSideIconsTextSize / 2);
}

void checkForLeftSideIconClicks() {
  float iconsX = iconsX();
  float upgradesButtonY = upgradesButtonY();
  float upgradesButtonSize = upgradesButtonSize();
  
  // Check if the click is within the upgrades button area
  float halfUpgradesButtonSize = upgradesButtonSize / 2;
  if (mouseX >= iconsX - halfUpgradesButtonSize && mouseX <= iconsX + halfUpgradesButtonSize &&
      mouseY >= upgradesButtonY - halfUpgradesButtonSize && mouseY <= upgradesButtonY + halfUpgradesButtonSize) {
        openUpgradesMenu();
  }
}

void openUpgradesMenu() {
  println("Opening upgrades menu...");
}

String wrapText(String text, int maxCharCount) {
  String[] words = split(text, ' ');
  String result = "";
  String line = "";

  for (int i = 0; i < words.length; i++) {
    String word = words[i];

    // If adding this word exceeds the limit, wrap
    if (line.length() + word.length() + 1 > maxCharCount) {
      result += line + "\n";
      line = word;
    } else {
      if (line.length() > 0) line += " ";
      line += word;
    }
  }

  // Add last line
  result += line;

  return result;
}

void displayLoadingScreen() {
  pushMatrix();
    translate(width/2, height/2);
    rotate(loadingSpinnerAngle);
    imageMode(CENTER);
    image(loadingSpinner, 0, 0, corner * 0.7, corner * 0.7);
  popMatrix();
  
  loadingSpinnerAngle += 0.1;
}

void startSoundLoop(SoundFile sound) {
  sound.loop();
}

void calculateScreenAreas() {
  corner = width / 5.94;
  farmCenter = (corner + width) / 2;
  defaultMaisyTextSize = corner / 5;
  maisyTextSize = defaultMaisyTextSize;
  leftSideIconsTextSize = corner / 5;
}

void setDrawOpacity(int opacity) {
  tint(255, opacity);
}
