// returns whether or not the mouse is on the maisy box
boolean mouseOnMaisy() {
  float centerX = screenSize / 2;
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
    //index = 22 - 1; // defined index for debugging
    maisyTalkingTextLines = new ArrayList<String>(Arrays.asList(maisyPokeLines[index].split(" / ")));
    getNextMaisyLine(index + 1);
  } 
}

void getNextMaisyLine(int lineNumber) {
  maisyTalkingText = maisyTalkingTextLines.remove(0);
  
  if (lineNumber > -1) {
    checkForSpecialPokeText(lineNumber); // add 1 because line numbers start at 1
  }
  
  // decide how many maisy noises should be made for the monologue
  maisySoundsRemaining = maisyTalkingText.length();
  if (maisySoundsRemaining > 12) maisySoundsRemaining = floor(maisySoundsRemaining / 3.5);
  
  // at what point should maisy stop talking
  maisyShouldStopTalkingMillis = millis() + (maisyTalkSoundMsInterval * maisySoundsRemaining * 2);
}

void checkForSpecialPokeText(int index) {
  if (index == 10) {
    int lastNameIndex = int(random(maisyLastNames.length));
    maisyTalkingText += maisyLastNames[lastNameIndex];
  } else if (index == 12) {
    totalRocks++;
  } else if (index == 16) {
    totalRocks--;
  }
}
