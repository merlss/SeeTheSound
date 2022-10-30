class KeyboardData extends Art {

  KeyboardData() {
    super();
  }

  void initNewShape(float value, color col) {

    int size = 0;

    if (value > 500) {
      size = (int)map(value, 400, 623, 150, 50);
      initCircle(size, col);
    }
    else {

      size = (int)map(value, 260, 400, 50, 10);
      initSplash(size, col);
    }
  }

  /*

  void continueCircle() {

    for (int i = 0; i < circles.size(); i++) {
      circles.get(i).drawShape();
    }
  }

  void continueSplash() {

    for (int i = 0; i < shapes.size(); i++) {
      ShapeGenerator thisShape = shapes.get(i);
      if (!thisShape.isFinalDrawed()) {
        thisShape.drawShape();
      }
    }
  }*/
}
