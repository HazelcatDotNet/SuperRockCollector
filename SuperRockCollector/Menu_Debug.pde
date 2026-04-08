float debugAddRocksButtonX;
float debugAddRocksButtonY;
float debugAddRocksButtonSize;

void drawDebugMenu() {
  fill(0, 0, 0);
  textAlign(CENTER, CENTER);
  
  float horizontalPadding = corner / 3;
  float verticalPadding = corner / 3;
  float buttonSize = corner * 0.4;
  
  float startX = screenCenter - (maxMenuSize / 2) + horizontalPadding + buttonSize / 2;
  float startY = screenCenter - (maxMenuSize / 2) + verticalPadding + buttonSize / 2;
  
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

void checkForDebugMenuClicks() {
  float halfButtonSize = debugAddRocksButtonSize / 2;
  
  // Check if "Add 1000 Rocks" button was clicked
  if (mouseX >= debugAddRocksButtonX - halfButtonSize && mouseX <= debugAddRocksButtonX + halfButtonSize &&
      mouseY >= debugAddRocksButtonY - halfButtonSize && mouseY <= debugAddRocksButtonY + halfButtonSize) {
    totalRocks += 1000;
  }
}