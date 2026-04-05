public enum Menu {
  NONE,
  UPGRADES;
}

Menu menuOpen = Menu.NONE;
boolean menuOpeningAnimationInProgress = false;
float currentMenuSize = 0;
float maxMenuSize;

float leftSideIconsTextSize;

float corner;
float farmCenter;
float screenCenter;
float halfCorner;

float menuTopRightCornerX;
float menuTopRightCornerY;
float menuXOutButtonSize;

void drawBackgroundUi() {
  background(255);

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

// anything that's rendered in front of rocks
void drawForegroundUi() {
  if (menuOpen != Menu.NONE) {
    drawMenu();
  }
}

void drawMenu() {
  drawMenuBackground();
  if (menuOpeningAnimationInProgress) return; // don't draw menu content until the menu is fully open

  switch(menuOpen) {
    case UPGRADES:
      drawUpgradesMenu();
      break;
    default:
      throw new IllegalStateException("Unexpected value: " + menuOpen);
  }

  drawMenuXButton();
}

void drawUpgradesMenu() {
  textSize(corner / 4);
  fill(0, 0, 0);
  textAlign(CENTER, TOP);
  text("upgrades coming soon!", screenCenter, height / 3);
}

void drawMenuXButton() {
  imageMode(CENTER);
  image(menuXOutButton, menuTopRightCornerX, menuTopRightCornerY, menuXOutButtonSize, menuXOutButtonSize);
}

void drawMenuBackground() {
  // increase menu size if we're in the middle of the opening animation
  if (menuOpeningAnimationInProgress) {
    currentMenuSize += (frameRate * 4);
    if (currentMenuSize >= maxMenuSize) {
      currentMenuSize = maxMenuSize;
      menuOpeningAnimationInProgress = false;
    }
  }

  imageMode(CENTER);
  image(menuBackground, screenCenter, screenCenter, currentMenuSize, currentMenuSize);
}

void checkForMenuClicks() {
  if (menuOpen == Menu.UPGRADES) {
    // Check if the click is within the X-out button area
    if (mouseX >= menuTopRightCornerX - (menuXOutButtonSize / 2) && mouseX <= menuTopRightCornerX + (menuXOutButtonSize / 2) &&
        mouseY >= menuTopRightCornerY - (menuXOutButtonSize / 2) && mouseY <= menuTopRightCornerY + (menuXOutButtonSize / 2)) {
          closeMenu();
    }
  }
}

void closeMenu() {
  menuOpen = Menu.NONE;
  menuOpeningAnimationInProgress = false;
  currentMenuSize = 0;
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
  return corner + halfCorner;
}

float upgradesButtonSize() {
  return corner * 0.8;
}

float iconsX() {
  return halfCorner;
}

void drawLeftSideIcons() {
  imageMode(CENTER);
  float iconsX = iconsX();
  float upgradesButtonY = upgradesButtonY();
  float upgradesButtonSize = upgradesButtonSize();
  animateDrawing(upgradesButton1, upgradesButton2, iconsX, upgradesButtonY, upgradesButtonSize, upgradesButtonSize, 500);
  textSize(leftSideIconsTextSize);
  textAlign(CENTER, CENTER);
  text("upgrades", iconsX, upgradesButtonY + (upgradesButtonSize / 2) + (leftSideIconsTextSize / 2));
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
  menuOpen = Menu.UPGRADES;
  menuOpeningAnimationInProgress = true;
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
  halfCorner = corner / 2;
  screenCenter = width / 2;
  farmCenter = (corner + width) / 2;
  defaultMaisyTextSize = corner / 5;
  maisyTextSize = defaultMaisyTextSize;
  leftSideIconsTextSize = corner / 5;
  maxMenuSize = width * 0.9;
  
  menuTopRightCornerX = screenCenter + (maxMenuSize / 2) - (halfCorner / 4);
  menuTopRightCornerY = screenCenter - (maxMenuSize / 2) + (halfCorner / 4);
  menuXOutButtonSize = corner / 2.5;
}

void setDrawOpacity(int opacity) {
  tint(255, opacity);
}
