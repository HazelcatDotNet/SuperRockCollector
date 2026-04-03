PImage background;

// Rocks
Dictionary<String, PImage> rockImages = new Hashtable<>();
SoundFile rockPopSound;

// Maisy
PImage maisy1;
PImage maisy2;
PImage maisySpeechBubble1;
PImage maisySpeechBubble2;
SoundFile maisyTalkSound;

void loadSounds() {
  maisyTalkSound = new SoundFile(this, dataPath("sfx/maisy-talk.wav"));
  rockPopSound = new SoundFile(this, dataPath("sfx/rock-pop.wav"));
}

void loadUiImages() {
  background = loadImage(dataPath("art/background.png"));
  maisy1 = loadImage(dataPath("art/maisy-1.png"));
  maisy2 = loadImage(dataPath("art/maisy-2.png"));
  maisySpeechBubble1 = loadImage(dataPath("art/maisy-speech-bubble-1.png"));
  maisySpeechBubble2 = loadImage(dataPath("art/maisy-speech-bubble-2.png"));
}
