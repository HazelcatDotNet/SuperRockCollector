void drawUi() {
  imageMode(CORNER);
  image(background, 0, 0, width, height);

  textSize(corner / 3);
  String totalRocksText = int(totalRocks) + "\nrocks";
  fill(0, 0, 0);
  text(totalRocksText, corner / 3, corner / 3);
  // circle(corner, corner, 5);
}
