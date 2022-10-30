import processing.sound.*;

class SelfmadeArt {

  ArrayList<ShapeGenerator> shapes = new ArrayList<ShapeGenerator>();
  ArrayList<CircleGenerator> circles = new ArrayList<CircleGenerator>();

  void setupSelfmadeArt() {

  }

  void drawNewShape(float value, color col) {

    int size = 0;

    if (value > 400) {
      size = (int)map(value, 400, 623, 150, 50);
      float x = random(50, width-50);
      float y = random(50, height-50);
      CircleGenerator gen = new CircleGenerator(x, y, size, col);
      circles.add(gen);
      gen.drawShape();
    }
    else {
      size = (int)map(value, 260, 400, 50, 10);
      float x = random(30, width-30);
      float y = random(30, height-30);
      ShapeGenerator gen = new ShapeGenerator(x, y, size, col);
      gen.initShape();
      gen.drawShape();
      shapes.add(gen);
    }
  }

  void drawSplash() {
    for (int i = 0; i < circles.size(); i++) {
      circles.get(i).drawShape();
    }

    for (int i = 0; i < shapes.size(); i++) {
      ShapeGenerator thisShape = shapes.get(i);
      if (!thisShape.isFinalDrawed()) {
        thisShape.drawShape();
      }
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

  void redraw() {
    for (int i = 0; i < circles.size(); i++) {
      circles.get(i).redrawShape();
    }

    for (int i = 0; i < shapes.size(); i++) {
      shapes.get(i).redrawShape();
    }
  }
}
