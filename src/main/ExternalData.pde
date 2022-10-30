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
  PixelQueue queue;
  color defaultWaveBright;
  color defaultWaveDark;

  int shapeTrigger = 20;

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
        float amp = map(getAmplitude(), 0, 1, 0, 40);
        color col = generateFFTColor(-10, 50);
        initSplash((int)amp, col);
      }
      else if (beatEnergy > 5) {

        float amp = map(getAmplitude(), 0, 1, 20, 150);
        color col = generateFFTColor(100, 0);
        initCircle((int)amp, col);
      }
    }
  }
}
