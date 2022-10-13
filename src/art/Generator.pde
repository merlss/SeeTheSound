class Generator {

  float circleRad;
  float gamma;

  int strokeCount;
  int lineLength;

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

  void initShape() {

    pushMatrix();

    startX = 400;
    startY = 300;

    translate(startX, startY);

    strokeCount = (int)random(6, 9);
    lineLength = 10;
    circleRad = 100;


    for (int i = 0; i < strokeCount; i++) {

      currPoints_x[i] = 0;
      currPoints_y[i] = 0;

      endPoints_x[i] = random(circleRad-60, circleRad+60) * cos(theta);
      endPoints_y[i] = random(circleRad-60, circleRad+60) * sin(theta);

      theta += strokeCount+1;
    }

    popMatrix();
  }

  void drawShape() {

    if (lineLength > 0) {

      println(lineLength);

      pushMatrix();

      translate(startX, startY);

      for (int i = 0; i < strokeCount; i++) {

        strokeWeight((int)random(7, 13));

        println("currX: " + currPoints_x[i] + "   currY: " + currPoints_y[i]);
        println("endX: " + endPoints_x[i] + "   endY: " + endPoints_y[i]);

        float x = endPoints_x[i] / 5;
        float y = endPoints_y[i] / 5;

        //constrain(x, 0, currPoints_x[i] + 20);
        //constrain(y, 0, currPoints_y[i] + 20);

        x += random(-20, 20);
        y += random(-20, 20);

        float nextX = currPoints_x[i] + x;
        float nextY = currPoints_y[i] + y;

        println("nextX: " + nextX);
        println("nextY: " + nextY);

        line(currPoints_x[i], currPoints_y[i], nextX, nextY);

        currPoints_x[i] = nextX;
        currPoints_y[i] = nextY;


        //ellipse(currPoints_x[i], currPoints_y[i], 5, 5);
        //ellipse(endPoints_x[i], endPoints_y[i], 5, 5);

      }
      popMatrix();
      lineLength--;

      println(lineLength);
    }
  }


/*
  void drawLines(startX, startY) {

    float stepX = 3;
    float stepY = 4;

    //float endX = startX + stepX;
    //float endY = startY + stepY;

    //line(x1, y1, x2, y2);

  }
  */
}
