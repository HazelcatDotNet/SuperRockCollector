float leftSideIconsTextSize;
float leftSideIconSize;
float[] leftSideIconYPositions;
float upgradeDescriptionTextSize;
String[] iconOrder = {"upgrades", "settings"};

float topLeftSideIconY() {
    return corner + halfCorner;
  }
  
  void drawLeftSideIcons() {
    if (menuOpen != Menu.NONE) return; // don't draw icons if a menu is open
  
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
            openMenu(Menu.UPGRADES);
            break;
          case "settings":
            openMenu(Menu.SETTINGS);
            break;
        }
      }
    }
  }