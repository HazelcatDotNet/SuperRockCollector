float debugAddRocksButtonX;
float debugAddRocksButtonY;
float debugAddRocksButtonSize;

float debugResetUpgradesButtonX;
float debugResetUpgradesButtonY;
float debugResetUpgradesButtonSize;

float debugClearRocksButtonX;
float debugClearRocksButtonY;
float debugClearRocksButtonSize;

float debugSetZeroRocksButtonX;
float debugSetZeroRocksButtonY;
float debugSetZeroRocksButtonSize;

void drawDebugMenu() {
  fill(0, 0, 0);
  textAlign(CENTER, CENTER);
  
  float horizontalPadding = corner / 3;
  float verticalPadding = corner / 3;
  float buttonSize = corner * 0.4;
  
  float startX = menuCenterX - (maxMenuSizeX / 2) + horizontalPadding + buttonSize / 2;
  float startY = menuCenterY - (maxMenuSizeY / 2) + verticalPadding + buttonSize / 2;
  
  drawAddRocksButton(startX, startY, buttonSize);
  drawResetUpgradesButton(startX + buttonSize * 1.5, startY, buttonSize);
  drawClearRocksButton(startX + buttonSize * 3, startY, buttonSize);
  drawSetZeroRocksButton(startX + buttonSize * 4.5, startY, buttonSize);
}

void drawDebugButton(float x, float y, float size, String text) {
  fill(200);
  stroke(0);
  strokeWeight(2);
  rectMode(CENTER);
  rect(x, y, size, size);
  
  fill(0, 0, 0);
  textSize(corner / 7);
  text(text, x, y);
}

void drawAddRocksButton(float startX, float startY, float buttonSize) {
  debugAddRocksButtonX = startX;
  debugAddRocksButtonY = startY;
  debugAddRocksButtonSize = buttonSize;
  
  drawDebugButton(startX, startY, buttonSize, "+1000\nrocks");
}

void drawResetUpgradesButton(float posX, float posY, float buttonSize) {
  debugResetUpgradesButtonX = posX;
  debugResetUpgradesButtonY = posY;
  debugResetUpgradesButtonSize = buttonSize;
  
  drawDebugButton(posX, posY, buttonSize, "reset\nupgrds");
}

void drawClearRocksButton(float posX, float posY, float buttonSize) {
  debugClearRocksButtonX = posX;
  debugClearRocksButtonY = posY;
  debugClearRocksButtonSize = buttonSize;

  drawDebugButton(posX, posY, buttonSize, "clear\nrocks");
}

void drawSetZeroRocksButton(float posX, float posY, float buttonSize) {
  debugSetZeroRocksButtonX = posX;
  debugSetZeroRocksButtonY = posY;
  debugSetZeroRocksButtonSize = buttonSize;

  drawDebugButton(posX, posY, buttonSize, "0\nrocks");
}

void checkForDebugMenuClicks() {
  float halfAddRocksButtonSize = debugAddRocksButtonSize / 2;
  
  // Check if "Add 1000 Rocks" button was clicked
  if (mouseX >= debugAddRocksButtonX - halfAddRocksButtonSize && mouseX <= debugAddRocksButtonX + halfAddRocksButtonSize &&
      mouseY >= debugAddRocksButtonY - halfAddRocksButtonSize && mouseY <= debugAddRocksButtonY + halfAddRocksButtonSize) {
    totalRocks += 1000;
    println("DEBUG: Added 1000 rocks. Total now: " + totalRocks);
  }
  
  float halfResetUpgradesButtonSize = debugResetUpgradesButtonSize / 2;
  
  // Check if "Reset Upgrades" button was clicked
  if (mouseX >= debugResetUpgradesButtonX - halfResetUpgradesButtonSize && mouseX <= debugResetUpgradesButtonX + halfResetUpgradesButtonSize &&
      mouseY >= debugResetUpgradesButtonY - halfResetUpgradesButtonSize && mouseY <= debugResetUpgradesButtonY + halfResetUpgradesButtonSize) {
    resetAllUpgrades();
    println("DEBUG: Reset all upgrades.");
  }
  
  float halfClearRocksButtonSize = debugClearRocksButtonSize / 2;
  
  // Check if "Clear Rocks" button was clicked
  if (mouseX >= debugClearRocksButtonX - halfClearRocksButtonSize && mouseX <= debugClearRocksButtonX + halfClearRocksButtonSize &&
      mouseY >= debugClearRocksButtonY - halfClearRocksButtonSize && mouseY <= debugClearRocksButtonY + halfClearRocksButtonSize) {
    rocks.clear();
    println("DEBUG: Cleared all rocks.");
  }
  
  float halfSetZeroRocksButtonSize = debugSetZeroRocksButtonSize / 2;
  
  // Check if "Set to 0 Rocks" button was clicked
  if (mouseX >= debugSetZeroRocksButtonX - halfSetZeroRocksButtonSize && mouseX <= debugSetZeroRocksButtonX + halfSetZeroRocksButtonSize &&
      mouseY >= debugSetZeroRocksButtonY - halfSetZeroRocksButtonSize && mouseY <= debugSetZeroRocksButtonY + halfSetZeroRocksButtonSize) {
    totalRocks = 0;
    println("DEBUG: Set totalRocks to 0.");
  }
}

void resetAllUpgrades() {
  for (int i = 0; i < upgrades.size(); i++) {
    upgrades.get(i).hasPurchased = false;
    upgrades.get(i).isToggledOn = false;
  }

  populateUpgradeLists();
}