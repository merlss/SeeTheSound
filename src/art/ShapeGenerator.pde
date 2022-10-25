class ShapeGenerator extends Generator {

  int initRad;
  float[] allPoints_x = new float[100];
  float[] allPoints_y = new float[100];

  ArrayList<Stroke> strokes = new ArrayList<Stroke>;

  ShapeGenerator(float _startX, float _startY, int _rad, color _col) {
    super(_startX, _startY, _rad, _col);

    initRad = _rad;

  }

  void initShape() {
    pushMatrix();

    translate(startX, startY, 0);

    stroke(col);
    float r = map(circleRad, 5, 80, 3, 8);
    strokeCount = (int)r;

    for (int i = 0; i < strokeCount; i++) {

      strokes.get(i).addPoint(0, 0);

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
    translate(startX, startY, 0);

    for (int s = 0; s < strokes.size(); s++) {

      Stroke stroke = strokes.get(s);

      ArrayList<float> x = stroke.getStrokeX();
      ArrayList<float> y = stroke.getStrokeY();

      for (int i = 0; i < x.size()-1; i++) {
        drawLine(x.get(i), y.get(i), 0, x.get(i+1), y.get(i+1), 0, stroke.getWeight(s))
      }
    }
    popMatrix();
  }

  void drawShape() {

      pushMatrix();
      translate(startX, startY, 0);

      for (int i = 0; i < strokeCount; i++) {

        float x = endPoints_x[i] / 10;
        float y = endPoints_y[i] / 10;

        //x += random(-10, 10);
        //y += random(-10, 10);

        float nextX = currPoints_x[i] + x;
        float nextY = currPoints_y[i] + y;

        stroke(col);
        int w = rad + 5;
        drawLine(currPoints_x[i], currPoints_y[i], 0, nextX, nextY, 0, w);

        currPoints_x[i] = nextX;
        currPoints_y[i] = nextY;

        strokes.get(i).addPoint(nextX, nextY, w);
      }
      popMatrix();
    }
    if (circleRad > 0) {
      circleRad -= 1;
    }
  }

  void drawLine(float x1, float y1, float z1, float x2, float y2, float z2, int weight) {

    strokeWeight(weight);

    float w = round(weight/8);

    line(x1, y1, z1, x2, y2, z2);
    ellipse(x1, y1, w, w);
    ellipse(x2, y2, w, w);
  }
}
