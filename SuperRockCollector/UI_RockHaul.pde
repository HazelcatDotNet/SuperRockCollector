PImage currentRockHaulVariant;
boolean jeffHaulAnimationInProgress = false;
boolean jeffHaulWaitingForPickup;
boolean showRockHaulHitboxDebug = false;

float rockHaulX;
float rockHaulCurrentY;
float rockHaulTargetY;
float rockHaulImageSize;
float rockHaulCurrentRotation = 0;
float rockHaulTargetRotation = 0;
int rockHaulRotationDirection = 1;  // 1 for clockwise, -1 for counterclockwise

void drawExtraUi() {
    drawRockHaul();
}

void setRandomRockHaulVariant() {
    currentRockHaulVariant = rockHaulVariants[int(random(rockHaulVariants.length))];
}

void drawRockHaul() {
    if (jeffHaulAnimationInProgress) {
        rockHaulCurrentY = lerp(rockHaulCurrentY, rockHaulTargetY, 0.1);
        rockHaulCurrentRotation = lerp(rockHaulCurrentRotation, rockHaulTargetRotation, 0.1);

        // if rockHaulCurrentY is within a pixel of rockHaulTargetY, snap to target
        if (abs(rockHaulCurrentY - rockHaulTargetY) < 1.0) {
            rockHaulCurrentY = rockHaulTargetY;
            jeffHaulWaitingForPickup = true;
            jeffHaulAnimationInProgress = false;
        }
    }

    if (!isJeffHaulOnScreen()) return;
    if (currentRockHaulVariant == null) setRandomRockHaulVariant();
    
    imageMode(CENTER);
    pushMatrix();
    translate(rockHaulX, rockHaulCurrentY);
    rotate(rockHaulCurrentRotation);
    image(currentRockHaulVariant, 0, 0, rockHaulImageSize, rockHaulImageSize);
    popMatrix();
    
    if (showRockHaulHitboxDebug) drawRockHaulHitboxDebug();
}

boolean isJeffHaulOnScreen() {
    return jeffHaulAnimationInProgress || jeffHaulWaitingForPickup;
}

void checkForRockHaulClicks() {
    if (!isJeffHaulOnScreen()) return;
    if (isMouseOverRockHaul()) {
        collectRockHaul();
    }
}

boolean isMouseOverRockHaul() {
    if (currentRockHaulVariant == null) return false;
    float rockHaulLeft = rockHaulX - (rockHaulImageSize / 2);
    float rockHaulRight = rockHaulX + (rockHaulImageSize / 2);
    float rockHaulTop = rockHaulCurrentY - (rockHaulImageSize / 2);
    float rockHaulBottom = rockHaulCurrentY + (rockHaulImageSize / 2);
    return mouseX >= rockHaulLeft && mouseX <= rockHaulRight && mouseY >= rockHaulTop && mouseY <= rockHaulBottom;
}

void resetRockHaulCurrentY() {
    rockHaulCurrentY = -rockHaulImageSize;
}

void drawRockHaulHitboxDebug() {
    if (currentRockHaulVariant == null) return;
    float rockHaulLeft = rockHaulX - (rockHaulImageSize / 2);
    float rockHaulRight = rockHaulX + (rockHaulImageSize / 2);
    float rockHaulTop = rockHaulCurrentY - (rockHaulImageSize / 2);
    float rockHaulBottom = rockHaulCurrentY + (rockHaulImageSize / 2);
    
    noFill();
    stroke(0, 255, 0);
    strokeWeight(2);
    rectMode(CORNERS);
    rect(rockHaulLeft, rockHaulTop, rockHaulRight, rockHaulBottom);
}