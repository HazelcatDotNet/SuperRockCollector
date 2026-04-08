// ============================================================
//  SaveLoad.pde
//
//  Save format
//  -----------
//  Each saved variable lives in a named section:
//
//    [sectionName]
//    key=value        (for simple key/value pairs)
//    <item data>      (for lists — one entry per line)
//    [/sectionName]
//
//  To save a new simple variable in the future:
//    1. In saveData(), add a line inside the matching section
//       (or create a new [section] block).
//    2. In loadData(), add an else-if branch that reads it back.
//
//  To save a new list type in the future:
//    1. Give it a unique section name.
//    2. In saveData(), loop the list and call .toData() on each item.
//    3. In loadData(), collect lines between the section tags and
//       reconstruct objects with a matching fromData() factory.
// ============================================================

String SAVE_NAME = "save.txt";

// ------------------------------------------------------------
//  SAVE
// ------------------------------------------------------------
void saveData() {
  ArrayList<String> lines = new ArrayList<String>();

  // ---- simple variables ----
  lines.add("[vars]");
  lines.add("totalRocks=" + totalRocks);
  lines.add("oldScreenSize=" + width);
  lines.add("newScreenSize=" + newScreenSize);
  lines.add("newFrameRate=" + newFrameRate);
  // add future simple variables here, e.g.:
  //   lines.add("coins=" + coins);
  lines.add("[/vars]");

  // ---- rocks list ----
  lines.add("[rocks]");
  for (Rock r : rocks) {
    lines.add(r.toData());
  }
  lines.add("[/rocks]");

  // ---- upgrades list ----
  lines.add("[upgrades]");
  for (String upgradeKey : upgradeOrder) {
    Upgrade upgrade = upgradesByKey.get(upgradeKey);
    if (upgrade != null) {
      lines.add(upgrade.toData());
    }
  }
  lines.add("[/upgrades]");

  saveStrings(dataPath(SAVE_NAME), lines.toArray(new String[0]));
  println("[SaveLoad] Game saved. totalRocks=" + totalRocks
          + ", rocks=" + rocks.size() + ", upgrades=" + upgradeOrder.length);
}

// SAVE DEFAULTS
void setSaveDefaults() {
  totalRocks = 0;
  oldScreenSize = 800;
  newScreenSize = 800;
  setDefaultFrameRate();
}

void setDefaultFrameRate() {
  frameRate(25);
}

// ------------------------------------------------------------
//  LOAD
// ------------------------------------------------------------
void loadData() {
  rocks = new ArrayList<Rock>();

  String[] lines = loadStrings(dataPath(SAVE_NAME));
  if (lines == null) {
    // Initialise defaults so the game works even without a save file
    setSaveDefaults();
    println("[SaveLoad] No save file found — starting fresh.");
    return;
  }

  String currentSection = "";
  int upgradeIndex = 0;  // Track which upgrade we're loading

  for (String raw : lines) {
    String line = trim(raw);
    if (line.length() == 0) continue;

    // ---- section open/close tags ----
    if (line.startsWith("[/")) {
      currentSection = "";
      upgradeIndex = 0;  // Reset when section closes
      continue;
    }
    if (line.startsWith("[") && line.endsWith("]")) {
      currentSection = line.substring(1, line.length() - 1);
      upgradeIndex = 0;  // Reset when new section opens
      continue;
    }

    // ---- parse contents by section ----
    if (currentSection.equals("vars")) {
      String[] parts = split(line, '=');
      if (parts.length < 2) continue;
      String key   = parts[0];
      String value = parts[1];

      if (key.equals("totalRocks")) totalRocks = Long.parseLong(value);
      else if (key.equals("oldScreenSize")) oldScreenSize = int(value);
      else if (key.equals("newScreenSize")) {
        newScreenSize = int(value);
        if (newScreenSize != oldScreenSize) {
          windowResize(newScreenSize, newScreenSize);
        }
      } else if (key.equals("newFrameRate")) {
        int intendedNewFrameRate = int(value);
        if (intendedNewFrameRate > 0) {
          frameRate(intendedNewFrameRate);
        } else {
          setDefaultFrameRate();
        }
      }
      // add future simple variables here, e.g.:
      //   else if (key.equals("coins")) coins = int(value);
      
      // BEFORE LOADING ROCKS, calculate screen areas (e.g. corner, farm center, etc.)
      calculateScreenAreas();

    } else if (currentSection.equals("rocks")) {
      try {
        rocks.add(rockFromData(line));
      } catch (Exception e) {
        println("[SaveLoad] Skipping malformed rock entry: " + line);
        e.printStackTrace();
      }
    } else if (currentSection.equals("upgrades")) {
      try {
        upgradeFromData(line, upgradeIndex);
        upgradeIndex++;
      } catch (Exception e) {
        println("[SaveLoad] Skipping malformed upgrade entry: " + line);
        e.printStackTrace();
      }
    }
    // add future list sections here, e.g.:
    //   } else if (currentSection.equals("inventory")) { ... }
  }

  populatePurchasedUpgrades();
  populateUnpurchasedUpgrades();
  setUpgradeDescriptions();

  println("[SaveLoad] Game loaded. totalRocks=" + totalRocks
          + ", rocks=" + rocks.size() + ", upgrades=" + upgradeOrder.length);
}

