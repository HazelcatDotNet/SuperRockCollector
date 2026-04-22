public enum RockType {
  HARDY,
  LIZARD,
  CAFFEINATED,
  BALLOON;
}

// the number of Rock fields we save the data of
final int ROCK_FIELD_COUNT = 13;

public class Rock {
  
  String id;
  
  RockType rockType;
  
  String rockFileName;
  PImage img;
  
  PVector loc;
  float speed;
  boolean frozen;
  
  // current destination of the rock
  PVector dest;
  boolean waitingToMove = false;
  int waitStartTime;
  int waitDuration;
  
  float sizeX;
  float sizeY;
  
  float leftEdge;
  float rightEdge;
  float upEdge;
  float downEdge;
  
  Rock() {
    setId();

    calculateSize();
    loc = new PVector();
    setLocation(farmCenter, farmCenter);
    chooseDest();
    
    calculateSpeed();
  }

  void calculateSize() {
    float scaler = 3.0 / 80.0;
    setSize(width * scaler, width * scaler);
  }
  
  void display() {
    rectMode(CENTER);
    imageMode(CENTER);
    setRockOpacity();
    image(img, renderLocationX(), renderLocationY(), sizeX, sizeY);
    setDrawOpacity(255);
  }

  float renderLocationX() {
    return loc.x;
  }

  float renderLocationY() {
    return loc.y;
  }

  
  void setRockOpacity() {
    setDrawOpacity(255);
  }

  void calculateSpeed() {
    speed = (30.0 / frameRate);
  }
  
  // move the rock, bouncing it off walls if necessary
  void move() {
    if (waitingToMove || frozen) {
      return;
    }
    
    // create direction vector
    PVector dir = PVector.sub(dest, loc);
    float dist = dir.mag();
    
    // move toward destination
    if (dist > speed) {
      dir.normalize();
      dir.mult(speed);
      setLocation(loc.x + dir.x, loc.y + dir.y);
    } else {
      setLocation(dest.x, dest.y);
      startToRestBetweenMoves();
    }
  }
  
  void startToRestBetweenMoves() {
    waitingToMove = true;
    waitStartTime = millis();
    // Random wait between 1-5 seconds
    waitDuration = random.nextInt(1000, 5001);
  }
  
  void waitToMove() {
    if (waitingToMove) {
      if (millis() - waitStartTime >= waitDuration) {
        waitingToMove = false;
        chooseDest();
      }
    }
   
  }
  
  void chooseDest() {
    int leftBound = int(corner + sizeX);
    int rightBound = int(width - sizeX);
    int upBound = int(corner + sizeY);
    int downBound = int(width - sizeY);
    
    int destX = random.nextInt(leftBound, rightBound);
    int destY = random.nextInt(upBound, downBound);
    dest = new PVector(destX, destY);
  }
  
  int onClick() {
    // Track the click for this rock type
    rockClicksByType.put(rockType, rockClicksByType.get(rockType) + 1);

    if (shouldDestroyOnClick()) {
      runDestroyActions();
    }

    runExtraOnClickActions();

    return rocksCollectedUponClick();
  }

  void runExtraOnClickActions() {
    // default does nothing, but some rock types have extra actions to run on click
    return;
  }

  void runDestroyActions() {
    playSound();
    rocks.remove(this);
    onDestroy();
  }

  void onDestroy() {
    return;
  }

  
  int rocksCollectedUponClick() {
    return 1;
  }
  
  boolean shouldDestroyOnClick() {
    return true;
  }
  
  // sets the size of the rock
  void setSize(float newSizeX, float newSizeY) {
    sizeX = newSizeX;
    sizeY = newSizeY;
  }
  
  void setId() {
    id = randomNumberString(12);
  }
  
  // sets the location of the rock, updating all edge locations as well
  void setLocation(float newX, float newY) {
    loc.x = newX;
    loc.y = newY;
    
    float halfSizeX = sizeX / 2;
    float halfSizeY = sizeY / 2;
    
    leftEdge = loc.x - halfSizeX;
    rightEdge = loc.x + halfSizeX;
    upEdge = loc.y - halfSizeY;
    downEdge = loc.y + halfSizeY;
  }
  
  void playSound() {
    if (playSoundEffectSetting.isEnabled()) rockPopSound.play();
  }
  
  // returns whether or not the mouse cursor is currently within the bounds of a square rock
  boolean mouseOnRock() {
    if (mouseX > leftEdge && mouseX < rightEdge && mouseY > upEdge && mouseY < downEdge) {
      return true;
    }
    return false;
  }
  
  void setImage() {
    img = rockImages.get(rockFileName);
  }
  
  // Field order (pipe-delimited):
  // 0:id | 1:rockType | 2:rockFileName | 3:loc.x | 4:loc.y |
  // 5:dest.x | 6:dest.y | 7:speed | 8:sizeX | 9:sizeY |
  // 10:waitingToMove | 11:waitDuration | 12:typeSpecificData
  final String DELIM = "|";

  String getTypeSpecificData() {
    return "placeholder";
  }

  String toData() {
    return id                                      + DELIM +
           rockType                                + DELIM +
           rockFileName                            + DELIM +
           loc.x                                   + DELIM +
           loc.y                                   + DELIM +
           dest.x                                  + DELIM +
           dest.y                                  + DELIM +
           speed                                   + DELIM +
           sizeX                                   + DELIM +
           sizeY                                   + DELIM +
           waitingToMove                           + DELIM +
           (waitingToMove ? waitDuration : 0)     + DELIM +
           getTypeSpecificData();
  }
  
}