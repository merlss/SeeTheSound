import processing.sound.*;


class Art {

  ArrayList<ShapeGenerator> shapes = new ArrayList<ShapeGenerator>();
  ArrayList<CircleGenerator> circles = new ArrayList<CircleGenerator>();

  PixelQueue queue;
  color defaultWaveBright;
  color defaultWaveDark;

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

  float getAmplitude() {

    float ampScale = amplitude.analyze();
    return ampScale;
  }

  void drawWave() {

    loadPixels();

    waveform.analyze();
    int mid = height / 2;

    Column column = new Column(waveform.data[0], defaultWaveDark, defaultWaveBright);
    if (queue.size == width-1) {
      queue.dequeue();
      queue.dequeue();

    }
    queue.enqueue(column);
    queue.enqueue(column);

    queue.drawPixels();

    updatePixels();
  }

  void initSplash(int size, color col) {

    float x = random(30, width-30);
    float y = random(30, height-30);
    ShapeGenerator gen = new ShapeGenerator(x, y, size, col);
    shapes.add(gen);
    gen.initShape();
    gen.drawShape();
  }

  void initCircle(int size, color col) {

    float x = random(50, width-50);
    float y = random(50, height-50);
    CircleGenerator gen = new CircleGenerator(x, y, size, col);
    circles.add(gen);
    gen.drawShape();
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

  void redraw() {
    for (int i = 0; i < circles.size(); i++) {
      circles.get(i).redrawShape();
    }

    for (int i = 0; i < shapes.size(); i++) {
      shapes.get(i).redrawShape();
    }
  }
}