Rock rockFromData(String line) {
  String[] p = line.split("\\|");

  if (p.length != ROCK_FIELD_COUNT) {
    throw new RuntimeException(
      "[Rock.fromData] Expected " + ROCK_FIELD_COUNT + " fields, got "
      + p.length + " in: " + line
    );
  }

  Rock r = newRockOfType(RockType.valueOf(p[1]));

  r.id           = p[0];
  r.rockType     = RockType.valueOf(p[1]);
  r.rockFileName = p[2];

  // scale location and destination, in case the screen size changed
  float scale = float(newScreenSize) / float(oldScreenSize);
  r.loc  = new PVector(float(p[3]) * scale, float(p[4]) * scale);
  r.dest = new PVector(float(p[5]) * scale, float(p[6]) * scale);

  r.calculateSpeed(); // recalculate speed based on current frame rate
  r.calculateSize();

  r.waitingToMove = boolean(p[10]);
  if (r.waitingToMove) {
    r.waitStartTime = millis();
    r.waitDuration = int(p[11]);
  }

  r.setImage();                        // restore image after loading
  r.setLocation(r.loc.x, r.loc.y);    // recalculate edges

  return r;
}

void upgradeFromData(String line, int upgradeIndex) {
  String[] parts = line.split("\\|");
  
  if (parts.length < 3) {
    throw new RuntimeException(
      "[upgradeFromData] Expected at least 3 fields (name|hasPurchased|isToggledOn), got "
      + parts.length + " in: " + line
    );
  }
  
  if (upgradeIndex >= 0 && upgradeIndex < upgradeOrder.length) {
    String upgradeKey = upgradeOrder[upgradeIndex];
    Upgrade upgrade = upgradesByKey.get(upgradeKey);
    if (upgrade != null) {
      println("[upgradeFromData] Loading upgrade: " + upgradeKey + ", hasPurchased=" + parts[1] + ", isToggledOn=" + parts[2]);
      upgrade.fromData(line);
    }
  }
}

void attachAutoSave() {
  // Get the underlying Java window and attach a listener that saves on close
  java.awt.Frame frame = ( (processing.awt.PSurfaceAWT.SmoothCanvas) surface.getNative() ).getFrame();
  
  frame.addWindowListener(new java.awt.event.WindowAdapter() {
    @Override
    public void windowClosing(java.awt.event.WindowEvent e) {
      saveData();
      noLoop(); // stop the draw loop before disposing
      System.exit(0); // exit immediately without manual frame disposal
    }
  });
}

Rock newRockOfType(RockType rockType) {
  switch (rockType) {
    case LIZARD: return new LizardRock();
    default:     return new StandardRock();
  }
}
