/*
 * This file pertains to anything rock-related that isn't concerning
 * individual rocks / rock behavior
*/

/* to add a new rock type:
- add file name to both this list and the Rock class
- add the rock type to newRockOfType in RockMeta
- add the rock type to rollRockType in RockMeta, with appropriate weighting
*/
String[] rockFileNames = { "hardy", "caffeinated" };

void initializeRockClickTracking() {
  for (RockType type : RockType.values()) {
    rockClicksByType.put(type, 0);
  }
}

// display rocks and move them every frame
void incrementRocks() {
  for (int i = 0; i < rocks.size(); i++) {
    Rock rock = rocks.get(i);
    rock.display();
    rock.calculateSpeed();
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
    spawnRock(rollRockType());
  }
}

// decide what rock type to spawn (weighted)
RockType rollRockType() {
  if (!upgradesByKey.get("deneutralizer").isToggledOn) return RockType.HARDY;

  HashMap<RockType, Integer> typeWeights = new LinkedHashMap<RockType, Integer>();
  typeWeights.put(RockType.HARDY, 10);
  typeWeights.put(RockType.LIZARD, 3);
  typeWeights.put(RockType.CAFFEINATED, 2);
  
  int total = 0;
  for (int weight : typeWeights.values()) {
    total += weight;
  }
  
  int roll = random.nextInt(total);
  int cumulative = 0;
  for (RockType type : typeWeights.keySet()) {
    cumulative += typeWeights.get(type);
    if (roll < cumulative) return type;
  }
  
  return RockType.HARDY; // fallback, should never reach here
}

void spawnRock(RockType rockType) {
  Rock rock = newRockOfType(rockType);
  
  float locX = random.nextInt(int(corner), int(width));
  float locY = random.nextInt(int(corner), int(width));
  rock.setLocation(locX, locY);
  
  rocks.add(rock);
}

void spawnXRandomRocks(int x) {
  for (int i = 0; i < x; i++) {
    spawnRock(rollRockType());
  }
}

Rock newRockOfType(RockType rockType) {
  switch (rockType) {
    case LIZARD: return new LizardRock();
    case CAFFEINATED: return new CaffeinatedRock();
    default:     return new HardyRock();
  }
}
