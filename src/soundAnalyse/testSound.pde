/*

import processing.sound.*;

SoundFile song;
void setup() {
  size(640, 360);
  song = new SoundFile(this, "Sound1.mp3");
  song.play();
}

void draw() {}

void mousePressed() {

  if (song.isPlaying()) {
    song.pause();
    }
    else {
    song.play();
    }
}





import processing.sound.*;

// sound information
SoundFile soundFile;
AudioIn audio;

FFT fft;
int bands = 512;
float[] spectrum = new float[bands];

void setup() {
  size(500, 500);
  background(50);

  fft = new FFT(this, bands);
  audio = new AudioIn(this, 0);

  //audio.start();
  //fft.input(audio);


  soundFile = new SoundFile(this, "Sound1.mp3");
  fft.input(soundFile);
  //soundFile.play();
}

void draw() {
  background(255);
  fft.analyze(spectrum);
  println("analyze():  " + fft.analyze(spectrum));

  for(int i = 0; i < bands; i++){
    line(i, height, i, height - spectrum[i] * height * 5);
  }
}

void getSoundInformation() {
}
*/
