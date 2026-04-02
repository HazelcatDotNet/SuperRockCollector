void drawUi() {
  imageMode(CORNER);
  image(background, 0, 0, width, height);

  drawMaisy();

  textSize(corner / 3);
  textAlign(LEFT);
  String totalRocksText = int(totalRocks) + "\nrocks";
  fill(0, 0, 0);
  text(totalRocksText, corner / 3, corner / 3);
  // circle(corner, corner, 5);
}

void animateDrawing(PImage img1, PImage img2, float imgX, float imgY, float imgSizeX, float imgSizeY, int millisBetweenChanges) {
  int phase = (millis() / millisBetweenChanges) % 2;
  PImage imgToDraw = (phase == 0) ? img1 : img2;

  imageMode(CENTER);
  image(imgToDraw, imgX, imgY, imgSizeX, imgSizeY);
}

void drawMaisy() {
  imageMode(CENTER);
  animateDrawing(maisy1, maisy2, screenSize / 2, corner / 2, corner, corner, 500);
  
  drawMaisyText();
}

void drawMaisySpeechBubble() {
  imageMode(CENTER);
  float speechBubbleX = screenSize * (3.08 / 4.0);
  float speechBubbleY = corner / 2;
  float speechBubbleWidth = corner * 2.7;
  float speechBubbleHeight = corner * 0.9;
  animateDrawing(maisySpeechBubble1, maisySpeechBubble2, speechBubbleX, speechBubbleY, speechBubbleWidth, speechBubbleHeight, 250);
}

// draws maisy's speech bubble, and the text inside it, if she is talking. also makes the noises :)
void drawMaisyText() {
  if (maisyIsTalking) {
    
    // check if it's time for maisy to stop talking
    if (millis() >= maisyShouldStopTalkingMillis) {
      
      // if maisy is done talking, set maisyIsTalking = false
      if (maisyTalkingTextLines.isEmpty()) {
        maisyIsTalking = false;
        
        // and if maisy still has more lines in her monologue
      } else {
        getNextMaisyLine(-1);
      }
      
    }
    
    drawMaisySpeechBubble();
    
    // make the maisy noises while she talks
    if (maisySoundsRemaining > 0 && intervalMs(maisyTalkSoundMsInterval)) {
      maisyTalkSound.play();
      maisySoundsRemaining--;
    }
    
    // draw the monologue text
    textSize(corner / 5);
    String wrappedText = wrapText(maisyTalkingText, maisyTextLineCharLimit);
    text(wrappedText, screenSize / 1.6, corner / 3.25);
  }
}

void loadRockImages() {
  for (int i = 0; i < rockFileNames.length; i++) {
    String rockFileName = rockFileNames[i];
    String filePath = "../data/art/rocks/" + rockFileName + ".png";
    rockImages.put(rockFileName, loadImage(filePath));
  }
}

// used for debugging
void drawMaisyHexagonHitbox() {
  float centerX = screenSize / 2;
  float centerY = corner / 2;
  float radius = corner / 2;

  noFill();
  stroke(255, 0, 0); // red outline
  strokeWeight(2);
  ellipse(centerX, centerY, radius * 2, radius * 2);
}

String wrapText(String text, int maxCharCount) {
  String[] words = split(text, ' ');
  String result = "";
  String line = "";

  for (int i = 0; i < words.length; i++) {
    String word = words[i];

    // If adding this word exceeds the limit, wrap
    if (line.length() + word.length() + 1 > maxCharCount) {
      result += line + "\n";
      line = word;
    } else {
      if (line.length() > 0) line += " ";
      line += word;
    }
  }

  // Add last line
  result += line;

  return result;
}
