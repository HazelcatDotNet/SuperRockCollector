PImage background;

// Rocks
Dictionary<String, PImage> rockImages = new Hashtable<>();
SoundFile rockPopSound;
PImage[] rockExplosionFrames;

PImage[] rockHaulVariants;

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
PImage buyButtonGrayscale1;
PImage buyButtonGrayscale2;
PImage checkboxChecked;
PImage checkboxUnchecked;

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
  buyButtonGrayscale1 = loadImage(dataPath("art/buy-button-1.png"));
  buyButtonGrayscale2 = loadImage(dataPath("art/buy-button-2.png"));
  buyButtonGrayscale1.filter(GRAY);
  buyButtonGrayscale2.filter(GRAY);
  checkboxChecked = requestImage(dataPath("art/checkbox-checked.png"));
  checkboxUnchecked = requestImage(dataPath("art/checkbox-unchecked.png"));

  loadRockHaulVariants();
  loadRockExplosionFrames();

  // left side icons
  upgradesButton1 = requestImage(dataPath("art/upgrades-icon-1.png"));
  upgradesButton2 = requestImage(dataPath("art/upgrades-icon-2.png"));
  settingsButton1 = requestImage(dataPath("art/settings-icon-1.png"));
  settingsButton2 = requestImage(dataPath("art/settings-icon-2.png"));
}

void loadRockHaulVariants() {
  ArrayList<PImage> variants = new ArrayList<PImage>();
  int i = 1;
  while (true) {
    String path = dataPath("art/rock-haul-variants/rock-haul-variant-" + i + ".png");
    File f = new File(path);
    if (!f.exists()) break;
    variants.add(requestImage(path));
    i++;
  }
  rockHaulVariants = variants.toArray(new PImage[0]);
}

void loadRockExplosionFrames() {
  ArrayList<PImage> frames = new ArrayList<PImage>();
  int i = 1;
  while (true) {
    String path = dataPath("art/rock-explosion/rock-explosion-" + i + ".png");
    File f = new File(path);
    if (!f.exists()) break;
    frames.add(requestImage(path));
    i++;
  }
  rockExplosionFrames = frames.toArray(new PImage[0]);
}