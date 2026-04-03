boolean loaded;
float loadingSpinnerAngle = random(TWO_PI);
int loadEndTime;

int lastXinYCheck = 0;
int lastMaisySwitch = 0;

public enum RockType {
  STANDARD;
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

float corner;
float farmCenter;

// to add a new rock type: add file name to both this list and the Rock class
String[] rockFileNames = { "standard" };

Random random = new Random();

int rocksOnScreenLimit = 20;

final int ROCK_FIELD_COUNT = 12;

// the following variables are saved
long totalRocks;
ArrayList<Rock> rocks;
int framerate = 30;
int oldScreenSize;
int newScreenSize;
int newFrameRate;
