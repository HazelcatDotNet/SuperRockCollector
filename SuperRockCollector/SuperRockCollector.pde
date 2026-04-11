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
  
  loadUpgrades();
  loadData();
  
  loadEndTime = millis() + 1500;
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
  startSoundLoop(mainThemeSong);
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

void keyPressed() {
  if (key == 'd') {
    openMenu(Menu.DEBUG);
  } else if (key == 's') {
    spawnRock(rollRockType());
  } else if (key == 'h') {
    triggerJeffHaul();
  }
}

// calculates random events per second. this check assumes it is run every frame
// e.g. with parameters 1 in 10, this will give a 1 in 10 chance every second
boolean xChanceInYSeconds(int x, int y) {
  if (millis() - lastXinYCheck >= 1000) {
    lastXinYCheck = millis();
    return runChance((float) x / y);
  }
  return false;
}

// like split(), but only splits on the first instance of the delimiter
String[] splitFirst(String text, String delimiter) {
  int index = text.indexOf(delimiter);

  if (index == -1) {
    return new String[] { text };
  }

  String left = text.substring(0, index);
  String right = text.substring(index + delimiter.length());

  return new String[] { left, right };
}

boolean intervalMs(int numMillis) {
  int intervalFrames = int((numMillis / 1000.0) * frameRate);
  if (frameCount % intervalFrames == 0) return true;
  return false;
}

// runs a dice roll. e.g., with a proportionChance of 0.3, there is a 30% chance of returning true
boolean runChance(float proportionChance) {
  return random(1) < proportionChance;
}