// Upgrades
ArrayList<Upgrade> upgrades;
String[] upgradeOrder = {"deneutralizer", "deneutralizer2"};
String[] purchasedUpgradesOrder;
String[] unpurchasedUpgradesOrder;
HashMap<String, Upgrade> upgradesByKey;

void loadUpgrades() {
    upgrades = new ArrayList<Upgrade>();
    upgradesByKey = new HashMap<String, Upgrade>();
    
    Upgrade deneutralizer = new Upgrade(
        "Localized Temporal Deneutralizer",
        100,
        "This wacky artifact allows abnormal rocks to spawn!",
        requestImage(dataPath("art/deneutralizer-upgrade-1.png")),
        requestImage(dataPath("art/deneutralizer-upgrade-2.png"))
    );
    upgrades.add(deneutralizer);
    upgradesByKey.put("deneutralizer", deneutralizer);
    
    Upgrade deneutralizer2 = new Upgrade(
        "Localized Temporal Deneutralizer 2",
        200,
        "hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! hi! ",
        requestImage(dataPath("art/maisy-1.png")),
        requestImage(dataPath("art/maisy-2.png"))
    );
    upgrades.add(deneutralizer2);
    upgradesByKey.put("deneutralizer2", deneutralizer2);
}

void setUpgradeDescriptions() {
    for (Upgrade upgrade : upgrades) {
        upgrade.setWrappedDescription();
        upgrade.setDescriptionHeight();
    }
}

class Upgrade {
    String name;
    int cost;
    String description;
    PImage image1;
    PImage image2;

    boolean hasPurchased;
    boolean isToggledOn;

    float descriptionHeight;
    
    Upgrade(String name, int cost, String description, PImage image1, PImage image2) {
        this.name = name;
        this.cost = cost;
        this.description = description;
        this.image1 = image1;
        this.image2 = image2;
    }

    void setWrappedDescription() {
        description = wrapText(description, floor(corner * 0.5));
    }

    void setDescriptionHeight() {
        // Count the number of lines in description (newline characters + 1)
        int lineCount = description.split("\n").length;
        
        // Set text size to match what's used in the UI
        textSize(upgradeDescriptionTextSize);
        
        // Calculate height based on textAscent and textDescent
        float lineHeight = textAscent() + textDescent();
        
        // Add line spacing multiplier to account for padding between lines
        float lineSpacingMultiplier = 1.1;
        descriptionHeight = lineCount * lineHeight * lineSpacingMultiplier;
    }

    // Save upgrade state as a pipe-delimited string: key|hasPurchased|isToggledOn
    String toData() {
        return name + "|" + hasPurchased + "|" + isToggledOn;
    }

    // Load upgrade state from a pipe-delimited string
    void fromData(String line) {
        String[] parts = line.split("\\|");
        if (parts.length >= 3) {
            hasPurchased = Boolean.parseBoolean(parts[1]);
            isToggledOn = Boolean.parseBoolean(parts[2]);
        }
    }
}

void checkForUpgradeBuyClicks() {
    for (BuyButtonInfo buttonInfo : buyButtons) {
        if (buttonInfo.isClicked(mouseX, mouseY)) {
            Upgrade upgrade = upgradesByKey.get(buttonInfo.upgradeKey);
            if (upgrade != null) {
                attemptToBuyUpgrade(upgrade);
            }
            return;
        }
    }
}

void attemptToBuyUpgrade(Upgrade upgrade) {
    if (upgrade.hasPurchased) {
        println("Upgrade already purchased: " + upgrade.name);
        return;
    }
    if (totalRocks >= upgrade.cost) {
        totalRocks -= upgrade.cost;
        upgrade.hasPurchased = true;
        upgrade.isToggledOn = true; // default to toggled on when purchased
        populateUnpurchasedUpgrades();
        populatePurchasedUpgrades();
        println("Upgrade purchased: " + upgrade.name);
    } else {
        println("Not enough rocks to purchase: " + upgrade.name);
    }
}

void populateUnpurchasedUpgrades() {
    ArrayList<String> unpurchased = new ArrayList<String>();
    for (String upgradeKey : upgradeOrder) {
      Upgrade upgrade = upgradesByKey.get(upgradeKey);
      if (upgrade != null && !upgrade.hasPurchased) {
        unpurchased.add(upgradeKey);
      }
    }
    unpurchasedUpgradesOrder = unpurchased.toArray(new String[0]);
}

  void populatePurchasedUpgrades() {
    ArrayList<String> purchased = new ArrayList<String>();
    for (String upgradeKey : upgradeOrder) {
      Upgrade upgrade = upgradesByKey.get(upgradeKey);
      if (upgrade != null && upgrade.hasPurchased) {
        purchased.add(upgradeKey);
      }
    }
    purchasedUpgradesOrder = purchased.toArray(new String[0]);
}