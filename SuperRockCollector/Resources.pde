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

// menu ui
PImage menuBackground;
PImage menuXOutButton;
PImage buyButton1;
PImage buyButton2;

// left-side icons
PImage upgradesButton1;
PImage upgradesButton2;
PImage settingsButton1;
PImage settingsButton2;


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

  // maisy!!!
  maisy1 = requestImage(dataPath("art/maisy-1.png"));
  maisy2 = requestImage(dataPath("art/maisy-2.png"));
  maisySpeechBubble1 = requestImage(dataPath("art/maisy-speech-bubble-1.png"));
  maisySpeechBubble2 = requestImage(dataPath("art/maisy-speech-bubble-2.png"));

  // menu ui
  menuBackground = requestImage(dataPath("art/menu-background.png"));
  menuXOutButton = requestImage(dataPath("art/menu-x-out-button.png"));
  buyButton1 = requestImage(dataPath("art/buy-button-1.png"));
  buyButton2 = requestImage(dataPath("art/buy-button-2.png"));

  // left side icons
  upgradesButton1 = requestImage(dataPath("art/upgrades-icon-1.png"));
  upgradesButton2 = requestImage(dataPath("art/upgrades-icon-2.png"));
  settingsButton1 = requestImage(dataPath("art/settings-icon-1.png"));
  settingsButton2 = requestImage(dataPath("art/settings-icon-2.png"));
}
