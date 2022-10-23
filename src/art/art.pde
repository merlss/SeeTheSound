import processing.sound.*;

ArrayList<ShapeGenerator> shapes = new ArrayList<ShapeGenerator>();
ArrayList<CircleGenerator> circles = new ArrayList<CircleGenerator>();

// analyze
SoundFile sample;
BeatDetector beatDetector;
FFT fft;
Amplitude amplitude;
Waveform waveform;
boolean isBeat;
int bands = 32;
int scale = 5;
float barWidth;
int samples = 100;


void setup() {

  size(displayWidth, displayHeight, P3D);
  background(255);
  smooth();
  frameRate(16);
  hint(DISABLE_OPTIMIZED_STROKE);

  sample = new SoundFile(this, "Power.mp3");
  sample.play();

  beatDetector = new BeatDetector(this);
  beatDetector.input(sample);
  beatDetector.sensitivity(140);

  barWidth = width/float(bands);
  fft = new FFT(this, bands);
  fft.input(sample);

  amplitude = new Amplitude(this);
  amplitude.input(sample);

  waveform = new Waveform(this, samples);
  waveform.input(sample);

  smooth();

}

void draw() {

  drawShape();

  //drawBackground();

}

void drawBackground() {

  int amp = getAmplitude();

  if (amp > 300) {
    waveform.analyze();
    float waveValueX = random(width);
    float waveValueY = map(waveform.data[0], -1, 1, 0, height);
    color col = generateFFTColor(0);
    CircleGenerator gen = new CircleGenerator(waveValueX, waveValueY, amp, col);
    gen.setDepth(10);
    circles.add(gen);
    gen.drawShape();
  }
}

void drawShape() {
  if (beatDetector.isBeat()) {

    int beatEnergy = getBeatEnergy();

    if (beatEnergy > 15) {
      float waveValueX = random(30, displayWidth-30);
      float waveValueY = random(30, displayHeight-30);
      color col = generateFFTColor(20);
      ShapeGenerator gen = new ShapeGenerator(waveValueX, waveValueY, beatEnergy, col);
      shapes.add(gen);
      gen.initShape();
      gen.drawShape();
    }
  }

  for (int i = 0; i < shapes.size(); i++) {
    ShapeGenerator thisShape = shapes.get(i);
    if (!thisShape.isFinalDrawed()) {
      thisShape.drawShape();
    }
    else {
      shapes.remove(i);
    }
  }
}

color generateFFTColor(int intensity) {

  float[] sum = new float[bands];
  float multiply = 200;
  float r, g, b;

  fft.analyze();
  for (int i = 0; i < bands; i++) {
    sum[i] += (fft.spectrum[i] - sum[i]) * multiply;
    println(i + " :  " + sum[i]);
  }


/*
  r = 255 - sum[1] + sum[5];
  g = 255 - sum[2] + sum[6];
  b = 255 - sum[3] + sum[7];

  r -= intensity;
  g -= intensity;
  b -= intensity;

  constrain(r, 0, 255);
  constrain(g, 0, 255);
  constrain(b, 0, 255);

  color col = color(r, g, b);*/

  color col = color(20, 20, 20);

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
  println(ampScale);

  return ampScale;
}
