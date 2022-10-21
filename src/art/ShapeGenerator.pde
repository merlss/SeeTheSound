class ShapeGenerator extends Generator {

  ShapeGenerator(float _startX, float _startY, int _rad, color _col) {
    super(_startX, _startY, _rad, _col);

  }

  void initShape() {
    pushMatrix();

    translate(startX, startY, 0);

    stroke(col);
    float r = map(circleRad, 5, 80, 3, 8);
    strokeCount = (int)r;

    for (int i = 0; i < strokeCount; i++) {

      currPoints_x[i] = 0;
      currPoints_y[i] = 0;

      endPoints_x[i] = random(circleRad*2, circleRad*4) * cos(theta);
      endPoints_y[i] = random(circleRad*2, circleRad*4) * sin(theta);

      theta += strokeCount+1;
    }

    popMatrix();
  }

  void drawShape() {

    if (circleRad > 0) {

      strokeWeight(circleRad + 5);
      strokeJoin(ROUND);
      strokeCap(ROUND);

      pushMatrix();

      translate(startX, startY, -20);
      //translate(startX, startY);

      for (int i = 0; i < strokeCount; i++) {

        float x = endPoints_x[i] / 10;
        float y = endPoints_y[i] / 10;

        x += random(-10, 10);
        y += random(-10, 10);

        float nextX = currPoints_x[i] + x;
        float nextY = currPoints_y[i] + y;

        stroke(col);
        line(currPoints_x[i], currPoints_y[i], 0, nextX, nextY, 0);
        //line(currPoints_x[i], currPoints_y[i], nextX, nextY);

        currPoints_x[i] = nextX;
        currPoints_y[i] = nextY;

      }
      popMatrix();
      circleRad--;
    }
    else {
      isDrawed = true;
    }
  }
}
