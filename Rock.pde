public class Rock {
  
  String id;
  
  RockType rockType;
  
  String rockFileName;
  PImage img;
  
  float locX;
  float locY;
  float velX;
  float velY;
  
  float sizeX;
  float sizeY;
  float leftEdge;
  float rightEdge;
  float upEdge;
  float downEdge;
  
  Rock() {
    setId();
    setSize(20, 20);
    setLocation(farmCenter, farmCenter);
    
    velX = 1.5;
    velY = 1.5;
  }
  
  void display() {
    rectMode(CENTER);
    //square(locX, locY, size);
    imageMode(CENTER);
    image(img, locX, locY, sizeX, sizeY);
  }
  
  // move the rock, bouncing it off walls if necessary
  void move() {
    setLocation(locX + velX, locY + velY);
    
    if (rightEdge > screenSize - 1 || leftEdge < corner) { //<>//
      velX *= -1;
    }
    
    if (downEdge > screenSize - 1 || upEdge < corner) {
      velY *= -1;
    }
  }
  
  // sets the size of the rock
  void setSize(float newSizeX, float newSizeY) {
    sizeX = newSizeX;
    sizeY = newSizeY;
  }
  
  void setId() {
    id = random.ints(10, 'a', 'z' + 1)
      .collect(StringBuilder::new,
        StringBuilder::appendCodePoint,
        StringBuilder::append)
      .toString();
  }
  
  // sets the location of the rock, updating all edge locations as well
  void setLocation(float newX, float newY) {
    locX = newX;
    locY = newY;
    
    float halfSizeX = sizeX / 2;
    float halfSizeY = sizeY / 2;
    
    leftEdge = locX - halfSizeX;
    rightEdge = locX + halfSizeX;
    upEdge = locY - halfSizeY;
    downEdge = locY + halfSizeY;
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
  
}
