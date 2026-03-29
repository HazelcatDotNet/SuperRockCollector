import java.util.ArrayList;
import java.util.Random;
import java.util.Dictionary;
import java.util.Enumeration;
import java.util.Hashtable;

int frameRate = 30;

int lastXinYCheck = 0;
int lastMaisySwitch = 0;

String[] savedStrings;
String[] loadedStrings;


public enum RockType {
  STANDARD;
}

PImage background;
PImage maisy1;
PImage maisy2;

float corner;
float farmCenter;
float screenSize;
ArrayList<Rock> rocks;

// to add a new rock: add file name to both this list and the Rock class
String[] rockFileNames = { "standard" };
Dictionary<String, PImage> rockImages = new Hashtable<>();

Random random = new Random();

long totalRocks;
int rocksOnScreenLimit = 20;

void setup() {
  //loadedStrings = loadStrings("data/save.silly");
  
  size(800, 800);
  frameRate(frameRate);
  screenSize = 800;
  corner = screenSize / 5.94;
  farmCenter = (corner + screenSize) / 2;
  
  loadUiImages();
  
  loadRockImages();
  
  rocks = new ArrayList<Rock>();
  
  for (int i = 0; i < 10; i++) {
    //spawnRock();
  }
}

void draw() {
  drawUi();
  
  incrementRocks();
  attemptToSpawnRocks();
}

void mousePressed() {
  checkForRockClicks();
}

void loadRockImages() {
  for (int i = 0; i < rockFileNames.length; i++) {
    String rockFileName = rockFileNames[i];
    String filePath = "data/art/rocks/" + rockFileName + ".png";
    rockImages.put(rockFileName, loadImage(filePath));
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
