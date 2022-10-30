import processing.sound.*;


class Art {

  ArrayList<ShapeGenerator> shapes = new ArrayList<ShapeGenerator>();
  ArrayList<CircleGenerator> circles = new ArrayList<CircleGenerator>();

  // analyze
  SoundFile audioFile;
  BeatDetector beatDetector;
  FFT fft;
  Amplitude amplitude;
  Waveform waveform;
  boolean isBeat;
  int bands = 32;
  int scale = 5;
  float barWidth;
  int samples = width/2;
  PixelQueue queue;
  color defaultWaveBright;
  color defaultWaveDark;

  int shapeTrigger = 20;

  void setupArt(SoundFile file, BeatDetector beat, Amplitude amp, Waveform wave, FFT ffT, PixelQueue q, color bright, color dark ) {
    defaultWaveDark = dark;
    defaultWaveBright = bright;
    queue = q;
    beatDetector = beat;
    amplitude = amp;
    waveform = wave;
    fft = ffT;
    beatDetector.input(file);
    beatDetector.sensitivity(400);

    barWidth = width/float(bands);
    fft.input(file);

    amplitude.input(file);

    waveform.input(file);
  }

  color generateFFTColor(int brightness, int intensity) {

    float[] sum = new float[bands];
    float multiply = 200;
    float r, g, b;

    fft.analyze();
    for (int i = 0; i < bands; i++) {
      sum[i] += (fft.spectrum[i] - sum[i]) * multiply;
      //println(i + " :  " + sum[i]);
    }

    // red
    if (sum[4] < sum[7]+sum[9]) {
      r = 255 - sum[1] - sum[2] - intensity;
      g = sum[5] + sum[6] + brightness;
      b = sum[3] + sum[4] + brightness;
    }
    // green
    else if (sum[2] < sum[3]) {
      r = sum[5] + sum[6] + brightness;
      g = 255 - sum[1] - sum[2] - sum[3] - intensity;
      b = sum[2] + sum[3] + brightness;
    }
    // blue
    else {
      r = sum[2] + sum[4] + brightness;
      g = sum[5] + sum[6] + brightness;
      b = 255 - sum[1] - sum[3] - intensity;
    }

    constrain(r, 10, 200);
    constrain(g, 10, 200);
    constrain(b, 10, 200);

    color col = color(r, g, b);

    return col;
  }

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

    //int ampScale = (int)(amplitude.analyze() * (height/4) * 2);
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
    /*for (int col = 0; col < width/2; col++) {

      int offset = (int)map(waveform.data[col], -1, 1, -height/4, height/4);

      println(offset);

      for (int row = 0; row < height; row++) {
        if (mid - abs(offset) <= row && mid + abs(offset) >= row) {
          pixels[row * width + col*2] = cDark;
          pixels[row * width + col*2 + 1] = cDark;
        }
        else {
          pixels[row * width + col*2] = cBright;
          pixels[row * width + col*2 + 1] = cBright;
        }
      }
    }*/
    updatePixels();
  }

  void initShapes() {

    if (beatDetector.isBeat()) {

      int beatEnergy = getBeatEnergy();

      if (beatEnergy > shapeTrigger) {
        shapeTrigger = beatEnergy - 5;

        float x = random(30, width-30);
        float y = random(30, height-30);
        float amp = map(getAmplitude(), 0, 1, 0, 40);
        println("Shape   " + amp);
        color col = generateFFTColor(-10, 50);
        ShapeGenerator gen = new ShapeGenerator(x, y, (int)amp, col);
        gen.initShape();
        gen.drawShape();
        shapes.add(gen);

      }
      else if (beatEnergy > 5) {

        float x = random(50, width-50);
        float y = random(50, height-50);
        float amp = map(getAmplitude(), 0, 1, 20, 150);
        println("Circle   " + amp);
        color col = generateFFTColor(100, 0);
        CircleGenerator gen = new CircleGenerator(x, y, (int)amp, col);
        circles.add(gen);
        gen.drawShape();

      }
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

  void redraw() {
    for (int i = 0; i < circles.size(); i++) {
      circles.get(i).redrawShape();
    }

    for (int i = 0; i < shapes.size(); i++) {
      shapes.get(i).redrawShape();
    }
  }
}
