class Generator {

  int circleRad;
  float gamma;

  int strokeCount;

  float xoff = 0.0;

  float offX;
  float offY;

  float startX;
  float startY;

  float theta = 0;

  float[] currPoints_x = new float[10];
  float[] currPoints_y = new float[10];
  float[] endPoints_x = new float[10];
  float[] endPoints_y = new float[10];

  boolean isDrawed = false;

  void initShape(float midX, float midY, int rad) {

    pushMatrix();

    startX = midX;
    startY = midY;
    circleRad = rad;    // something between 20 and 200

    translate(startX, startY);

    strokeCount = (int)random(3, 8);

    for (int i = 0; i < strokeCount; i++) {

      currPoints_x[i] = 0;
      currPoints_y[i] = 0;

      endPoints_x[i] = random(circleRad, circleRad*2) * cos(theta);
      endPoints_y[i] = random(circleRad, circleRad*2) * sin(theta);

      theta += strokeCount+1;
    }

    popMatrix();
  }

  void drawShape() {

    if (circleRad > 0) {

      strokeWeight(circleRad/2);
      //strokeWeight(5);

      //println(circleRad);

      pushMatrix();

      translate(startX, startY);

      for (int i = 0; i < strokeCount; i++) {

        //strokeWeight((int)random(7, 13));

        /*
        float x = endPoints_x[i] / abs(endPoints_x[i]);
        float y = endPoints_y[i] / abs(endPoints_y[i]);

        float nextX = noise((currPoints_x[i] + x) * 2);
        float nextY = noise((currPoints_y[i] + y) * 2);*/

        float x = endPoints_x[i] / 10;
        float y = endPoints_y[i] / 10;

        x += random(-10, 10);
        y += random(-10, 10);

        float nextX = currPoints_x[i] + x;
        float nextY = currPoints_y[i] + y;

        line(currPoints_x[i], currPoints_y[i], nextX, nextY);

        currPoints_x[i] = nextX;
        currPoints_y[i] = nextY;


        //ellipse(currPoints_x[i], currPoints_y[i], 5, 5);
        //ellipse(endPoints_x[i], endPoints_y[i], 5, 5);

      }
      popMatrix();
      circleRad--;
    }
    else {
      isDrawed = true;
    }
  }

  boolean isFinalDrawed() {
    return isDrawed;
  }
}
