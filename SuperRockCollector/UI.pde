float corner;
float farmCenter;
float screenCenter;
float halfCorner;

void drawBackgroundUi() {
  background(255);
  imageMode(CORNER);
  image(background, 0, 0, width, height);

  drawMaisy();
  
  drawLeftSideIcons();
}

// anything that's rendered in front of rocks
void drawForegroundUi() {
  if (menuOpen != Menu.NONE) {
    drawMenu();
  }

  textSize(corner / 4);
  String totalRocksText = int(totalRocks) + " rocks";
  fill(0, 0, 0);
  textAlign(LEFT, BASELINE);
  text(totalRocksText, corner / 6, corner / 4);
}

void animateDrawing(PImage img1, PImage img2, float imgX, float imgY, float imgSizeX, float imgSizeY, int millisBetweenChanges) {
  float elapsedTime = millis() / (float)millisBetweenChanges;
  int phase = (int)elapsedTime % 2;
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
  background(255);
  
  // Rotate at constant speed: 360 degrees per 2 seconds
  loadingSpinnerAngle = (millis() % 2000) / 2000.0 * TWO_PI;

  pushMatrix();
    translate(width/2, height/2);
    rotate(loadingSpinnerAngle);
    imageMode(CENTER);
    image(loadingSpinner, 0, 0, corner * 0.7, corner * 0.7);
  popMatrix();
}

void startSoundLoop(SoundFile sound) {
  sound.loop();
}

void setDrawOpacity(int opacity) {
  tint(255, opacity);
}

float getTextBlockHeight(String text, float textSize) {
  // Count the number of lines in description (newline characters + 1)
  int lineCount = text.split("\n").length;
  
  // Set text size to match what's used in the UI
  textSize(textSize);
  
  // Calculate height based on textAscent and textDescent
  float lineHeight = textAscent() + textDescent();
  
  // Add line spacing multiplier to account for padding between lines
  float lineSpacingMultiplier = 1.1;
  return lineCount * lineHeight * lineSpacingMultiplier;
}

void calculateScreenAreas() {
  corner = width / 5.94;
  halfCorner = corner / 2;
  screenCenter = width / 2;
  farmCenter = (corner + width) / 2;
  defaultMaisyTextSize = corner / 5;
  maisyTextSize = defaultMaisyTextSize;
  leftSideIconsTextSize = corner / 5;
  menuCenterX = screenCenter;
  menuCenterY = farmCenter;
  maxMenuSizeExtraPadding = corner / 7;
  maxMenuSizeX = width - maxMenuSizeExtraPadding;
  maxMenuSizeY = (width - corner) - maxMenuSizeExtraPadding;
  leftSideIconSize = corner * 0.8;
  upgradeDescriptionTextSize = corner / 7;
  
  // Calculate icon Y positions based on order
  leftSideIconYPositions = new float[iconOrder.length];
  float spacing = leftSideIconSize * 1.5;
  for (int i = 0; i < iconOrder.length; i++) {
    leftSideIconYPositions[i] = topLeftSideIconY() + (i * spacing);
  }
  
  menuTopRightCornerX = menuCenterX + (maxMenuSizeX / 2) - (halfCorner / 4);
  menuTopRightCornerY = menuCenterY - (maxMenuSizeY / 2) + (halfCorner / 4);
  menuXOutButtonSize = corner / 2.5;
}