/*
Merle Krauss
*/

import processing.sound.*;

// parent class to combine sound data with shapes
class Art {

  ArrayList<ShapeGenerator> shapes = new ArrayList<ShapeGenerator>();
  ArrayList<CircleGenerator> circles = new ArrayList<CircleGenerator>();

  PixelQueue queue;
  color defaultWaveBright;
  color defaultWaveDark;

// analyze the energy of the beatDetector
  int getBeatEnergy() {

    double[] buffer = beatDetector.getEnergyBuffer();
    double max = 0;

    for (int i = 0; i < buffer.length; i++) {
      if (buffer[i] > max) {
        max = buffer[i];
      }
    }
    return (int)max;
  }

// analyze the amplitude
  float getAmplitude(Amplitude a) {

    float ampScale = a.analyze();
    return ampScale;
  }

// sets the initial values of the splash shape
  void initSplash(int size, color col) {

    float x = random(30, width-30);
    float y = random(30, height-30);
    ShapeGenerator gen = new ShapeGenerator(x, y, size, col);
    shapes.add(gen);
    gen.initShape();
    gen.drawShape();
  }

// sets the initial values of the circle shape
  void initCircle(int size, color col) {

    float x = random(50, width-50);
    float y = random(50, height-50);
    CircleGenerator gen = new CircleGenerator(x, y, size, col);
    circles.add(gen);
    gen.drawShape();
  }

// continue the splash shape with one more line
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

// is called every frame after everything is cleared
  void redraw() {
    for (int i = 0; i < circles.size(); i++) {
      circles.get(i).redrawShape();
    }

    for (int i = 0; i < shapes.size(); i++) {
      shapes.get(i).redrawShape();
    }
  }
}
