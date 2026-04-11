float debugAdd100RocksButtonX;
float debugAdd100RocksButtonY;
float debugAdd100RocksButtonSize;

float debugAddRocksButtonX;
float debugAddRocksButtonY;
float debugAddRocksButtonSize;

float debugAdd10kRocksButtonX;
float debugAdd10kRocksButtonY;
float debugAdd10kRocksButtonSize;

float debugResetUpgradesButtonX;
float debugResetUpgradesButtonY;
float debugResetUpgradesButtonSize;

float debugClearRocksButtonX;
float debugClearRocksButtonY;
float debugClearRocksButtonSize;

float debugSetZeroRocksButtonX;
float debugSetZeroRocksButtonY;
float debugSetZeroRocksButtonSize;

float debugToggleHitboxButtonX;
float debugToggleHitboxButtonY;
float debugToggleHitboxButtonSize;

void drawDebugMenu() {
  fill(0, 0, 0);
  textAlign(CENTER, CENTER);
  
  float horizontalPadding = corner / 3;
  float verticalPadding = corner / 3;
  float buttonSize = corner * 0.4;
  
  float startX = menuCenterX - (maxMenuSizeX / 2) + horizontalPadding + buttonSize / 2;
  float startY = menuCenterY - (maxMenuSizeY / 2) + verticalPadding + buttonSize / 2;
  
  drawAdd100RocksButton(startX, startY, buttonSize);
  drawAddRocksButton(startX + buttonSize * 1.5, startY, buttonSize);
  drawAdd10kRocksButton(startX + buttonSize * 3, startY, buttonSize);
  drawResetUpgradesButton(startX + buttonSize * 4.5, startY, buttonSize);
  drawClearRocksButton(startX + buttonSize * 6, startY, buttonSize);
  drawSetZeroRocksButton(startX + buttonSize * 7.5, startY, buttonSize);
  drawToggleHitboxButton(startX + buttonSize * 9, startY, buttonSize);
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

void drawAdd100RocksButton(float startX, float startY, float buttonSize) {
  debugAdd100RocksButtonX = startX;
  debugAdd100RocksButtonY = startY;
  debugAdd100RocksButtonSize = buttonSize;
  
  drawDebugButton(startX, startY, buttonSize, "+100\nrocks");
}

void drawAddRocksButton(float startX, float startY, float buttonSize) {
  debugAddRocksButtonX = startX;
  debugAddRocksButtonY = startY;
  debugAddRocksButtonSize = buttonSize;
  
  drawDebugButton(startX, startY, buttonSize, "+1000\nrocks");
}

void drawAdd10kRocksButton(float startX, float startY, float buttonSize) {
  debugAdd10kRocksButtonX = startX;
  debugAdd10kRocksButtonY = startY;
  debugAdd10kRocksButtonSize = buttonSize;
  
  drawDebugButton(startX, startY, buttonSize, "+10k\nrocks");
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

void drawToggleHitboxButton(float posX, float posY, float buttonSize) {
  debugToggleHitboxButtonX = posX;
  debugToggleHitboxButtonY = posY;
  debugToggleHitboxButtonSize = buttonSize;
  
  drawDebugButton(posX, posY, buttonSize, showRockHaulHitboxDebug ? "hide\nhitbox" : "show\nhitbox");
}

void checkForDebugMenuClicks() {
  float halfAdd100RocksButtonSize = debugAdd100RocksButtonSize / 2;
  
  // Check if "Add 100 Rocks" button was clicked
  if (mouseX >= debugAdd100RocksButtonX - halfAdd100RocksButtonSize && mouseX <= debugAdd100RocksButtonX + halfAdd100RocksButtonSize &&
      mouseY >= debugAdd100RocksButtonY - halfAdd100RocksButtonSize && mouseY <= debugAdd100RocksButtonY + halfAdd100RocksButtonSize) {
    totalRocks += 100;
    println("DEBUG: Added 100 rocks. Total now: " + totalRocks);
  }
  
  float halfAddRocksButtonSize = debugAddRocksButtonSize / 2;
  
  // Check if "Add 1000 Rocks" button was clicked
  if (mouseX >= debugAddRocksButtonX - halfAddRocksButtonSize && mouseX <= debugAddRocksButtonX + halfAddRocksButtonSize &&
      mouseY >= debugAddRocksButtonY - halfAddRocksButtonSize && mouseY <= debugAddRocksButtonY + halfAddRocksButtonSize) {
    totalRocks += 1000;
    println("DEBUG: Added 1000 rocks. Total now: " + totalRocks);
  }
  
  float halfAdd10kRocksButtonSize = debugAdd10kRocksButtonSize / 2;
  
  // Check if "Add 10k Rocks" button was clicked
  if (mouseX >= debugAdd10kRocksButtonX - halfAdd10kRocksButtonSize && mouseX <= debugAdd10kRocksButtonX + halfAdd10kRocksButtonSize &&
      mouseY >= debugAdd10kRocksButtonY - halfAdd10kRocksButtonSize && mouseY <= debugAdd10kRocksButtonY + halfAdd10kRocksButtonSize) {
    totalRocks += 10000;
    println("DEBUG: Added 10000 rocks. Total now: " + totalRocks);
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
  
  float halfToggleHitboxButtonSize = debugToggleHitboxButtonSize / 2;
  
  // Check if "Toggle Hitbox" button was clicked
  if (mouseX >= debugToggleHitboxButtonX - halfToggleHitboxButtonSize && mouseX <= debugToggleHitboxButtonX + halfToggleHitboxButtonSize &&
      mouseY >= debugToggleHitboxButtonY - halfToggleHitboxButtonSize && mouseY <= debugToggleHitboxButtonY + halfToggleHitboxButtonSize) {
    showRockHaulHitboxDebug = !showRockHaulHitboxDebug;
    println("DEBUG: Hitbox debug toggled to " + showRockHaulHitboxDebug);
  }
}

void resetAllUpgrades() {
  for (int i = 0; i < upgrades.size(); i++) {
    upgrades.get(i).hasPurchased = false;
    upgrades.get(i).isToggledOn = false;
  }

  populateUpgradeLists();
}