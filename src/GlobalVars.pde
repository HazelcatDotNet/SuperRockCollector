int framerate = 30;

int lastXinYCheck = 0;
int lastMaisySwitch = 0;

String[] savedStrings;
String[] loadedStrings;


public enum RockType {
  STANDARD;
}

PImage background;
PImage maisy1;
PImage maisy2;
PImage maisySpeechBubble1;
PImage maisySpeechBubble2;
String[] maisyPokeLines;
String[] maisyLastNames;
boolean maisyIsTalking;
String maisyTalkingText = "";
int maisyTextLineCharLimit = 23;
SoundFile maisyTalkSound;
int charsLeftInMaisyTalkSound;
int maisyTalkSoundMsInterval = 130;
int maisyShouldStopTalkingMillis;

float corner;
float farmCenter;
float screenSize;
ArrayList<Rock> rocks;

// to add a new rock type: add file name to both this list and the Rock class
String[] rockFileNames = { "standard" };
Dictionary<String, PImage> rockImages = new Hashtable<>();

Random random = new Random();

long totalRocks;
int rocksOnScreenLimit = 20;
