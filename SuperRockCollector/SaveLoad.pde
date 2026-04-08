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
  totalPlayTimeSeconds = (totalPlayTimeSeconds + (millis() - millisSinceLastSave) / 1000);
  lines.add("playTime=" + totalPlayTimeSeconds);
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
      lines.add(upgradeKey + "|" + upgrade.toData());
    }
  }
  lines.add("[/upgrades]");

  // ---- maisyPokeLinesIndexes list ----
  lines.add("[maisyPokeLinesIndexes]");
  for (Integer index : maisyPokeLinesIndexesRecieved) {
    lines.add(str(index));
  }
  lines.add("[/maisyPokeLinesIndexes]");

  // ---- rock clicks by type ----
  lines.add("[rockClicks]");
  for (RockType rockType : rockClicksByType.keySet()) {
    lines.add(rockType + "=" + rockClicksByType.get(rockType));
  }
  lines.add("[/rockClicks]");

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
  initializeRockClickTracking();
}

void setDefaultFrameRate() {
  frameRate(25);
}

// ------------------------------------------------------------
//  LOAD
// ------------------------------------------------------------
void loadData() {
  rocks = new ArrayList<Rock>();
  initializeRockClickTracking();

  String[] lines = loadStrings(dataPath(SAVE_NAME));
  if (lines == null) {
    setSaveDefaults();
    println("[SaveLoad] No save file found — starting fresh.");
    return;
  }

  String currentSection = "";
  ArrayList<String> sectionLines = new ArrayList<String>();

  for (String raw : lines) {
    String line = trim(raw);
    if (line.length() == 0) continue;

    // Section close tag
    if (line.startsWith("[/")) {
      processSectionLines(currentSection, sectionLines);
      sectionLines.clear();
      currentSection = "";
      continue;
    }

    // Section open tag
    if (line.startsWith("[") && line.endsWith("]")) {
      currentSection = line.substring(1, line.length() - 1);
      continue;
    }

    // Accumulate lines for the current section
    sectionLines.add(line);
  }

  populateUpgradeLists();
  setUpgradeDescriptions();

  println("[SaveLoad] Game loaded. totalRocks=" + totalRocks
          + ", rocks=" + rocks.size() + ", upgrades=" + upgradeOrder.length);
}

// Route section processing to appropriate handler
void processSectionLines(String sectionName, ArrayList<String> lines) {
  if (sectionName.equals("vars")) {
    loadVarsSection(lines);
  } else if (sectionName.equals("rocks")) {
    loadRocksSection(lines);
  } else if (sectionName.equals("upgrades")) {
    loadUpgradesSection(lines);
  } else if (sectionName.equals("maisyPokeLinesIndexes")) {
    loadMaisyPokeLinesIndexesSection(lines);
  } else if (sectionName.equals("rockClicks")) {
    loadRockClicksSection(lines);
  }
}

// Load all variables from the vars section
void loadVarsSection(ArrayList<String> lines) {
  for (String line : lines) {
    String[] parts = split(line, '=');
    if (parts.length < 2) continue;

    String key = parts[0];
    String value = parts[1];

    if (key.equals("totalRocks")) {
      totalRocks = Long.parseLong(value);
    } else if (key.equals("oldScreenSize")) {
      oldScreenSize = int(value);
    } else if (key.equals("newScreenSize")) {
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
    } else if (key.equals("playTime")) {
      totalPlayTimeSeconds = Long.parseLong(value);
    }
  }

  // After loading all vars, calculate screen areas
  calculateScreenAreas();
}

// Load all rocks from the rocks section
void loadRocksSection(ArrayList<String> lines) {
  for (String line : lines) {
    try {
      rocks.add(rockFromData(line));
    } catch (Exception e) {
      println("[SaveLoad] Skipping malformed rock entry: " + line);
      e.printStackTrace();
    }
  }
}

// Load all upgrades from the upgrades section
void loadUpgradesSection(ArrayList<String> lines) {
  for (String line : lines) {
    try {
      upgradeFromData(line);
    } catch (Exception e) {
      println("[SaveLoad] Skipping malformed upgrade entry: " + line);
      e.printStackTrace();
    }
  }
}

// Load maisyPokeLinesIndexes from the maisyPokeLinesIndexes section
void loadMaisyPokeLinesIndexesSection(ArrayList<String> lines) {
  for (String line : lines) {
    try {
      maisyPokeLinesIndexesRecieved.add(Integer.parseInt(line));
    } catch (NumberFormatException e) {
      println("[SaveLoad] Skipping malformed maisyPokeLinesIndex entry: " + line);
    }
  }
}

// Load rock clicks from the rockClicks section
void loadRockClicksSection(ArrayList<String> lines) {
  for (String line : lines) {
    try {
      String[] parts = split(line, '=');
      if (parts.length < 2) continue;
      
      RockType rockType = RockType.valueOf(parts[0]);
      int clickCount = int(parts[1]);
      rockClicksByType.put(rockType, clickCount);
    } catch (Exception e) {
      println("[SaveLoad] Skipping malformed rockClicks entry: " + line);
    }
  }
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

void upgradeFromData(String line) {
  String[] parts = line.split("\\|");
  
  if (parts.length < 4) {
    throw new RuntimeException(
      "[upgradeFromData] Expected at least 4 fields (key|name|hasPurchased|isToggledOn), got "
      + parts.length + " in: " + line
    );
  }
  
  String upgradeKey = parts[0];
  Upgrade upgrade = upgradesByKey.get(upgradeKey);
  if (upgrade != null) {
    upgrade.fromData(line.substring(line.indexOf('|') + 1)); // pass everything after the key
  } else {
    println("[upgradeFromData] Warning: Upgrade key '" + upgradeKey + "' not found in upgradesByKey");
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