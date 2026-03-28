/*
 * This file pertains to anything rock-related that isn't concerning
 * individual rocks / rock behavior
*/

// display rocks and move them every frame
void incrementRocks() {
  for (int i = 0; i < rocks.size(); i++) {
    Rock rock = rocks.get(i);
    rock.display();
    rock.move();
    rock.waitToMove();
  }
}

// runs whenever the mouse is clicked
void checkForRockClicks() {
  for (int i = 0; i < rocks.size(); i++) {
    Rock rock = rocks.get(i);
    if (rock.mouseOnRock()) {
      rocks.remove(i);
      totalRocks += rock.clicked();
      
      if (rock.shouldDestroyOnClick()) {
        rock = null;
      }
    }
  }
}

// runs every frame
void attemptToSpawnRocks() {
  if (rocks.size() < rocksOnScreenLimit && xChanceInYSeconds(1, 3)) {
    spawnRock();
  }
}

void spawnRock() {
  Rock rock = new StandardRock();
  
  float locX = random.nextInt(int(corner), int(screenSize));
  float locY = random.nextInt(int(corner), int(screenSize));
  rock.setLocation(locX, locY);
  
  rocks.add(rock);
}
