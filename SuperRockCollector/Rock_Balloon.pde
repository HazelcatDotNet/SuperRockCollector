class BalloonRock extends Rock {
    int msCharged = 0;
    int maxChargeTime = 3000; // milliseconds to reach max charge
    float displayCharge = 0; // tracks visual scaling during and after movement
    PVector velocity = new PVector(0, 0);
    HashSet<String> collidedRockIds = new HashSet<String>(); // track rocks hit during this flight

    float friction = 0.6; // deceleration factor per frame (0-1)
    float maxSpeed = 1250; // pixels per second at full charge
    float maxScaleMultiplier = 0.6; // max size increase (1.0 + 0.4 = 1.4x)
    float deflationSeconds = 1; // time in seconds to fully deflate
    boolean isMovingFree = false;
    int lastFrameTime = 0;

    BalloonRock() {
      rockType = RockType.BALLOON;
      rockFileName = "balloon";
      super.setImage();
      lastFrameTime = millis();
    }

    @Override void runExtraOnClickActions() {
        objectHeldByMouse = this;
        holdingObject = true;
        frozen = true;
    }
    
    @Override int rocksCollectedUponClick() {
        return 0;
    }

    void onRelease() {
        objectHeldByMouse = null;
        holdingObject = false;
        frozen = false;
        if (msCharged > maxChargeTime) msCharged = maxChargeTime;
        
        // Launch in a random direction
        float angle = random(TWO_PI);
        float chargePercent = msCharged / (float)maxChargeTime;
        float launchSpeed = maxSpeed * chargePercent;
        
        velocity.x = cos(angle) * launchSpeed;
        velocity.y = sin(angle) * launchSpeed;
        isMovingFree = true;
        displayCharge = msCharged; // preserve visual scaling for deflation animation
        msCharged = 0;
        collidedRockIds.clear(); // reset collisions for new flight
    }

    void incrementCharge() {
        if (msCharged >= maxChargeTime) return;
        msCharged += (int)(1000.0 / frameRate);
    }

    @Override void display() {
        // Scale up the rock as it charges (while held) or deflates (after release)
        float chargeToDisplay = frozen ? msCharged : displayCharge;
        float chargePercent = chargeToDisplay / (float)maxChargeTime;
        float scaleMultiplier = 1.0 + (chargePercent * maxScaleMultiplier);
        
        rectMode(CENTER);
        imageMode(CENTER);
        setRockOpacity();
        image(img, renderLocationX(), renderLocationY(), sizeX * scaleMultiplier, sizeY * scaleMultiplier);
        setDrawOpacity(255);
    }

    @Override void move() {
        if (!isMovingFree) {
            super.move();
            lastFrameTime = millis();
            return;
        }
        
        // Calculate frame-independent delta time
        int currentTime = millis();
        float deltaTime = (currentTime - lastFrameTime) / 1000.0f; // convert to seconds
        lastFrameTime = currentTime;
        
        // Apply frame-independent friction
        float frictionPerSecond = pow(friction, deltaTime);
        velocity.mult(frictionPerSecond);
        
        // Gradually deflate the rock while moving
        float deflationRate = (float)maxChargeTime / deflationSeconds;
        displayCharge -= deflationRate * deltaTime;
        displayCharge = max(0, displayCharge);
        
        // Stop when speed reaches 2x its regular movement speed
        if (velocity.mag() < speed * frameRate * 2) {
            velocity.set(0, 0);
            isMovingFree = false;
            displayCharge = 0; // fully deflated when stopped
            runDestroyActions();
            return;
        }
        
        // Calculate new position with frame-independent movement
        float newX = loc.x + velocity.x * deltaTime;
        float newY = loc.y + velocity.y * deltaTime;
        
        // Bounce off walls (bounded by corner on left/top, width/height on right/bottom)
    
        if (newX <= corner || newX >= width) {
            velocity.x *= -1;
            newX = constrain(newX, corner, width);
        }
        
        if (newY <= corner || newY >= height) {
            velocity.y *= -1;
            newY = constrain(newY, corner, height);
        }
        
        setLocation(newX, newY);
        
        // Check for collisions with other rocks
        checkCollisionsWithRocks();
    }
    
    void checkCollisionsWithRocks() {
        // Make a copy to avoid ConcurrentModificationException
        ArrayList<Rock> rocksCopy = new ArrayList<Rock>(rocks);
        
        for (Rock rock : rocksCopy) {
            if (rock == this) continue; // don't collide with self
            if (rock instanceof BalloonRock) continue; // don't collide with other balloon rocks
            if (collidedRockIds.contains(rock.id)) continue; // already hit this rock
            
            // Check AABB collision
            if (leftEdge < rock.rightEdge && rightEdge > rock.leftEdge &&
                upEdge < rock.downEdge && downEdge > rock.upEdge) {
                collidedRockIds.add(rock.id); // mark as collided
                totalRocks += rock.onClick();
            }
        }
    }

    @Override boolean shouldDestroyOnClick() {
        return false;
    }

    @Override String getTypeSpecificData() {
        return velocity.x + "," + velocity.y + "," + displayCharge + "," + isMovingFree;
    }
}
  