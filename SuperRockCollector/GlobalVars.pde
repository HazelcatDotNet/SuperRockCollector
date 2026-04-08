boolean loaded;
long millisSinceLastSave;
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

Random random = new Random();
int lastSecondTime;

int rocksOnScreenLimit = 20;

// the following variables are saved
long totalRocks;
ArrayList<Rock> rocks;
int oldScreenSize;
int newScreenSize;
int newFrameRate;
ArrayList<Integer> maisyPokeLinesIndexesRecieved = new ArrayList<Integer>();
HashMap<RockType, Integer> rockClicksByType = new HashMap<RockType, Integer>(); // tracked clicks per rock type
long totalPlayTimeSeconds;