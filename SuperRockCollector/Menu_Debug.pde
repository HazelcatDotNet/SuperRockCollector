float debugAddRocksButtonX;
float debugAddRocksButtonY;
float debugAddRocksButtonSize;

float debugResetUpgradesButtonX;
float debugResetUpgradesButtonY;
float debugResetUpgradesButtonSize;

void drawDebugMenu() {
  fill(0, 0, 0);
  textAlign(CENTER, CENTER);
  
  float horizontalPadding = corner / 3;
  float verticalPadding = corner / 3;
  float buttonSize = corner * 0.4;
  
  float startX = screenCenter - (maxMenuSize / 2) + horizontalPadding + buttonSize / 2;
  float startY = screenCenter - (maxMenuSize / 2) + verticalPadding + buttonSize / 2;
  
  drawAddRocksButton(startX, startY, buttonSize);
  drawResetUpgradesButton(startX + buttonSize * 1.5, startY, buttonSize);
}

void drawAddRocksButton(float startX, float startY, float buttonSize) {
  // Draw "Add 1000 Rocks" button
  debugAddRocksButtonX = startX;
  debugAddRocksButtonY = startY;
  debugAddRocksButtonSize = buttonSize;
  
  fill(200);
  stroke(0);
  strokeWeight(2);
  rectMode(CENTER);
  rect(debugAddRocksButtonX, debugAddRocksButtonY, buttonSize, buttonSize);
  
  // Draw button text
  fill(0, 0, 0);
  textSize(corner / 6);
  text("+1000", debugAddRocksButtonX, debugAddRocksButtonY);
}

void drawResetUpgradesButton(float posX, float posY, float buttonSize) {
  // Draw "Reset Upgrades" button
  debugResetUpgradesButtonX = posX;
  debugResetUpgradesButtonY = posY;
  debugResetUpgradesButtonSize = buttonSize;
  
  fill(200);
  stroke(0);
  strokeWeight(2);
  rectMode(CENTER);
  rect(debugResetUpgradesButtonX, debugResetUpgradesButtonY, buttonSize, buttonSize);
  
  // Draw button text
  fill(0, 0, 0);
  textSize(corner / 6);
  text("RESET", debugResetUpgradesButtonX, debugResetUpgradesButtonY - corner / 20);
  textSize(corner / 8);
  text("UP", debugResetUpgradesButtonX, debugResetUpgradesButtonY + corner / 20);
}

void resetAllUpgrades() {
  for (int i = 0; i < upgrades.size(); i++) {
    upgrades.get(i).hasPurchased = false;
    upgrades.get(i).isToggledOn = false;
  }

  populateUpgradeLists();
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
}