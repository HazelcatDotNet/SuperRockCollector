public enum Menu {
  NONE,
  UPGRADES,
  SETTINGS;
}

Menu menuOpen = Menu.NONE;
boolean menuOpeningAnimationInProgress = false;
float currentMenuSize = 0;
float maxMenuSize;

float leftSideIconsTextSize;
float leftSideIconSize;
float[] leftSideIconYPositions;
String[] iconOrder = {"upgrades", "settings"};

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
    case SETTINGS:
      drawSettingsMenu();
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

void drawSettingsMenu() {
  textSize(corner / 4);
  fill(0, 0, 0);
  textAlign(CENTER, TOP);
  text("settings coming soon!", screenCenter, height / 3);
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
  if (menuOpen != Menu.NONE) {
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

float topLeftSideIconY() {
  return corner + halfCorner;
}

void drawLeftSideIcons() {
  imageMode(CENTER);
  float iconsX = halfCorner;
  int animationSpeed = 500; // milliseconds between animation changes
  
  textSize(leftSideIconsTextSize);
  textAlign(CENTER, CENTER);
  
  for (int i = 0; i < iconOrder.length; i++) {
    float iconY = leftSideIconYPositions[i];
    String label = iconOrder[i];
    
    // Draw the appropriate button pair
    switch(label) {
      case "upgrades":
        animateDrawing(upgradesButton1, upgradesButton2, iconsX, iconY, leftSideIconSize, leftSideIconSize, animationSpeed);
        break;
      case "settings":
        animateDrawing(settingsButton1, settingsButton2, iconsX, iconY, leftSideIconSize, leftSideIconSize, animationSpeed);
        break;
    }
    
    // Draw the label
    text(label, iconsX, iconY + (leftSideIconSize / 2) + (leftSideIconsTextSize / 2));
  }
}

void checkForLeftSideIconClicks() {
  float iconsX = halfCorner;
  float halfIconSize = leftSideIconSize / 2;
  
  for (int i = 0; i < iconOrder.length; i++) {
    float iconY = leftSideIconYPositions[i];
    String label = iconOrder[i];
    
    if (mouseX >= iconsX - halfIconSize && mouseX <= iconsX + halfIconSize &&
        mouseY >= iconY - halfIconSize && mouseY <= iconY + halfIconSize) {
      
      switch(label) {
        case "upgrades":
          menuOpen = Menu.UPGRADES;
          break;
        case "settings":
          menuOpen = Menu.SETTINGS;
          break;
      }

      menuOpeningAnimationInProgress = true;
    }
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

void calculateScreenAreas() {
  corner = width / 5.94;
  halfCorner = corner / 2;
  screenCenter = width / 2;
  farmCenter = (corner + width) / 2;
  defaultMaisyTextSize = corner / 5;
  maisyTextSize = defaultMaisyTextSize;
  leftSideIconsTextSize = corner / 5;
  maxMenuSize = width * 0.9;
  leftSideIconSize = corner * 0.8;
  
  // Calculate icon Y positions based on order
  leftSideIconYPositions = new float[iconOrder.length];
  float spacing = leftSideIconSize * 1.5;
  for (int i = 0; i < iconOrder.length; i++) {
    leftSideIconYPositions[i] = topLeftSideIconY() + (i * spacing);
  }
  
  menuTopRightCornerX = screenCenter + (maxMenuSize / 2) - (halfCorner / 4);
  menuTopRightCornerY = screenCenter - (maxMenuSize / 2) + (halfCorner / 4);
  menuXOutButtonSize = corner / 2.5;
}

void setDrawOpacity(int opacity) {
  tint(255, opacity);
}
