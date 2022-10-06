import processing.sound.*;

SoundFile sample;

// beat
BeatDetector beatDetector;
boolean isBeat;

// fft
FFT fft;
int bands = 16;
float smoothingFactor = 0.1;
float[] sum = new float[bands];
int scale = 5;
float barWidth;


void setup() {

  size(640, 360);

  sample = new SoundFile(this, "Sound2.mp3");
  sample.loop();
  sample.play();

  // beat
  beatDetector = new BeatDetector(this);
  beatDetector.input(sample);
  beatDetector.sensitivity(140);

  // fft
  barWidth = width/float(bands);
  fft = new FFT(this, bands);
  fft.input(sample);

}

void draw() {
  background(60);

  analyzeBeat();

}

void analyzeBeat() {

  if (beatDetector.isBeat()) {
    isBeat = true;
    println("BEAT!");
  }
  else {
    isBeat = false;
  }
}

void analyzeFFT() {

  fill(200, 100, 230);
  noStroke();

  fft.analyze();

  for (int i = 0; i < bands; i++) {
    sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;

    rect(i * barWidth, height, barWidth, -sum[i]*height*scale);
  }
}

void analyzeAmplitude() {

}

void analyzeWaveform() {

}

void mousePressed() {

  if (sample.isPlaying()) {
    sample.pause();
  }
  else {
    sample.play();
  }
}
