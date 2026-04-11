// Upgrades
ArrayList<Upgrade> upgrades;
String[] upgradeOrder = {"deneutralizer", "jeff", "reptile-radar"};
String[] purchasedUpgradesOrder;
String[] unpurchasedUpgradesOrder;
HashMap<String, Upgrade> upgradesByKey;

Upgrade deneutralizerUpgrade;
Upgrade jeffUpgrade;
Upgrade reptileRadarUpgrade;

void loadUpgrades() {
    upgrades = new ArrayList<Upgrade>();
    upgradesByKey = new HashMap<String, Upgrade>();

    /*
        Template:
        Upgrade exampleName;
        exampleName = new Upgrade("key");
        exampleName.setCost(100);
        exampleName.setName("ExampleName");
        exampleName.setDescription("Description");
        exampleName.setMaisyPurchaseLine("MaisyLine");

        don't forget to add to upgradeOrder!
    */
    
    deneutralizerUpgrade = new Upgrade("deneutralizer");
    deneutralizerUpgrade.setCost(100);
    deneutralizerUpgrade.setName("Localized Temporal Deneutralizer");
    deneutralizerUpgrade.setDescription("This wacky artifact allows abnormal rocks to spawn!");
    deneutralizerUpgrade.setMaisyPurchaseLine("ooh, the deneutralizer! i'm sure wondrous things will come from it. / let me know what kinds of new rocks you find!");
    
    jeffUpgrade = new Upgrade("jeff");
    jeffUpgrade.setCost(200);
    jeffUpgrade.setName("Jeff");
    jeffUpgrade.setDescription("Silly dog who will bring you rocks from time to time!");
    jeffUpgrade.setMaisyPurchaseLine("hey, that's jeff! he's good at finding rocks. / i'm a bit scared of dogs, though...");

    reptileRadarUpgrade = new Upgrade("reptile-radar");
    reptileRadarUpgrade.setCost(300);
    reptileRadarUpgrade.setName("Reptile Radar");
    reptileRadarUpgrade.setDescription("Highlights those sneaky Lizard Rocks, making them less transparent!");
    reptileRadarUpgrade.setMaisyPurchaseLine("who even made this thing? it's making all sorts of funny noises.");

}

void setUpgradeDescriptions() {
    for (Upgrade upgrade : upgrades) {
        upgrade.setWrappedDescription();
        upgrade.descriptionHeight = getTextBlockHeight(upgrade.description, upgradeDescriptionTextSize);
    }
}

class Upgrade {
    String name;
    String key;
    int cost;
    String description;
    String maisyPurchaseLine; // if this upgrade has a special line that Maisy says when bought, it goes here (otherwise null)
    PImage image1;
    PImage image2;

    boolean hasPurchased;
    boolean isToggledOn;

    float descriptionHeight;

    Upgrade(String upgradeKey) {
        setImages(upgradeKey);
        upgrades.add(this);
        upgradesByKey.put(upgradeKey, this);
        this.key = upgradeKey;
    }

    void setImages(String baseImageString) {
        String basePath1 = "art/" + baseImageString + "-upgrade-1.png";
        String basePath2 = "art/" + baseImageString + "-upgrade-2.png";
        File file1 = new File(dataPath(basePath1));
        File file2 = new File(dataPath(basePath2));
        
        // If files don't exist, default to deneutralizer images
        if (!file1.exists() || !file2.exists()) {
            basePath1 = "art/deneutralizer-upgrade-1.png";
            basePath2 = "art/deneutralizer-upgrade-2.png";
        }
        
        this.image1 = requestImage(dataPath(basePath1));
        this.image2 = requestImage(dataPath(basePath2));
    }

    void setCost(int cost) {
        this.cost = cost;
    }

    void setName(String name) {
        this.name = name;
    }

    void setDescription(String description) {
        this.description = description;
    }

    boolean canAfford() {
        return totalRocks >= cost;
    }

    void setWrappedDescription() {
        description = wrapText(description, floor(corner * 0.45));
    }

    void setMaisyPurchaseLine(String line) {
        this.maisyPurchaseLine = line;
    }

    // Save upgrade state as a pipe-delimited string: key|hasPurchased|isToggledOn
    String toData() {
        return key + "|" + hasPurchased + "|" + isToggledOn;
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
        maisyStartTalking(upgrade.maisyPurchaseLine);
        checkSpecialUpgradePurchaseEvents(upgrade);
        println("Upgrade purchased: " + upgrade.name);
    } else {
        println("Not enough rocks to purchase: " + upgrade.name);
    }
}

void checkSpecialUpgradePurchaseEvents(Upgrade upgrade) {
    if (upgrade.key == "jeff") {
        setNextJeffHaulTime();
    }
}

// Populate the list of all upgrades based on their purchase status
void populateUpgradeLists() {
    populateUnpurchasedUpgrades();
    populatePurchasedUpgrades();
}

// Populate the list of upgrades that have not been purchased
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

// Populate the list of upgrades that have been purchased
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
// Set the time for the next Jeff Haul
void setNextJeffHaulTime() {
    // defaults to a random time between 6 and 12 minutes
    millisOfNextJeffHaul = millis() + int(random(360000, 720000));
    println("Next Jeff Haul in " + ((millisOfNextJeffHaul - millis()) / 1000) + " seconds.");
}

void checkForJeffHaul() {
    if (!jeffUpgrade.isToggledOn) return;
    if (isJeffHaulOnScreen()) return;

    if (millis() >= millisOfNextJeffHaul) {
        triggerJeffHaul();
    }
}

void triggerJeffHaul() {
    resetJeffHaulVars();
    setRandomRockHaulVariant();
    rockHaulRotationDirection = random(1) < 0.5 ? 1 : -1;  // randomly choose clockwise or counterclockwise
    rockHaulTargetRotation = TAU * 0.1 * rockHaulRotationDirection;
    jeffHaulAnimationInProgress = true;
    println("Jeff Haul triggered!");
}

void resetJeffHaulVars() {
    jeffHaulAnimationInProgress = false;
    jeffHaulWaitingForPickup = false;
    resetRockHaulCurrentY();
    rockHaulCurrentRotation = 0;  // reset rotation when animation completes
    rockHaulTargetRotation = 0;
}

void collectRockHaul() {
    int minRocks = 20;
    int maxRocks = 40;

    int rocksCollected = int(random(minRocks, maxRocks + 1)); // collect between 20 and 40 rocks
    totalRocks += rocksCollected;

    resetJeffHaulVars();
    setNextJeffHaulTime();
    println("Collected " + rocksCollected + " rocks from Jeff Haul!");
}