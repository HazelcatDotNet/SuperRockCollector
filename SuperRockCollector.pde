import java.util.ArrayList;
import java.util.Random;
import java.util.Dictionary;
import java.util.Enumeration;
import java.util.Hashtable;

String[] savedStrings;
String[] loadedStrings;


public enum RockType {
  STANDARD;
}

PImage background;
float corner;
float farmCenter;
float screenSize;
ArrayList<Rock> rocks;

// to add a new rock: add file name to both this list and the Rock class
String[] rockFileNames = { "standard" };
Dictionary<String, PImage> rockImages = new Hashtable<>();

Random random = new Random();

void setup() {
  //loadedStrings = loadStrings("data/save.silly");
  
  size(800, 800);
  screenSize = 800;
  corner = screenSize / 5.94;
  farmCenter = (corner + screenSize) / 2;
  
  background = loadImage("data/art/background.png");
  
  loadRockImages();
  
  rocks = new ArrayList<Rock>();
  
  for (int i = 0; i < 10; i++) {
    spawnRock();
  }
}

void draw() {
  imageMode(CORNER);
  image(background, 0, 0, width, height);
  circle(corner, corner, 5);
  
  for (int i = 0; i < rocks.size(); i++) {
    Rock rock = rocks.get(i);
    rock.display();
    rock.move();
  }
}

void mousePressed() {
  for (int i = 0; i < rocks.size(); i++) {
    Rock rock = rocks.get(i);
    if (rock.mouseOnRock()) {
      rocks.remove(i);
      rock = null;
    }
  }
}

void spawnRock() {
  Rock rock = new StandardRock();
  
  float locX = random.nextInt(int(corner), int(screenSize));
  float locY = random.nextInt(int(corner), int(screenSize));
  rock.setLocation(locX, locY);
  
  if (random.nextBoolean()) {
    rock.velX *= -1;
  }
  
  if (random.nextBoolean()) {
    rock.velY *= -1;
  }
  
  rocks.add(rock);
}

void loadRockImages() {
  for (int i = 0; i < rockFileNames.length; i++) {
    String rockFileName = rockFileNames[i];
    String filePath = "data/art/rocks/" + rockFileName + ".png";
    rockImages.put(rockFileName, loadImage(filePath));
  }
}
