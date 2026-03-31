import java.util.ArrayList;
import java.util.Random;
import java.util.Dictionary;
import java.util.Enumeration;
import java.util.Hashtable;

void setup() {
  //loadedStrings = loadStrings("data/save.silly");
  
  size(800, 800);
  frameRate(frameRate);
  screenSize = 800;
  corner = screenSize / 5.94;
  farmCenter = (corner + screenSize) / 2;
  
  maisyPokeLines = loadStrings("data/maisy-poke-lines.txt");
  maisyLastNames = loadStrings("data/maisy-last-names.txt");
  loadUiImages();
  loadRockImages();
  
  rocks = new ArrayList<Rock>();
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
