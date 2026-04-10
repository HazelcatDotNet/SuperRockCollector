// Upgrades
ArrayList<Upgrade> upgrades;
String[] upgradeOrder = {"deneutralizer", "jeff"};
String[] purchasedUpgradesOrder;
String[] unpurchasedUpgradesOrder;
HashMap<String, Upgrade> upgradesByKey;

void loadUpgrades() {
    upgrades = new ArrayList<Upgrade>();
    upgradesByKey = new HashMap<String, Upgrade>();

    /*
        Template:

        Upgrade exampleName = new Upgrade("key");
        exampleName.setCost(100);
        exampleName.setName("ExampleName");
        exampleName.setDescription("Description");
        exampleName.setMaisyPurchaseLine("MaisyLine");

        don't forget to add to upgradeOrder!
    */
    
    Upgrade deneutralizer = new Upgrade("deneutralizer");
    deneutralizer.setCost(100);
    deneutralizer.setName("Localized Temporal Deneutralizer");
    deneutralizer.setDescription("This wacky artifact allows abnormal rocks to spawn!");
    deneutralizer.setMaisyPurchaseLine("Ooh, the deneutralizer! Im sure wondrous things will come from this. / Let me know what kinds of new rocks you find!");
    
    Upgrade deneutralizer2 = new Upgrade("jeff");
    deneutralizer2.setCost(200);
    deneutralizer2.setName("Jeff");
    deneutralizer2.setDescription("Will bring you rocks from time to time!");
    deneutralizer2.setMaisyPurchaseLine("hey, that's jeff! he's good at finding rocks. / I'm a bit scared of dogs, though...");
}

void setUpgradeDescriptions() {
    for (Upgrade upgrade : upgrades) {
        upgrade.setWrappedDescription();
        upgrade.descriptionHeight = getTextBlockHeight(upgrade.description, upgradeDescriptionTextSize);
    }
}

class Upgrade {
    String name;
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

    void setWrappedDescription() {
        description = wrapText(description, floor(corner * 0.5));
    }

    void setMaisyPurchaseLine(String line) {
        this.maisyPurchaseLine = line;
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

void populateUpgradeLists() {
    populateUnpurchasedUpgrades();
    populatePurchasedUpgrades();
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