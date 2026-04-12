public enum Menu {
    NONE,
    UPGRADES,
    SETTINGS,
    DEBUG;
}
  
Menu menuOpen = Menu.NONE;
boolean menuOpeningAnimationInProgress = false;
float currentMenuSizeX = 0;
float currentMenuSizeY = 0;
float maxMenuSizeX;
float maxMenuSizeY;
float maxMenuSizeExtraPadding;
float menuCenterX;
float menuCenterY;
float menuTopRightCornerX;
float menuTopRightCornerY;
float menuXOutButtonSize;

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
      case DEBUG:
      drawDebugMenu();
        break;
      default:
        throw new IllegalStateException("Unexpected value: " + menuOpen);
    }
  
    drawMenuXButton();
  }
  
  void drawMenuXButton() {
    imageMode(CENTER);
    image(menuXOutButton, menuTopRightCornerX, menuTopRightCornerY, menuXOutButtonSize, menuXOutButtonSize);
  }
  
  void drawMenuBackground() {
    // increase menu size if we're in the middle of the opening animation
    if (menuOpeningAnimationInProgress) {
      currentMenuSizeX += (frameRate * 4);
      currentMenuSizeY += (frameRate * 4);
      if (currentMenuSizeX >= maxMenuSizeX) {
        currentMenuSizeX = maxMenuSizeX;
      }
      if (currentMenuSizeY >= maxMenuSizeY) {
        currentMenuSizeY = maxMenuSizeY;
      }
      if (currentMenuSizeX >= maxMenuSizeX && currentMenuSizeY >= maxMenuSizeY) {
        menuOpeningAnimationInProgress = false;
      }
    }
  
    imageMode(CENTER);
    image(menuBackground, menuCenterX, menuCenterY, currentMenuSizeX, currentMenuSizeY);
  }
  
  void checkForMenuClicks() {
    if (menuOpen != Menu.NONE) {
      // Check if the click is within the X-out button area
      if (mouseX >= menuTopRightCornerX - (menuXOutButtonSize / 2) && mouseX <= menuTopRightCornerX + (menuXOutButtonSize / 2) &&
          mouseY >= menuTopRightCornerY - (menuXOutButtonSize / 2) && mouseY <= menuTopRightCornerY + (menuXOutButtonSize / 2)) {
            closeMenu();
            return;
      }
      
      // Check for menu-specific clicks
      switch(menuOpen) {
        case UPGRADES:
          checkForUpgradeBuyClicks();
          break;
        case SETTINGS:
          checkForSettingCheckboxClicks();
          break;
        case DEBUG:
          checkForDebugMenuClicks();
          break;
        default:
          break;
      }
    }
  }

  void openMenu(Menu menuToOpen) {
    //maisyStopTalking(); // if Maisy was talking, stop her from talking as soon as we open a menu
    menuOpen = menuToOpen;
    menuOpeningAnimationInProgress = true;
    currentMenuSizeX = 0;
    currentMenuSizeY = 0;
  }
  
  void closeMenu() {
    menuOpen = Menu.NONE;
    menuOpeningAnimationInProgress = false;
    currentMenuSizeX = 0;
    currentMenuSizeY = 0;
  }