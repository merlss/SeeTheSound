class ShapeGenerator extends Generator {

  int initRad;
  float[] allPoints_x = new float[100];
  float[] allPoints_y = new float[100];

  ArrayList<Stroke> strokes = new ArrayList<Stroke>();

  ShapeGenerator(float _startX, float _startY, int _rad, color _col) {
    super(_startX, _startY, _rad, _col);

    initRad = _rad;

  }

  void initShape() {
    pushMatrix();

    translate(startX, startY);

    stroke(col);
    float r = map(circleRad, 5, 80, 3, 8);
    strokeCount = (int)r;


    for (int i = 0; i < strokeCount; i++) {

      Stroke stroke = new Stroke();
      stroke.addPoint(0, 0, circleRad+5);
      strokes.add(stroke);

      currPoints_x[i] = 0;
      currPoints_y[i] = 0;

      endPoints_x[i] = random(circleRad*2, circleRad*4) * cos(theta);
      endPoints_y[i] = random(circleRad*2, circleRad*4) * sin(theta);

      theta += strokeCount+1;
    }

    popMatrix();
  }

  void redrawShape() {

    pushMatrix();
    translate(startX, startY);

    for (int s = 0; s < strokes.size(); s++) {

      Stroke stroke = strokes.get(s);

      FloatList strokePointList_x = stroke.getStrokeX();
      FloatList strokePointList_y = stroke.getStrokeY();

      for (int i = 0; i < strokePointList_x.size()-1; i++) {
        float x1 = strokePointList_x.get(i);
        float x2 = strokePointList_x.get(i+1);
        float y1 = strokePointList_y.get(i);
        float y2 = strokePointList_y.get(i+1);
        stroke(col);
        drawLine(x1, y1, x2, y2, stroke.getWeight(i));
      }
    }
    popMatrix();

    if (!isFinalDrawed()) {
      drawShape();
    }
  }

  void drawShape() {

    if (circleRad > 0) {

      pushMatrix();
      translate(startX, startY);

      for (int i = 0; i < strokeCount; i++) {

        float x = endPoints_x[i] / 10;
        float y = endPoints_y[i] / 10;

        x += random(-10, 10);
        y += random(-10, 10);

        float nextX = currPoints_x[i] + x;
        float nextY = currPoints_y[i] + y;

        stroke(col);
        int w = circleRad + 5;
        drawLine(currPoints_x[i], currPoints_y[i], nextX, nextY, w);

        currPoints_x[i] = nextX;
        currPoints_y[i] = nextY;

        strokes.get(i).addPoint(nextX, nextY, w);
      }

      popMatrix();
      circleRad -= 1;
    }
    else {
      isDrawed = true;
    }
  }

  void drawLine(float x1, float y1, float x2, float y2, int weight) {

    strokeWeight(weight);
    strokeJoin(ROUND);
    strokeCap(ROUND);

    line(x1, y1, x2, y2);
  }
}
