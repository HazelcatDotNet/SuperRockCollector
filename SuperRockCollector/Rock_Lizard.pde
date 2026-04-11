class LizardRock extends Rock {
  LizardRock() {
    rockType = RockType.LIZARD;
    rockFileName = "hardy";
    super.setImage();
  }
  
  @Override void setRockOpacity() {
    if (reptileRadarUpgrade.isToggledOn) {
      setDrawOpacity(70);
      return;
    }

    setDrawOpacity(20);
  }
  
  @Override int rocksCollectedUponClick() {
    
    // 20% chance of giving 2 rocks - otherwise, 1
    float chanceOfGivingExtraRock = 0.2;
    return runChance(chanceOfGivingExtraRock) ? 2 : 1;
  }
}
