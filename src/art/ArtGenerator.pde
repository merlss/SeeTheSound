class ArtGenerator{

  float circle_x, circle_y;

  float xLine_1;
  float yLine_1;
  float xLine_2;
  float yLine_2;
  float xLine_3;
  float yLine_3;

  int lineCount;

  void drawLinesx() {

    float xstep = 10;
    float ystep = 10;
    float lastx = 200;
    float lasty = 400;
    float y = 50;

    for (int x=20; x<=480; x+=xstep) {
      ystep = random(20) - 10;
      y += ystep;
      line(x, y, lastx, lasty);
      lastx = x;
      lasty = y;
    }
  }

  void initShape(int count) {

    lineCount = count;

    //line_x = random(20, width - 20);
    //line_y = random(20, height - 20);

    xLine_1 = 400;
    yLine_1 = 300;
    xLine_2 = 400;
    yLine_2 = 300;
    xLine_3 = 400;
    yLine_3 = 300;

  }

  void drawLines() {

    if (lineCount > 0) {

      float step_x = random(0, 20);
      float step_y = random(0, 20);

      float nextLine_x;
      float nextLine_y;

      int strokeNum = (int)random(3, 8);

      for (int i=1; i < strokeNum; i++) {

        if (i % 3 == 0) {
          nextLine_x = xLine_1 - step_x;
          nextLine_y = yLine_1 - step_y;
          line(xLine_1, yLine_1, nextLine_x, nextLine_y);

          xLine_1 = nextLine_x;
          yLine_1 = nextLine_y;
        }
        else if (i % 2 == 0) {
          nextLine_x = xLine_2 + step_x;
          nextLine_y = yLine_2 - step_y;
          line(xLine_2, yLine_2, nextLine_x, nextLine_y);

          xLine_2 = nextLine_x;
          yLine_2 = nextLine_y;
        }
        else {
          nextLine_x = xLine_3 - step_x;
          nextLine_y = yLine_3 + step_y;
          line(xLine_3, yLine_3, nextLine_x, nextLine_y);

          xLine_3 = nextLine_x;
          yLine_3 = nextLine_y;
        }


      }

      lineCount--;
    }
  }

  void drawCircle() {

    float radius = 10;
    int centerX = 400;
    int centerY = 300;

    stroke(0, 30);
    noFill();
    ellipse(centerX, centerY, radius*2, radius*2);

    stroke(20, 50, 70);
    //strokeWeight(1);
    float lastX = -999;
    float lastY = -999;
    float radiusNoise = random(10);

    for (float ang = 0; ang <= 1440; ang += 5) {
      radiusNoise += 0.05;
      radius += 0.5;
      float currRad = radius + (noise(radiusNoise) * 200) - 100;
      float rad = radians(ang);
      circle_x = centerX + (currRad * cos(rad));
      circle_y = centerY + (currRad * sin(rad));

      if (lastX > -999) {
        line(circle_x, circle_y, lastX, lastY);
      }

      lastX = circle_x;
      lastY = circle_y;
    }
  }
}
