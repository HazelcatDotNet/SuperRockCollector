// Helper class to track checkbox positions and associated setting
class SettingCheckboxInfo {
  String settingKey;
  float x;
  float y;
  float size;
  
  SettingCheckboxInfo(String settingKey, float x, float y, float size) {
    this.settingKey = settingKey;
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  boolean isClicked(float clickX, float clickY) {
    float halfSize = size / 2;
    return clickX >= x - halfSize && clickX <= x + halfSize &&
           clickY >= y - halfSize && clickY <= y + halfSize;
  }
}

ArrayList<Setting> settings = new ArrayList<Setting>();
ArrayList<SettingCheckboxInfo> settingCheckboxes = new ArrayList<SettingCheckboxInfo>();
Setting playMusicSetting;
Setting playSoundEffectSetting;
Setting animateSpritesSetting;

void loadSettings() {
  playMusicSetting = new Setting("playMusic");
  playMusicSetting.setDescription("play music");
  playMusicSetting.setExtendedDescription("Toggle background music on or off.");
  playMusicSetting.setValue(true);
  playMusicSetting.setDefaultValue(true);

  playSoundEffectSetting = new Setting("playSoundEffect");
  playSoundEffectSetting.setDescription("play sound effects");
  playSoundEffectSetting.setExtendedDescription("Toggle sound effects on or off.");
  playSoundEffectSetting.setValue(true);
  playSoundEffectSetting.setDefaultValue(true);

  animateSpritesSetting = new Setting("animateSprites");
  animateSpritesSetting.setDescription("draw animations");
  animateSpritesSetting.setExtendedDescription("Toggle sprite animations on or off.");
  animateSpritesSetting.setValue(true);
  animateSpritesSetting.setDefaultValue(true);
}

class Setting<T> {
  String key;
  String description;
  String extendedDescription;
  T value;
  T defaultValue;

  Setting(String key) {
    this.key = key;
    settings.add(this);
  }

  void setDescription(String description) {
    this.description = description;
  }

  void setExtendedDescription(String extendedDescription) {
    this.extendedDescription = extendedDescription;
  }

  void setValue(T value) {
    this.value = value;
  }

  void setDefaultValue(T defaultValue) {
    this.defaultValue = defaultValue;
  }

  boolean isBoolean() {
    return value instanceof Boolean;
  }

  // returns boolean value of the setting, or false if not a boolean
  boolean isEnabled() {
    return isBoolean() ? (Boolean) value : false;
  }
}

void drawSettingsMenu() {
  fill(0, 0, 0);
  textAlign(LEFT, CENTER);
  
  float horizontalPadding = corner / 3;
  float verticalPadding = corner / 3;
  float betweenSettingsPadding = corner / 12;
  float checkboxSize = corner * 0.25;
  float checkboxPadding = corner / 12;
  
  float startX = menuCenterX - (maxMenuSizeX / 2) + horizontalPadding;
  float startY = menuCenterY - (maxMenuSizeY / 2) + verticalPadding;
  
  float currentY = startY;
  settingCheckboxes.clear(); // Clear previous checkbox data
  
  for (int i = 0; i < settings.size(); i++) {
    Setting setting = settings.get(i);
    
    if (setting.isBoolean()) {
      // Draw checkbox
      float checkboxX = startX + checkboxSize / 2;
      float checkboxY = currentY + checkboxSize / 2;
      PImage checkboxImage = setting.isEnabled() ? checkboxChecked : checkboxUnchecked;
      image(checkboxImage, checkboxX, checkboxY, checkboxSize, checkboxSize);
      
      // Draw description text
      float textX = startX + checkboxSize + checkboxPadding;
      float textY = checkboxY;
      textSize(corner / 7);
      text(setting.description, textX, textY);
      
      // Store checkbox info for click detection
      settingCheckboxes.add(new SettingCheckboxInfo(setting.key, checkboxX, checkboxY, checkboxSize));
      
      // Calculate height for next item
      float itemHeight = checkboxSize + betweenSettingsPadding;
      currentY += itemHeight;
    }
  }
}

void checkForSettingCheckboxClicks() {
  for (SettingCheckboxInfo checkboxInfo : settingCheckboxes) {
    if (checkboxInfo.isClicked(mouseX, mouseY)) {
      // Find setting by key and toggle it
      for (Setting setting : settings) {
        if (setting.key.equals(checkboxInfo.settingKey)) {
          if (setting.isBoolean()) {
            boolean newValue = !setting.isEnabled();
            setting.setValue(newValue);
            handleSettingsChange(setting.key, newValue);
          }
          return;
        }
      }
    }
  }
}

void handleSettingsChange(String settingKey, Object newValue) {
  if (settingKey.equals("playMusic")) {
    if ((Boolean)newValue) {
      startSoundLoop(mainThemeSong);
    } else {
      mainThemeSong.stop();
    }
  }
}