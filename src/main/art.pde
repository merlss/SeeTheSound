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
  int samples = 100;

  void setupArt(SoundFile file, BeatDetector beat, Amplitude amp, Waveform wave, FFT ffT ) {
    beatDetector = beat;
    amplitude = amp;
    waveform = wave;
    fft = ffT;
    beatDetector.input(file);
    beatDetector.sensitivity(140);

    barWidth = width/float(bands);
    fft.input(file);

    amplitude.input(file);

    waveform.input(file);
  }

  void drawBackground() {

    int amp = getAmplitude();

    if (amp > 300) {
      waveform.analyze();
      float waveValueX = random(width);
      float waveValueY = map(waveform.data[0], -1, 1, 0, height);
      color col = generateFFTColor(100, 0);
      //color col = color(80);
      CircleGenerator gen = new CircleGenerator(waveValueX, waveValueY, amp, col, -20);
      //gen.setDepth(10);
      circles.add(gen);
      gen.drawShape();
    }
  }

  void drawShape() {
    if (beatDetector.isBeat()) {

      int beatEnergy = getBeatEnergy();
      println(beatEnergy);

      if (beatEnergy > 30) {
        float waveValueX = random(30, displayWidth-30);
        float waveValueY = random(30, displayHeight-30);
        color col = generateFFTColor(-10, 50);
        int radius = beatEnergy - 20;
        ShapeGenerator gen = new ShapeGenerator(waveValueX, waveValueY, radius, col);
        gen.initShape();
        gen.drawShape();
        shapes.add(gen);
      }
    }

    /*
      for (int i = 0; i < shapes.size(); i++) {
        ShapeGenerator thisShape = shapes.get(i);
        if (!thisShape.isFinalDrawed()) {
          thisShape.drawShape();
        }
        else {
          shapes.remove(i);
        }
      }*/
  }

  color generateFFTColor(int brightness, int intensity) {

    float[] sum = new float[bands];
    float multiply = 200;
    float r, g, b;

    fft.analyze();
    for (int i = 0; i < bands; i++) {
      sum[i] += (fft.spectrum[i] - sum[i]) * multiply;
      println(i + " :  " + sum[i]);
    }

    // red
    if (sum[4] < sum[7]+sum[8]) {
      r = 255 - sum[1] - sum[2] - intensity;
      g = sum[5] + sum[6] + brightness;
      b = sum[3] + sum[4] + brightness;
    }
    // blue
    else if (sum[2] < sum[3]) {
      r = sum[2] + sum[4] + brightness;
      g = sum[5] + sum[6] + brightness;
      b = 255 - sum[1] - sum[3] - intensity;
    }
    // green
    else {
      r = sum[5] + sum[6] + brightness;
      g = 255 - sum[1] - sum[2] - intensity;
      b = sum[2] + sum[3] + brightness;
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

  int getAmplitude() {

    int ampScale = (int)(amplitude.analyze() * (height/4) * 2);

    return ampScale;
  }
}
