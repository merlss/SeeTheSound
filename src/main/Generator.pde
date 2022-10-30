class Generator {

  int circleRad;
  int strokeCount;
  int depth = 0;

  float startX;
  float startY;
  color col;

  float theta = 0;

  float[] currPoints_x = new float[20];
  float[] currPoints_y = new float[20];
  float[] endPoints_x = new float[20];
  float[] endPoints_y = new float[20];

  boolean isDrawed = false;

  Generator(float _startX, float _startY, int _rad, color _col) {

    startX = _startX;
    startY = _startY;
    circleRad = _rad;    // something between 20 and 200
    col = _col;
  }

  void initShape() {}

  void drawShape() {}

  boolean isFinalDrawed() {
    return isDrawed;
  }

  void setDepth(int v) {
    depth = v;
  }
}
