import processing.sound.*;
import java.util.*;

void setup() {  
  size(800, 800);
  loaded = false;
  
  loadLoadingSpinner();
  
  maisyPokeLines = loadStrings(dataPath("maisy-poke-lines.txt"));
  maisyLastNames = loadStrings(dataPath("maisy-last-names.txt"));
  loadSounds();
  loadUiImages();
  loadRockImages();
  
  // Automatically save when the window is closed
  attachAutoSave();
  
  loadSettings();
  loadUpgrades();
  loadData();
  
  loadEndTime = millis() + 1500;
  if (playerEditedTotalRocksInSave) maisyStartTalking("y'know, something seems off about your total rock count... hm... / it's probably nothing, i think i'm just hallucinating again.");
}

void draw() {
  if (loaded) {
    drawBackgroundUi();
    if (menuOpen == Menu.NONE) {
      incrementRocks();
    }
    drawForegroundUi();
    attemptToSpawnRocks();
    checkForJeffHaul();
  } else {
    displayLoadingScreen();
    if (millis() >= loadEndTime) {
      onGameLoad();
    }
  }

  oncePerSecond();
}

void oncePerSecond() {
  if (millis() - lastSecondTime >= 1000) {
    lastSecondTime = millis();

    // everything below this comment will run once per second
    //println(frameRate);
  }
}

void onGameLoad() {
  loaded = true;
  millisSinceLastSave = millis();
  if ((Boolean)playMusicSetting.value) {
    startSoundLoop(mainThemeSong);
  }
}

void mousePressed() {
  if (menuOpen == Menu.NONE) {
    checkForRockClicks();
    checkForMaisyClick();
    checkForLeftSideIconClicks();
    checkForRockHaulClicks();
  } else if (!menuOpeningAnimationInProgress) {
    checkForMenuClicks();
  }
}

void mouseReleased() {
  if (!holdingObject) return;

  if (objectHeldByMouse instanceof BalloonRock) {
    BalloonRock balloonRock = (BalloonRock) objectHeldByMouse;
    balloonRock.onRelease();
  }
}

void keyPressed() {
  if (key == 'd') {
    openMenu(Menu.DEBUG);
  } else if (key == 's') {
    spawnRock(RockType.BALLOON);
  } else if (key == 'h') {
    triggerJeffHaul();
  }
}