void loadUpgrades() {
    upgrades = new ArrayList<Upgrade>();
    upgradesByKey = new HashMap<String, Upgrade>();
    
    Upgrade deneutralizer = new Upgrade(
        "Localized Temporal Deneutralizer",
        100,
        "This wacky artifact allows abnormal rocks to spawn!",
        requestImage(dataPath("art/deneutralizer-upgrade-1.png")),
        requestImage(dataPath("art/deneutralizer-upgrade-1.png"))
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

    setUpgradeDescriptions();
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

    float descriptionHeight;
    
    Upgrade(String name, int cost, String description, PImage image1, PImage image2) {
        this.name = name;
        this.cost = cost;
        this.description = description;
        this.image1 = image1;
        this.image2 = image2;
    }

    void setWrappedDescription() {
        description = wrapText(description, floor(corner * 0.62));
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
}