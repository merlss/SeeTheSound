/*
Merle Krauss
*/

// drawes the circle shape
class CircleGenerator extends Generator {

  int blur = 5;
  int minSize = 25;

  CircleGenerator(float _startX, float _startY, int _rad, color _col) {
    super(_startX, _startY, _rad, _col);

  }

// draws the circle one time smaller every time the function is called
  void drawShape() {

    pushMatrix();

    translate(startX, startY);

    fill(col);
    noStroke();
    ellipse(0, 0, circleRad, circleRad);

    popMatrix();

    if (circleRad > minSize) {
      circleRad -= 1;
    }
    else {
      circleRad = minSize;
    }
  }

// called every frame
  void redrawShape() {

    pushMatrix();

    translate(startX, startY);

    fill(col);
    noStroke();
    ellipse(0, 0, circleRad, circleRad);

    popMatrix();
  }
}
