class CaffeinatedRock extends Rock {
  private float vibrationAmplitude = 0.0007;  // percentage of screen width
  private float vibrationFrequency = 0.08; // radians per millisecond
  private float screenScaledAmplitude;
  private float chanceOfExploding = 0.4;
  private boolean willExplodeOnClick;
  
  CaffeinatedRock() {
    rockType = RockType.CAFFEINATED;
    rockFileName = "caffeinated";
    super.setImage();
    setScreenScaledAmplitude();
    willExplodeOnClick = runChance(chanceOfExploding);
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

  void setWillExplodeOnClick(boolean willExplode) {
    this.willExplodeOnClick = willExplode;
  }

  @Override String getTypeSpecificData() {
    return String.valueOf(willExplodeOnClick);
  }

  @Override int rocksCollectedUponClick() {
    return !willExplodeOnClick ? 3 : 0;
  }

  // 40% chance of exploding on click
  @Override void onDestroy() {
    if (willExplodeOnClick) startRockExplosion(loc.x, loc.y, sizeX * 2, 2);
  }
}
