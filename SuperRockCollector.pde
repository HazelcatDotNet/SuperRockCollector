import java.util.ArrayList;
import java.util.Random;

String[] savedStrings;
String[] loadedStrings;

PImage background;
float corner;
float farmCenter;
float screenSize;
ArrayList<Rock> rocks;

Random random = new Random();

void setup() {
  loadedStrings = loadStrings("data/save.silly");
  
  size(800, 800);
  screenSize = 800;
  corner = screenSize / 5.94;
  farmCenter = (corner + screenSize) / 2;
  
  background = loadImage("data/art/background.png");
  rocks = new ArrayList<Rock>();
  
  for (int i = 0; i < 10; i++) {
    spawnRock();
  }
}

void draw() {
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
  Rock rock = new Rock();
  
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
