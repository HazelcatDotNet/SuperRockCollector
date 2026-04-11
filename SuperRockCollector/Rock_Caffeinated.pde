class CaffeinatedRock extends Rock {
  private float vibrationAmplitude = 0.0007;  // percentage of screen width
  private float vibrationFrequency = 0.08; // radians per millisecond
  private float screenScaledAmplitude;
  
  CaffeinatedRock() {
    rockType = RockType.CAFFEINATED;
    rockFileName = "caffeinated";
    super.setImage();
    setScreenScaledAmplitude();
  }

  @Override float renderLocationX() {
    return loc.x + sin(millis() * vibrationFrequency) * screenScaledAmplitude;
  }

  @Override float renderLocationY() {
    return loc.y + sin(millis() * vibrationFrequency + PI / 2) * screenScaledAmplitude;
  }

  void setScreenScaledAmplitude() {
    screenScaledAmplitude = width * vibrationAmplitude;
  }

  @Override int rocksCollectedUponClick() {
    
    // 30% chance of giving 2 rocks - otherwise, 1
    float chanceOfGivingExtraRock = 0.3;
    return random(1) < chanceOfGivingExtraRock ? 2 : 1;
  }
}
