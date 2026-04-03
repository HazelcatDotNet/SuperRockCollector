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
  frameRate(framerate);
  screenSize = 800;
  corner = screenSize / 5.94;
  farmCenter = (corner + screenSize) / 2;
  
  maisyPokeLines = loadStrings("../data/maisy-poke-lines.txt");
  maisyLastNames = loadStrings("../data/maisy-last-names.txt");
  loadSounds();
  loadUiImages();
  loadRockImages();
  
  rocks = new ArrayList<Rock>();
  
  // Automatically save when the window is closed
  attachAutoSave();
  
  loadData();
}

void draw() {
  drawUi();
  
  incrementRocks();
  attemptToSpawnRocks();
  //drawMaisyHexagonHitbox();
}

void mousePressed() {
  checkForRockClicks();
  checkForMaisyClick();
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveData();
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
