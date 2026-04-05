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

PImage loadingSpinner;

// music
SoundFile mainThemeSong;

PImage menuBackground;
PImage menuXOutButton;

// left-side icons
PImage upgradesButton1;
PImage upgradesButton2;

void loadLoadingSpinner() {
  loadingSpinner = loadImage(dataPath("art/loading-spinner.png"));
}

void loadSounds() {
  maisyTalkSound = new SoundFile(this, dataPath("sfx/maisy-talk.wav"));
  rockPopSound = new SoundFile(this, dataPath("sfx/rock-pop.wav"));
  
  // songs
  mainThemeSong = new SoundFile(this, dataPath("sfx/time-to-collect!.wav"));
  
}

void loadUiImages() {
  background = requestImage(dataPath("art/background-wood-grain.png"));

  maisy1 = requestImage(dataPath("art/maisy-1.png"));
  maisy2 = requestImage(dataPath("art/maisy-2.png"));
  maisySpeechBubble1 = requestImage(dataPath("art/maisy-speech-bubble-1.png"));
  maisySpeechBubble2 = requestImage(dataPath("art/maisy-speech-bubble-2.png"));

  menuBackground = requestImage(dataPath("art/menu-background.png"));
  menuXOutButton = requestImage(dataPath("art/menu-x-out-button.png"));

  upgradesButton1 = requestImage(dataPath("art/upgrades-1.png"));
  upgradesButton2 = requestImage(dataPath("art/upgrades-2.png"));
}
