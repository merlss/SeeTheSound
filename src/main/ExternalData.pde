class ExternalData extends Art {

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
  int shapeTrigger = 25;

  ExternalData() {
    super();
  }

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

  void initNewShape() {
    if (beatDetector.isBeat()) {

      int beatEnergy = getBeatEnergy();

      if (beatEnergy > shapeTrigger) {

        shapeTrigger = beatEnergy - 5;
        float amp = map(getAmplitude(amplitude), 0, 1, 20, 50);
        color col = generateFFTColor(-10, 50);
        initSplash((int)amp, col);
      }
      else if (beatEnergy > 5) {

        float amp = map(getAmplitude(amplitude), 0, 1, 50, 150);
        color col = generateFFTColor(100, 0);
        initCircle((int)amp, col);
      }
    }
  }

  color generateFFTColor(int brightness, int intensity) {

    float[] sum = new float[bands];
    float multiply = 200;
    float r, g, b;

    fft.analyze();
    for (int i = 0; i < bands; i++) {
      sum[i] += (fft.spectrum[i] - sum[i]) * multiply;
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
}
