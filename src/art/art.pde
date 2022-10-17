import processing.sound.*;

Generator gen1;
ArrayList<Generator> shapes = new ArrayList<Generator>();

// analyze
SoundFile sample;
BeatDetector beatDetector;
boolean isBeat;
FFT fft;
int bands = 16;
float[] fftSpec = new float[bands];
int scale = 5;
float smoothingFactor = 0.1;
float barWidth;



void setup() {

  size(displayWidth, displayHeight);
  background(255);
  stroke(100);
  smooth();
  frameRate(16);

  sample = new SoundFile(this, "ChillLofi.mp3");
  sample.loop();
  sample.play();

  setAnalyze();

}

void draw() {

  if (beatDetector.isBeat()) {

    double[] energyBuffer = beatDetector.getEnergyBuffer();
    double max = getMax(energyBuffer);

    if (max > 9) {
      fftSpec = getFFTSprectrum();
      int r = (int)max;

      Generator gen = new Generator();
      shapes.add(gen);
      println("New Shape   " + r);
      gen.initShape(random(20, displayWidth-20), random(20, displayHeight-20), r);
      gen.drawShape();
    }
  }

  for (int i = 0; i < shapes.size(); i++) {
    Generator thisShape = shapes.get(i);
    if (thisShape.isFinalDrawed()) {
      shapes.remove(i);
    }
    else {
      thisShape.drawShape();
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

float[] getFFTSprectrum() {

  float[] sum = new float[bands];

  fft.analyze();

  for (int i = 0; i < bands; i++) {
    sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;
  }
  return sum;
}

double getMax(double[] list) {
  double max = 0;
  for (int i = 0; i < list.length; i++) {
    if (list[i] > max) {
      max = list[i];
    }
  }
  return max;
}
