// returns whether or not the mouse is on the maisy box
boolean mouseOnMaisy() {
  float centerX = width / 2;
  float centerY = corner / 2;
  float radius = corner / 2;

  if (dist(mouseX, mouseY, centerX, centerY) <= radius) {
    return true;
  }

  return false;
}

// runs whenever mouse is pressed
void checkForMaisyClick() {
  if (mouseOnMaisy() && !maisyIsTalking) {
    maisyIsTalking = true;
    
    int index = int(random(maisyPokeLines.length));
    //index = 34 - 1; // defined line number for debugging
    
    maisyTalkingTextLines = new ArrayList<String>(Arrays.asList(maisyPokeLines[index].split(" / ")));
    getNextMaisyLine(index + 1);
  } 
}

void getNextMaisyLine(int lineNumber) {
  maisyTalkingText = maisyTalkingTextLines.remove(0);
  setMaisyTextSize();
  
  if (lineNumber > -1) {
    checkForSpecialPokeText(lineNumber); // add 1 because line numbers start at 1
  }
  
  // decide how many maisy noises should be made for the monologue
  maisySoundsRemaining = maisyTalkingText.length();
  if (maisySoundsRemaining > 12) maisySoundsRemaining = floor(maisySoundsRemaining / 3.5);
  
  int maxMaisySounds = 60;
  if (maisySoundsRemaining > maxMaisySounds) maisySoundsRemaining = maxMaisySounds;
  
  int maisyTalkTime = (maisyTalkSoundMsInterval * maisySoundsRemaining * 2);
  int minimumMaisyTalkTime = 1500;
  if (maisyTalkTime < minimumMaisyTalkTime) maisyTalkTime = minimumMaisyTalkTime;
  
  // at what point should maisy stop talking
  maisyShouldStopTalkingMillis = millis() + maisyTalkTime;
}

// some poke lines have special effects - this function manages that
void checkForSpecialPokeText(int l) {
  if (l == 10) {
    int lastNameIndex = int(random(maisyLastNames.length));
    maisyTalkingText += maisyLastNames[lastNameIndex];
    
  } else if (l == 12) {
    totalRocks++;
    
  } else if (l == 16) {
    totalRocks--;
    
  } else if (l == 23) {
    int numRocks = rocks.size();
    if (numRocks == 1) {
      maisyTalkingText = maisyTalkingText.replace("are", "is");
      maisyTalkingText = maisyTalkingText.replace("rocks", "rock");
    }
    maisyTalkingText = maisyTalkingText.replace("x", str(numRocks));
    
  } else if (l == 24) {
    Iterator<Rock> it = rocks.iterator();
    
    while (it.hasNext()) {
      Rock r = it.next();
      if (r.rockType == RockType.STANDARD) {
        it.remove();
      }
    }
  }
}

// if a maisy monologue line starts with {x}, temporarily set the text size to regular * x
void setMaisyTextSize() {
  if (maisyTalkingText.startsWith("{")) {
    int endIndex = maisyTalkingText.indexOf("}");
    if (endIndex != -1) {
      String numberStr = maisyTalkingText.substring(1, endIndex);
      maisyTextSize = defaultMaisyTextSize * Float.parseFloat(numberStr);
      maisyTalkingText = maisyTalkingText.substring(endIndex + 1);
    }
  } else {
    maisyTextSize = defaultMaisyTextSize;
  }
}

void drawMaisy() {
  imageMode(CENTER);
  animateDrawing(maisy1, maisy2, width / 2, corner / 2, corner, corner, 500);
  
  drawMaisyText();
}

void drawMaisySpeechBubble() {
  imageMode(CENTER);
  float speechBubbleX = width * (3.08 / 4.0);
  float speechBubbleY = corner / 2;
  float speechBubbleWidth = corner * 2.7;
  float speechBubbleHeight = corner * 0.9;
  animateDrawing(maisySpeechBubble1, maisySpeechBubble2, speechBubbleX, speechBubbleY, speechBubbleWidth, speechBubbleHeight, 250);
}

// draws maisy's speech bubble, and the text inside it, if she is talking. also makes the noises :)
void drawMaisyText() {
  if (maisyIsTalking) {
    
    // check if it's time for maisy to stop talking
    if (millis() >= maisyShouldStopTalkingMillis) {
      
      // if maisy is done talking, set maisyIsTalking = false
      if (maisyTalkingTextLines.isEmpty()) {
        maisyIsTalking = false;
        
        // and if maisy still has more lines in her monologue
      } else {
        getNextMaisyLine(-1);
      }
      
    }
    
    drawMaisySpeechBubble();
    
    // make the maisy noises while she talks
    if (maisySoundsRemaining > 0 && intervalMs(maisyTalkSoundMsInterval)) {
      maisyTalkSound.play();
      maisySoundsRemaining--;
    }
    
    // draw the monologue text
    textSize(maisyTextSize);
    float scaler = defaultMaisyTextSize / maisyTextSize;
    String wrappedText = wrapText(maisyTalkingText, floor(maisyTextLineCharLimit * scaler));
    textAlign(LEFT, BASELINE);
    text(wrappedText, width / 1.6, corner / 3.25);
  }
}

// used for debugging
void drawMaisyHexagonHitbox() {
  float centerX = width / 2;
  float centerY = corner / 2;
  float radius = corner / 2;

  noFill();
  stroke(255, 0, 0); // red outline
  strokeWeight(2);
  ellipse(centerX, centerY, radius * 2, radius * 2);
}