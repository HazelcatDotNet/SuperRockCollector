boolean loaded;
long millisSinceLastSave;
long totalPlayTimeSeconds;
float loadingSpinnerAngle = random(TWO_PI);
int loadEndTime;

int lastXinYCheck = 0;
int lastMaisySwitch = 0;

public enum RockType {
  STANDARD,
  LIZARD;
}

String[] maisyPokeLines;
String[] maisyLastNames;
boolean maisyIsTalking;
ArrayList<String> maisyTalkingTextLines;
String maisyTalkingText = "";
int maisyTalkingLinesIndesx;
int maisyTextLineCharLimit = 23;
int maisySoundsRemaining;
int maisyTalkSoundMsInterval = 130;
int maisyShouldStopTalkingMillis;
float defaultMaisyTextSize;
float maisyTextSize;

// to add a new rock type: add file name to both this list and the Rock class, and add the rock type to newRockOfType in RockMeta
String[] rockFileNames = { "standard" };

Random random = new Random();
int lastSecondTime;

int rocksOnScreenLimit = 20;

final int ROCK_FIELD_COUNT = 12;

// the following variables are saved
long totalRocks;
ArrayList<Rock> rocks;
int oldScreenSize;
int newScreenSize;
int newFrameRate;
