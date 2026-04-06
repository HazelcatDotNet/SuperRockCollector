import java.util.ArrayList;
import java.util.Arrays;
import java.util.Random;
import java.util.Iterator;
import java.util.Dictionary;
import java.util.Enumeration;
import java.util.Hashtable;
import processing.sound.*;

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
  
  loadData();
  
  loadEndTime = millis() + 1500;
}

void draw() {
  if (loaded) {
    // display background & increment rocks if menu is closed or animation is in progress
    if (menuOpen == Menu.NONE || menuOpeningAnimationInProgress) {
      drawBackgroundUi();
      incrementRocks();
    }
    drawForegroundUi();
    attemptToSpawnRocks();
    //drawMaisyHexagonHitbox();
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
  startSoundLoop(mainThemeSong);
}

void mousePressed() {
  if (menuOpen == Menu.NONE) {
    checkForRockClicks();
    checkForMaisyClick();
    checkForLeftSideIconClicks();
  } else if (!menuOpeningAnimationInProgress) {
    checkForMenuClicks();
  }
}

void keyPressed() {
  if (key == 's') {
    spawnRock(RockType.LIZARD);
  }
}

// calculates random events per second. this check assumes it is run every frame
// e.g. with parameters 1 in 10, this will give a 1 in 10 chance every second
boolean xChanceInYSeconds(int x, int y) {
  if (millis() - lastXinYCheck >= 1000) {
    lastXinYCheck = millis();
    return random(1) < (float)x / y;
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
