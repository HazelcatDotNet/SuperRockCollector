public class Rock {
  
  String id;
  
  RockType rockType;
  
  String rockFileName;
  PImage img;
  
  PVector loc;
  float speed;
  
  // current destination of the rock
  PVector dest;
  boolean waitingToMove = false;
  int waitTimeRemaining;
  
  float sizeX;
  float sizeY;
  
  float leftEdge;
  float rightEdge;
  float upEdge;
  float downEdge;
  
  Rock() {
    setId();
    setSize(30, 30);
    loc = new PVector();
    setLocation(farmCenter, farmCenter);
    chooseDest();
    
    speed = ceil(frameRate / 40.0);
  }
  
  void display() {
    rectMode(CENTER);
    //square(locX, locY, size);
    imageMode(CENTER);
    image(img, loc.x, loc.y, sizeX, sizeY);
  }
  
  // move the rock, bouncing it off walls if necessary
  void move() {
    if (waitingToMove) {
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
    } //<>//
  }
  
  void startToRestBetweenMoves() {
    waitingToMove = true;
    waitTimeRemaining = random.nextInt(int(frameRate), int(frameRate) * 5);
  }
  
  void waitToMove() {
    if (waitingToMove) {
      waitTimeRemaining--;
      
      if (waitTimeRemaining <= 0) {
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
    playSound();
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
    id = random.ints(12, '0', '9' + 1)
      .collect(StringBuilder::new,
        StringBuilder::appendCodePoint,
        StringBuilder::append)
      .toString();
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
    rockPopSound.play();
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
  // 10:waitingToMove | 11:waitTimeRemaining
  final String DELIM = "|";

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
           (waitingToMove ? waitTimeRemaining : 0);
  }
  
}
