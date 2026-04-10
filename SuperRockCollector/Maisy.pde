String[] maisyPokeLines;
String[] maisyLastNames;
boolean maisyIsTalking;
ArrayList<String> maisyTalkingTextLines;
String maisyTalkingText = "";
int maisyTalkingLinesIndex;

String getNextMaisyLine(int lineNumber) {
  String maisyLine = maisyTalkingTextLines.remove(0);
  
  if (lineNumber > -1) {
    maisyLine = checkForSpecialPokeText(maisyLine, lineNumber); // add 1 because line numbers start at 1
  }
  return maisyLine;

}

// some poke lines have special effects - this function manages that
String checkForSpecialPokeText(String maisyLine,int l) {
  if (l == 10) {
    int lastNameIndex = int(random(maisyLastNames.length));
    maisyLine += maisyLastNames[lastNameIndex];
    
  } else if (l == 12) {
    totalRocks++;
    
  } else if (l == 16) {
    totalRocks--;
    
  } else if (l == 23) {
    int numRocks = rocks.size();
    if (numRocks == 1) {
      maisyLine = maisyLine.replace("are", "is");
      maisyLine = maisyLine.replace("rocks", "rock");
    }
    maisyLine = maisyLine.replace("x", str(numRocks));
    
    // remove all standard rocks from the screen
  } else if (l == 24) {
    Iterator<Rock> it = rocks.iterator();
    
    while (it.hasNext()) {
      Rock r = it.next();
      if (r.rockType == RockType.STANDARD) {
        it.remove();
      }
    }
  }

  return maisyLine;
}

void maisyStartTalking(String maisyLine) {
  if (maisyLine.contains(" / ")) {
    maisyTalkingTextLines = new ArrayList<String>(Arrays.asList(maisyLine.split(" / ")));
    maisyLine = getNextMaisyLine(-1);
  }

  maisyIsTalking = true;
  maisyLine = setMaisyTextSize(maisyLine);
  maisyTalkingText = maisyLine;

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

void maisyStopTalking() {
  maisyIsTalking = false;
  maisyTalkingTextLines.clear();
  maisySoundsRemaining = 0;
  maisyShouldStopTalkingMillis = millis();
}