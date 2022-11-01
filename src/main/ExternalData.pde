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
  int samples;
  int shapeTrigger = 25;

//SineWave
  float lastAmp = 0;
  int sineThickness = 15;
  int sineWaveResolution = 8;
  int sineWidth;
  float sineIncrement = 0.0;
  float sineHeight = 140.0;
  float sinePeriod = 500.0;
  float sineXIncrement;
  float[] sineYValues;
  color sineColor = color(92,118,199,255);

  float[] waveData;
  FloatList waveData2 = new FloatList();


  ExternalData() {
    super();
  }

  void setupArt(SoundFile file, BeatDetector beat, Amplitude amp, Waveform wave, FFT ffT, PixelQueue q, color bright, color dark) {
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

    sineWidth = width;
    sineXIncrement = (TWO_PI / sinePeriod) * sineWaveResolution;
    sineYValues = new float[sineWidth/sineWaveResolution];
    waveData = new float[100];
    sineWaveResolution = width/100;

    amplitude.input(file);
    waveform.input(file);
    waveform.analyze();
    waveData = waveform.data;
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
/*
  void drawWave(boolean changeValues) {
    waveform.analyze();

    waveData = waveform.data;

  }*/

  void redrawWave() {
    float w = ((3*displayWidth)/4) / 100;
    float space = (displayWidth/4)/100;
    float xPos = space + w/2;
    strokeWeight(w);
    stroke(color(0));

    for (int i = 0; i < 100; i++) {
      float f = map(waveData[i], -1, 1, -100, 100);
      f = abs(f);
      color c = color(205 - f, 200 - f, 180 - f,255);
      stroke(c);
      float y = map(waveData[i], -1, 1, -500, 500);
      line(xPos, height/2,xPos, height/2 +y);
      xPos = xPos + w + space;
    }
  }

  void drawShape() {
    waveform.analyze();

    beginShape();
    for(int i = 1; i < waveform.data.length; i++) {
      float x = map(waveform.data[i], -1, 1, 0, width);
      float y = map(waveform.data[i-1], -1, 1, 0, height);
      vertex(x,y);
    }
    endShape();


  }

  void drawSinWave() {
    float a = getAmplitude(amplitude);
    float amp = log( 1+ (lastAmp - a)) + a;
    lastAmp = a;
    sineHeight = amp * 100;
    sinePeriod = amp * 500;

    sineIncrement += 0.05;

    float j = sineIncrement;
    for (int i = 0; i < sineYValues.length; i++) {
      sineYValues[i] = sin(j)*sineHeight;
      j+=sineXIncrement;
    }

    stroke(sineColor);
    color col = sineColor;
    strokeWeight(sineThickness);
    for (int x = 1; x < sineYValues.length; x++) {
      float g = map((x-1)*sineWaveResolution, 0, sineWidth, 0, 255);
      //col = color(red(sineColor), g, blue(sineColor));
      col = color(g,g,g);
      stroke(col);
      line((x-1)*sineWaveResolution, height/2+sineYValues[(x-1)], x*sineWaveResolution, height/2+sineYValues[x]);
    }
  }

  void drawSampleWave() {

    int mid = height / 2;

    waveform.analyze();

    for (int i = 0; i < samples; i++) {

      float index = (width/samples) * i;
      float y = map(waveform.data[i], -1, 1, 0, 150);

      float f = map(waveData[i], -1, 1, -100, 100);
      f = abs(f);
      color c = color(205 - f, 200 - f, 180 - f,255);
      stroke(c);
      strokeWeight(15);
      line(index, mid-y, index, mid+y);
      waveData2.set(i, y);
    }
  }

  void redrawSampleWave() {

    int mid = height / 2;

    for (int i = 0; i < waveData2.size(); i++) {

      float index = (width/samples) * i;
      float y = waveData2.get(i);

      float f = map(waveData[i], -1, 1, -100, 100);
      f = abs(f);
      color c = color(205 - f, 200 - f, 180 - f,255);
      stroke(c);
      strokeWeight(15);
      line(index, mid-y, index, mid+y);
    }
  }

  void initWaveData() {

    waveData2.clear();
    for (int i = 0; i < samples; i++) {
      waveData2.set(i, 1);
    }
  }

  void setSamples(int s) {

    samples = s;
    initWaveData();
  }
}
