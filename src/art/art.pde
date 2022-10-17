import processing.sound.*;

Generator gen1;
ArrayList<Generator> shapes = new ArrayList<Generator>();

// analyze
SoundFile sample;
BeatDetector beatDetector;
boolean isBeat;
FFT fft;
int bands = 32;
int scale = 5;
float barWidth;


void setup() {

  size(displayWidth, displayHeight);
  background(255);
  smooth();
  frameRate(16);

  sample = new SoundFile(this, "Power.mp3");
  sample.play();

  setAnalyze();

}

void draw() {

  if (beatDetector.isBeat()) {

    double max = getBeatEnergy();

    if (max > 9) {
      int r = (int)max;
      //println("New Shape   " + r);

      color col = generateColor();
      Generator gen = new Generator(random(30, displayWidth-30), random(30, displayHeight-30), r, col);
      shapes.add(gen);
      gen.initShape();
      gen.drawShape();
    }
  }

  for (int i = 0; i < shapes.size(); i++) {
    Generator thisShape = shapes.get(i);
    if (!thisShape.isFinalDrawed()) {
      thisShape.drawShape();
    }
    else {
      shapes.remove(i);
    }
  }
}

void setAnalyze() {

  // beat
  beatDetector = new BeatDetector(this);
  beatDetector.input(sample);
  beatDetector.sensitivity(140);

  // fft
  barWidth = width/float(bands);
  fft = new FFT(this, bands);
  fft.input(sample);

}

color generateColor() {

  //float r, float g, float b

  float[] sum = new float[bands];
  float multiply = 200;
  float r, g, b;

  fft.analyze();

  for (int i = 0; i < bands; i++) {
    sum[i] += (fft.spectrum[i] - sum[i]) * multiply;
  }

  r = 255 - sum[1] + sum[5];
  g = 255 - sum[2] + sum[6];
  b = 255 - sum[3] + sum[7];

  constrain(r, 0, 255);
  constrain(g, 0, 255);
  constrain(b, 0, 255);

  color col = color(r, g, b);

  return col;

}

double getBeatEnergy() {

  double[] buffer = beatDetector.getEnergyBuffer();
  double max = 0;

  for (int i = 0; i < buffer.length; i++) {
    if (buffer[i] > max) {
      max = buffer[i];
    }
  }
  return max;
}
