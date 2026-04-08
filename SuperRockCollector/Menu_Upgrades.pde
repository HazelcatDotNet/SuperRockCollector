// Helper class to track buy button positions and associated upgrade
class BuyButtonInfo {
  String upgradeKey;
  float x;
  float y;
  float size;
  
  BuyButtonInfo(String upgradeKey, float x, float y, float size) {
    this.upgradeKey = upgradeKey;
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  boolean isClicked(float clickX, float clickY) {
    float halfSize = size / 2;
    return clickX >= x - halfSize && clickX <= x + halfSize &&
           clickY >= y - halfSize && clickY <= y + halfSize;
  }
}

ArrayList<BuyButtonInfo> buyButtons = new ArrayList<BuyButtonInfo>();

void drawUpgradesMenu() {
  fill(0, 0, 0);
  textAlign(LEFT, TOP);
  
  float horizontalPadding = corner / 3;
  float verticalPadding = corner / 3;
  float betweenUpgradesPadding = corner / 4;
  float imageSize = corner * 0.60;
  float imagePadding = corner / 6;
  int animationSpeed = 500; // milliseconds between animation changes
  
  float startX = screenCenter - (maxMenuSize / 2) + horizontalPadding;
  float startY = screenCenter - (maxMenuSize / 2) + verticalPadding;
  
  float currentY = startY;
  buyButtons.clear(); // Clear previous button data
  
  for (int i = 0; i < unpurchasedUpgradesOrder.length; i++) {
    String upgradeKey = unpurchasedUpgradesOrder[i];
    Upgrade upgrade = upgradesByKey.get(upgradeKey);
    
    if (upgrade != null) {
      currentY = drawUpgradeItem(upgrade, upgradeKey, startX, currentY, imageSize, imagePadding, 
                                  betweenUpgradesPadding, animationSpeed);
    }
  }
}

// Helper function to draw a single upgrade item and track its buy button position
// Returns the Y position for the next item
float drawUpgradeItem(Upgrade upgrade, String upgradeKey, float startX, float currentY, 
                       float imageSize, float imagePadding, float betweenUpgradesPadding, 
                       int animationSpeed) {
  // Draw upgrade image
  float imageX = startX + imageSize / 2;
  float imageY = currentY + imageSize / 2;
  animateDrawing(upgrade.image1, upgrade.image2, imageX, imageY, imageSize, imageSize, animationSpeed);
  
  // Draw upgrade name
  float textX = startX + imageSize + imagePadding;
  float textY = currentY;
  textSize(corner / 5);
  fill(0, 0, 0);
  text(upgrade.name, textX, textY);
  float nameHeight = (corner / 5) * 1.2;
  
  // Draw cost
  textSize(corner / 6);
  float costY = textY + nameHeight;
  text("cost: " + upgrade.cost + " rocks", textX, costY);
  float costHeight = (corner / 6) * 1.2;
  
  // Draw description
  textSize(upgradeDescriptionTextSize);
  float descY = costY + costHeight;
  text(upgrade.description, textX, descY);

  // Draw buy button and track its position
  float buttonSize = corner * 0.45;
  float buttonX = (width - imageX);
  animateDrawing(buyButton1, buyButton2, buttonX, imageY, buttonSize, buttonSize, animationSpeed);
  
  // Store button info for click detection
  buyButtons.add(new BuyButtonInfo(upgradeKey, buttonX, imageY, buttonSize));
  
  // Calculate height for next item
  float totalTextHeight = nameHeight + costHeight + upgrade.descriptionHeight + betweenUpgradesPadding;
  float itemHeight = max(imageSize, totalTextHeight);
  
  return currentY + itemHeight;
}
