int framerate = 30;

int lastXinYCheck = 0;
int lastMaisySwitch = 0;

String[] savedStrings;
String[] loadedStrings;


public enum RockType {
  STANDARD;
}

String[] maisyPokeLines;
String[] maisyLastNames;
boolean maisyIsTalking;
String maisyTalkingText = "";
int maisyTextLineCharLimit = 23;
int maisySoundsRemaining;
int maisyTalkSoundMsInterval = 130;
int maisyShouldStopTalkingMillis;

float corner;
float farmCenter;
float screenSize;
ArrayList<Rock> rocks;

// to add a new rock type: add file name to both this list and the Rock class
String[] rockFileNames = { "standard" };

Random random = new Random();

long totalRocks;
int rocksOnScreenLimit = 20;
