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
  
  // loop backwards so rocks on top are clicked first
  for (int i = rocks.size() - 1; i >= 0; i--) {
    Rock rock = rocks.get(i);
    if (rock.mouseOnRock()) {
      rocks.remove(i);
      totalRocks += rock.onClick();
      
      if (rock.shouldDestroyOnClick()) {
        rock = null;
      }
      
      // return after the rock click, because only one rock can be clicked per click
      return;
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
  
  float locX = random.nextInt(int(corner), int(width));
  float locY = random.nextInt(int(corner), int(width));
  rock.setLocation(locX, locY);
  
  rocks.add(rock);
}

void spawnXRocks(int x) {
  for (int i = 0; i < x; i++) {
    spawnRock();
  }
}
