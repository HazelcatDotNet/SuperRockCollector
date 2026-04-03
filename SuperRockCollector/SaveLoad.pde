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
  // add future simple variables here, e.g.:
  //   lines.add("coins=" + coins);
  lines.add("[/vars]");

  // ---- rocks list ----
  lines.add("[rocks]");
  for (Rock r : rocks) {
    lines.add(r.toData());
  }
  lines.add("[/rocks]");

  saveStrings(dataPath(SAVE_NAME), lines.toArray(new String[0]));
  println("[SaveLoad] Game saved. totalRocks=" + totalRocks
          + ", rocks=" + rocks.size());
}

// ------------------------------------------------------------
//  LOAD
// ------------------------------------------------------------
void loadData() {
  // Initialise defaults so the game works even without a save file
  totalRocks = 0;
  oldScreenSize = 800;
  newScreenSize = 800;
  rocks      = new ArrayList<Rock>();

  String[] lines = loadStrings(dataPath(SAVE_NAME));
  if (lines == null) {
    println("[SaveLoad] No save file found — starting fresh.");
    return;
  }

  String currentSection = "";

  for (String raw : lines) {
    String line = trim(raw);
    if (line.length() == 0) continue;

    // ---- section open/close tags ----
    if (line.startsWith("[/")) {
      currentSection = "";
      continue;
    }
    if (line.startsWith("[") && line.endsWith("]")) {
      currentSection = line.substring(1, line.length() - 1);
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
    }
    // add future list sections here, e.g.:
    //   } else if (currentSection.equals("inventory")) { ... }
  }

  println("[SaveLoad] Game loaded. totalRocks=" + totalRocks
          + ", rocks=" + rocks.size());
}

Rock rockFromData(String line) {
  String[] p = line.split("\\|");

  if (p.length != ROCK_FIELD_COUNT) {
    throw new RuntimeException(
      "[Rock.fromData] Expected " + ROCK_FIELD_COUNT + " fields, got "
      + p.length + " in: " + line
    );
  }

  Rock r = new Rock();

  r.id           = p[0];
  r.rockType     = RockType.valueOf(p[1]);
  r.rockFileName = p[2];

  // scale location and destination, in case the screen size changed
  float scale = float(newScreenSize) / float(oldScreenSize);
  r.loc  = new PVector(float(p[3]) * scale, float(p[4]) * scale);
  r.dest = new PVector(float(p[5]) * scale, float(p[6]) * scale);

  r.speed = float(p[7]);
  r.sizeX = float(p[8]);
  r.sizeY = float(p[9]);

  r.waitingToMove    = boolean(p[10]);
  r.waitTimeRemaining = int(p[11]);

  r.setImage();                        // restore image after loading
  r.setLocation(r.loc.x, r.loc.y);    // recalculate edges

  return r;
}

void attachAutoSave() {
  // Get the underlying Java window and attach a listener that saves on close
  java.awt.Frame frame = ( (processing.awt.PSurfaceAWT.SmoothCanvas) surface.getNative() ).getFrame();
  
  frame.addWindowListener(new java.awt.event.WindowAdapter() {
    @Override
    public void windowClosing(java.awt.event.WindowEvent e) {
      saveData();
      // Let Processing handle the actual exit
      frame.dispose();
      System.exit(0);
    }
  });
}
