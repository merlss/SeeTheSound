class CircleGenerator extends Generator {

  int blur = 5;

  CircleGenerator(float _startX, float _startY, int _rad, color _col, int _depth) {
    super(_startX, _startY, _rad, _col);

    depth = _depth;

  }

  void drawShape() {

    pushMatrix();

    translate(startX, startY);

    fill(col);
    noStroke();
    ellipse(0, 0, circleRad, circleRad);
    filter(BLUR, blur);

    popMatrix();

  }
}
