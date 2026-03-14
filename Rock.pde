class Rock {
  
  int id;
  String rockFileName;
  PImage img;
  
  float locX;
  float locY;
  float velX;
  float velY;
  
  float size;
  float leftEdge;
  float rightEdge;
  float upEdge;
  float downEdge;
  
  Rock() {
    id = 0;
    setSize(20);
    setLocation(farmCenter, farmCenter);
    
    velX = 1.5;
    velY = 1.5;

    rockFileName = "standard";
    setImage();
  }
  
  void display() {
    rectMode(CENTER);
    //square(locX, locY, size);
    imageMode(CENTER);
    image(img, locX, locY, size, size);
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
  void setSize(float newSize) {
    size = newSize;
  }
  
  // sets the location of the rock, updating all edge locations as well
  void setLocation(float newX, float newY) {
    locX = newX;
    locY = newY;
    
    float halfSize = size / 2;
    
    leftEdge = locX - halfSize;
    rightEdge = locX + halfSize;
    upEdge = locY - halfSize;
    downEdge = locY + halfSize;
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
