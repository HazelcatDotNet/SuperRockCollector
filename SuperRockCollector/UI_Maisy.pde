int maisyTextLineCharLimit = 23;
int maisySoundsRemaining;
int maisyTalkSoundMsInterval = 130;
int maisyShouldStopTalkingMillis;
float defaultMaisyTextSize;
float maisyTextSize;

// returns whether or not the mouse is on the maisy box
boolean mouseOnMaisy() {
  float centerY = halfCorner;
  float radius = halfCorner;

  if (dist(mouseX, mouseY, screenCenter, centerY) <= radius) {
    return true;
  }

  return false;
}

// runs whenever mouse is pressed
void checkForMaisyClick() {
  if (mouseOnMaisy() && !maisyIsTalking) {
    int index = int(random(maisyPokeLines.length));
    if (DEBUG_MAISY_LINE > 0) index = DEBUG_MAISY_LINE - 1; // defined line number for debugging

    addMaisyLineToIndexesRecieved(index);
    
    maisyTalkingTextLines = new ArrayList<String>(Arrays.asList(maisyPokeLines[index].split(" / ")));
    String maisyLine = getNextMaisyLine(index + 1);
    maisyStartTalking(maisyLine);
  } 
}

void addMaisyLineToIndexesRecieved(int index) {
  if (!maisyPokeLinesIndexesRecieved.contains(index)) {
    maisyPokeLinesIndexesRecieved.add(index);
  }
}

// if a maisy monologue line starts with {x}, temporarily set the text size to regular * x
String setMaisyTextSize(String maisyLine) {
  if (maisyLine.startsWith("{")) {
    int endIndex = maisyLine.indexOf("}");
    if (endIndex != -1) {
      String numberStr = maisyLine.substring(1, endIndex);
      maisyTextSize = defaultMaisyTextSize * Float.parseFloat(numberStr);
      maisyLine = maisyLine.substring(endIndex + 1);
    }
  } else {
    maisyTextSize = defaultMaisyTextSize;
  }

  return maisyLine;
}

void drawMaisy() {
  imageMode(CENTER);
  animateDrawing(maisy1, maisy2, screenCenter, halfCorner, corner, corner, 500);
  
  drawMaisyText();
}

void drawMaisySpeechBubble() {
  imageMode(CENTER);
  float speechBubbleX = width * (3.08 / 4.0);
  float speechBubbleY = halfCorner;
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
        maisyStopTalking();
        
        // and if maisy still has more lines in her monologue
      } else {
        maisyStartTalking(getNextMaisyLine(-1));
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
  float centerY = halfCorner;
  float radius = halfCorner;

  noFill();
  stroke(255, 0, 0); // red outline
  strokeWeight(2);
  ellipse(screenCenter, centerY, radius * 2, radius * 2);
}