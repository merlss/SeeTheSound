/*
Mathis Pöhlsen 202232489
*/

import controlP5.*;
import processing.sound.*;


//general
float dWidth;
float dHeight;
color bgColor = color(46,46,72,255);
color lightBgColor = color(116,116,142,255);

//draw
ExternalData externalArt;
boolean isDrawing = false;
BeatDetector beatDetector;
FFT fft;
Amplitude amplitude;
Waveform waveform;
AudioIn audioIn;
int samples;
color defaultWaveColor = color(50);
color defaultWaveBright = color(215,210,190,255);
color defaultWaveDark = color(160,150,150,255);

// screenshots
int screenShotIterator = 1;

KeyboardData keyboardArt;
MicrophoneData microphoneArt;

// ui Elements
ControlP5 ui;

Sound sound;
//PFont f;
ControlFont font;
color font_color = color(255);

//button
color button_color = color(77,76,108,1);
color button_color_transparent = color(46,46,72,1);
color button_hoverColor = color(87,87, 87,200);
color button_pressColor = color(36,36,36,255);
color text_color = color(255);

//slider
color slider_color = color(77,76,108,255);
color slider_activeColor = color(87,86,118,255);
color slider_backgroundColor = color(36,36,52,255);

Button backButton;

String currentPage = "loadMainScreen";

// mainScreen Variables
Button drawSongButton;
Button selfPlayingButton;
Button exitButton;


//Setup Variables
SoundFile audioFile;
Button selectFileButton;
String fileName;
boolean showFileName;
boolean showErrorMessage = false;
String errorMessage;
Button setupContinueButton;

//pause window
boolean showPauseScreen;
boolean paused;
Button pauseContinueButton;
Button pauseExitButton;
Slider pauseVolumeSlider;

//background
PImage bgPicture;
boolean drawBackground;
float darkness = 0.6;
int sineThickness = 15;
int sineWaveResolution = 8;
int sineWidth;
float sineIncrement = 0.0;
float sineHeight = 140.0;
float sinePeriod = 500.0;
float sineXIncrement;
float[] sineYValues;
color sineColor = color(92,118,199,255);
float volume = 1;

SoundFile menuMusic;

//Piano Buttons
SinOsc oscillator1;
SinOsc oscillator2;
String osc1 = "0";
String osc2 = "0";
Env env;
float atkTime = 0.005;
float releaseTime = 0.2;
float susLevel = 0.3;
float susTime = 0.4;
int susPedal = 1;

//DrawPageUI
Button pauseDrawButton;
Button saveImageButton;

//selfPlayDraw
boolean inSelfPlayDraw = false;
boolean muted = true;
Button muteButton;

color piano_button_color = color(255);
color piano_button_hoverColor = color(200);
color piano_button_activeColor = color(150);
color pianoHalf_button_color = color(0);
color pianoHalf_button_hoverColor = color(50);
color pianoHalf_button_activeColor = color(100);
Button c1B;
Button d1B;
Button e1B;
Button f1B;
Button g1B;
Button a1B;
Button b1B;
Button c2B;
Button d2B;
Button e2B;

Button c1hB;
Button d1hB;
Button f1hB;
Button g1hB;
Button a1hB;
Button c2hB;
Button d2hB;


void setup() {
  fullScreen();
  ui = new ControlP5(this);
  PFont f = createFont("Courier", 20, true);
  font = new ControlFont(f);
  dWidth = 1920;
  dHeight = 1080;

  sound = new Sound(this);

  // init background Sine Wave;
  sineWidth = width/2+width/4;
  sineXIncrement = (TWO_PI / sinePeriod) * sineWaveResolution;
  sineYValues = new float[sineWidth/sineWaveResolution];

  // init 2 Oscillators for playing two sounds simultaneously
  oscillator1 = new SinOsc(this);
  oscillator2 = new SinOsc(this);
  env = new Env(this);

  // init background image and make darker
  bgColor = defaultWaveBright;
  drawBackground = true;
  loadBackground();

  menuMusic = new SoundFile(this, "MenuMusic.mp3");

  // init external classes
  externalArt = new ExternalData();
  keyboardArt = new KeyboardData();
  microphoneArt = new MicrophoneData();

  // init sound analyze tools
  beatDetector = new BeatDetector(this);
  fft = new FFT(this, 32);
  amplitude = new Amplitude(this);
  samples = width / 20;
  externalArt.setSamples(samples);
  waveform = new Waveform(this, samples);
  audioIn = new AudioIn(this, 0);

  loadMainScreen();
}


void draw() {
  background(bgColor);

  // draw Background
  if (bgPicture != null && drawBackground == true) {
    image(bgPicture, 0, 0, displayWidth, displayHeight);
    updatePixels();
  }
  if (drawBackground) {
    drawSinWave();
  }

  // set sound volume
  sound.volume(volume);

  // display fileName on Setup Page
  if (showFileName && fileName != null) {
    textLabel(fileName, calcWidth((dWidth/2)), calcHeight(550), calcFontSize(100), text_color);
  }

  // display Pause Screen
  if (showPauseScreen) {
    drawPauseScreen();
  }

  // draw a Song
  if (isDrawing) {
    if (frameCount % 2 == 0) {
      externalArt.drawSampleWave();
    }
    externalArt.redrawSampleWave();
    externalArt.initNewShape();
    if (frameCount % 4 == 0) {
      externalArt.drawSplash();
    }
    externalArt.redraw();
  }

  // draw Self Playing
  if (inSelfPlayDraw) {
    if (frameCount % 4 == 0) {
      keyboardArt.drawSplash();
    }
    keyboardArt.redraw();
    if (!muted) {
      fill(255, 204);
      noStroke();
      smooth();
      microphoneArt.drawCircles();
    }
  }

  // draw Main Screen
  if (currentPage == "loadMainScreen") {
    drawMainScreen();
  }

  // draw Setup Page
  else if (currentPage == "loadSetupDrawSong") {
    drawSetupScreen();
  }

}

// load Background image
void loadBackground() {
  bgPicture = loadImage("painting1.jpg");
  image(bgPicture, 0, 0, displayWidth, displayHeight);
  loadPixels();
  for (int i = 0; i < pixels.length; i++ ) {
  color pixel = pixels[i];
    pixels[i] = color(int(red(pixel)*darkness), int(green(pixel)*darkness), int(blue(pixel)*darkness));
  }
  updatePixels();
}
// draw Background Sine Wave
void drawSinWave() {
  sineIncrement += 0.02;

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

// draw and load Main and handle Button Callback Functions in Main
void drawMainScreen() {
  textLabel("See the Sound", calcWidth(dWidth/2), calcHeight(200), calcFontSize(145), text_color);
}
void loadMainScreen() {
  drawBackground = true;
  menuMusic.play();
  String lastPage = currentPage;
  currentPage = "loadMainScreen";
  background(bgColor);
  loadBackground();
  hideUIObjects();
  if (drawSongButton == null) {
    drawMainScreen();
    int x = 1600;
    drawSongButton = button("handleDrawSong", "Draw Song", calcWidth(dWidth/2), calcHeight(800), calcWidth(400), calcHeight(50), button_color_transparent, button_hoverColor, button_pressColor, calcFontSize(35), font_color);
    selfPlayingButton = button("handleOwnSong", "Make your own Song", calcWidth(dWidth/2), calcHeight(880), calcWidth(400), calcHeight(50), button_color_transparent, button_hoverColor, button_pressColor, calcFontSize(35), font_color);
    exitButton = button("quitGame", "Quit", calcWidth(dWidth/2), calcHeight(960), calcWidth(400), calcHeight(50), button_color_transparent, button_hoverColor, button_pressColor, calcFontSize(35), font_color);
  }
  else {
    drawMainScreen();
    drawSongButton.show();
    selfPlayingButton.show();
    exitButton.show();
  }
}
// handle Button Callback Functions in Main
public void handleDrawSong(int value) {
  loadSetupDrawSong();
}
public void handleOwnSong(int value) {
  loadSelfPlayingPage();
  bgColor = defaultWaveBright;
  microphoneArt.setupMic(audioIn, amplitude);
}
public void quitGame() {
  exit();
}

// draw and load Setup and Handle Button Callback Functions of Setup
void drawSetupScreen() {
  textLabel("Setup", calcWidth(dWidth/2), calcHeight(150), calcFontSize(100), text_color);
  if (showErrorMessage && errorMessage != null) {
    textLabel(errorMessage, calcWidth((dWidth/2)), calcHeight(850+calcFontSize(35/2)), calcFontSize(25), color(220,40,40));
  }
}
void loadSetupDrawSong() {
  drawBackground = true;
  showErrorMessage = false;
  String lastPage = currentPage;
  currentPage = "loadSetupDrawSong";
  background(bgColor);
  hideUIObjects();
  if (selectFileButton == null) {
    drawSetupScreen();
    drawBackButton(lastPage);
    selectFileButton = button("handleFileSelect", "Select Audiofile", calcWidth((dWidth/2)), calcHeight(780), calcWidth(400), calcHeight(50), button_color_transparent, button_hoverColor, button_pressColor, calcFontSize(35), font_color);
    setupContinueButton = button("handleSetupContinue", "Continue", calcWidth(dWidth/2), calcHeight(920), calcWidth(400), calcHeight(50), button_color_transparent, button_hoverColor, button_pressColor, calcFontSize(35), font_color);
  }
  else {
    drawSetupScreen();
    backButton.setStringValue(lastPage);
    backButton.show();
    selectFileButton.show();
    setupContinueButton.show();
  }
}
public void handleSetupContinue() {
  String prefix = "";
  if (fileName != null) {
    String[] list = split(fileName, ".");
    prefix = list[list.length-1];
  }
  if (fileName != null && prefix.equals("mp3")) {
    drawBackground = false;
    menuMusic.stop();
    externalArt.setupArt(audioFile, beatDetector, amplitude, waveform, fft, defaultWaveBright, defaultWaveDark);
    loadSongDrawPage();
  }
  else {
    errorMessage = "current Setup is not valid";
    showErrorMessage = true;
  }
}
void fileSelected(File file) {
  if (file != null) {
    String path = file.getAbsolutePath();
    audioFile = new SoundFile(this, path);
    if (path.indexOf("/") >= 0) {
      String[] list = split(path, "/");
      fileName = list[list.length-1];
    }
    else if (path.indexOf("\\") >= 0) {
      String[] list = split(path, "\\");
      fileName = list[list.length-1];
    }
    showFileName = true;
    String[] fileNameList = split(fileName, ".");
    String prefix = fileNameList[fileNameList.length-1];
    if (fileName != null && prefix.equals("mp3")) {
      showErrorMessage = false;
    }
    else {
      showErrorMessage = true;
    }
  }
}
public void handleFileSelect() {
  selectInput("Select a file to process:", "fileSelected");
}


// draw and load PauseScreen and Handle all PauseScreen Buttons and Slider Callback Functions in Pause
void drawPauseScreen() {
  stroke(color(red(lightBgColor), green(lightBgColor), blue(lightBgColor), alpha(255)));
  fill(lightBgColor);
  rect(calcWidth(width/2-500/2), calcHeight(height/2-600/2), calcWidth(500), calcHeight(600), calcWidth(30));
}
void loadPauseWindow() {
  pauseDraw(true);
  hideUIObjects();
  if (pauseContinueButton == null) {
    pauseContinueButton = button("handlePauseContinue", "Continue", calcWidth(dWidth/2), calcHeight(320), calcWidth(380), calcHeight(100), button_color, button_hoverColor, button_pressColor, calcFontSize(50), font_color);
    pauseExitButton = button("handlePauseExit", "Exit", calcWidth(dWidth/2), calcHeight(750), calcWidth(380), calcHeight(100), button_color, button_hoverColor, button_pressColor, calcFontSize(50), font_color);
    pauseVolumeSlider = slider("volume", " Volume", calcWidth(dWidth/2), calcHeight(450), calcWidth(200), calcHeight(40), calcFontSize(50));
  }
  else {
    pauseContinueButton.show();
    pauseExitButton.show();
    pauseVolumeSlider.show();
  }
}
public void handlePauseContinue() {
   hideUIObjects();
   if (currentPage.equals("loadSongDrawPage")) {
     loadSongDrawPage();
   }
   if (currentPage.equals("loadSelfPlayingPage")) {
     loadSelfPlayingPage();
   }
 }
public void handlePauseExit() {
  hideUIObjects();
  stopDraw();
  loadMainScreen();
}

// load Song Drawing Page
void loadSongDrawPage() {
  if (audioFile != null) {
    String lastPage = currentPage;
    currentPage = "loadSongDrawPage";
    background(bgColor);
    hideUIObjects();
    float xStep = calcWidth(dWidth/18);
    float xPos = xStep*4;
    float space = calcWidth(12);
    if (saveImageButton == null) {
      saveImageButton = button("handleSaveImage", "save", calcWidth(1800), calcHeight(900), calcWidth(120), calcHeight(50), color(80), color(60), color(40), calcFontSize(35), color(255));
    }
    else {
      saveImageButton.show();
    }
  }
  else {
    showErrorMessage = true;
  }
  startDraw();
}
// handle Save Image Callback
public void handleSaveImage() {
  save("screenshots/" + "screenshot" + screenShotIterator + ".jpg");
  screenShotIterator++;
}


// load Self Plaing Page
void loadSelfPlayingPage() {
  menuMusic.stop();
  keyboardArt.setupKeyBoardArt();
  String lastPage = currentPage;
  currentPage = "loadSelfPlayingPage";
  background(bgColor);
  hideUIObjects();
  float xStep = calcWidth(dWidth/18);
  float xPos = xStep * 4;
  float space = calcWidth(12);
  if (muteButton == null) {
    muteButton = button("handleMute", "unmute", calcWidth(1800), calcHeight(970), calcWidth(150), calcHeight(50), color(80), color(60), color(40), calcFontSize(35), color(255));
  }
  if (saveImageButton == null) {
    saveImageButton = button("handleSaveImage", "save", calcWidth(1800), calcHeight(900), calcWidth(120), calcHeight(50), color(80), color(60), color(40), calcFontSize(35), color(255));
  }
  if (c1B == null) {
    c1B = button("C", "C", xPos, calcHeight(1000), xStep, calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
    xPos += xStep + space;
    d1B = button("D", "D", xPos, calcHeight(1000), xStep, calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
    xPos += xStep + space;
    e1B = button("E", "E", xPos, calcHeight(1000), xStep, calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
    xPos += xStep + space;
    f1B = button("F", "F", xPos, calcHeight(1000), xStep, calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
    xPos += xStep + space;
    g1B = button("G", "G", xPos, calcHeight(1000), xStep, calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
    xPos += xStep + space;
    a1B = button("A", "A", xPos, calcHeight(1000), xStep, calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
    xPos += xStep + space;
    b1B = button("B", "B", xPos, calcHeight(1000), xStep, calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
    xPos += xStep + space;
    c2B = button("C2", "C", xPos, calcHeight(1000), xStep, calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
    xPos += xStep + space;
    d2B = button("D2", "D", xPos, calcHeight(1000), xStep, calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
    xPos += xStep + space;
    e2B = button("E2", "E", xPos, calcHeight(1000), xStep, calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));

    float xPosHalf = xStep*4+xStep/2+space/2;
    c1hB = button("C#", "C#", xPosHalf, calcHeight(860), xStep*0.7, calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
    xPosHalf += xStep + space;
    d1hB = button("D#", "D#", xPosHalf, calcHeight(860), xStep*0.7, calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
    xPosHalf += (xStep + space)*2;
    f1hB = button("F#", "F#", xPosHalf, calcHeight(860), xStep*0.7, calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
    xPosHalf += xStep + space;
    g1hB = button("G#", "G#", xPosHalf, calcHeight(860), xStep*0.7, calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
    xPosHalf += xStep + space;
    a1hB = button("A#", "A#", xPosHalf, calcHeight(860), xStep*0.7, calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
    xPosHalf += (xStep + space)*2;
    c2hB = button("C2#", "C#", xPosHalf, calcHeight(860), xStep*0.7, calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
    xPosHalf += xStep + space;
    d2hB = button("D2#", "D#", xPosHalf, calcHeight(860), xStep*0.7, calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
  }
  else {
    c1B.show();
    d1B.show();
    e1B.show();
    f1B.show();
    g1B.show();
    a1B.show();
    b1B.show();
    c2B.show();
    d2B.show();
    e2B.show();
    c1hB.show();
    d1hB.show();
    f1hB.show();
    g1hB.show();
    a1hB.show();
    c2hB.show();
    d2hB.show();
    muteButton.show();
    saveImageButton.show();
  }
  startSelfDraw();
}
// handle Mute Button Callback
public void handleMute() {
  if (muted) {
    muted = false;
    muteButton.setLabel("mute");
  }
  else {
    muted = true;
    muteButton.setLabel("unmute");
  }
}

// draw Back Button and chanfe to last Page
void drawBackButton(String lastPage) {
  backButton = button("changeBackButtonValue", "Back", calcWidth(80), calcHeight(80), calcWidth(120), calcHeight(60), button_color_transparent, button_hoverColor, button_pressColor, calcFontSize(30), font_color);
  backButton.setStringValue(lastPage);
}
void changeBackButtonValue() {
  method(backButton.getStringValue());
}

// Handle all Mouse Clicks for Keyboard
void controlEvent(CallbackEvent event) {
  if (event.getAction() == ControlP5.ACTION_PRESSED || event.getAction() == ControlP5.ACTION_RELEASED) {
    float value = 0;
    String pressedKey = "";
    color col = color(0, 0, 0);
    switch(event.getController().getAddress()) {
    case "/C":
      value = 261.63;
      pressedKey = "c";
      col = color(80, 0, 120);
      bgColor = color(220, 140, 250);
      break;
    case "/D":
      value = 293.66;
      pressedKey = "d";
      col = color(10, 10, 200);
      bgColor = color(120, 120, 250);
      break;
    case "/E":
      value = 329.63;
      pressedKey = "e";
      col = color(30, 170, 200);
      bgColor = color(120, 230, 250);
      break;
    case "/F":
      value = 349.23;
      pressedKey = "f";
      col = color(30, 200, 80);
      bgColor = color(130, 250, 180);
      break;
    case "/G":
      value = 392.00;
      pressedKey = "g";
      col = color(255, 255, 50);
      bgColor = color(255, 255, 220);
      break;
    case "/A":
      value = 440.00;
      pressedKey = "a";
      col = color(255, 100, 0);
      bgColor = color(255, 220, 120);
      break;
    case "/B":
      value = 493.88;
      pressedKey = "b";
      col = color(200, 0, 0);
      bgColor = color(250, 100, 100);
      break;
    case "/C2":
      value = 523.25;
      pressedKey = "c2";
      col = color(160, 80, 200);
      bgColor = color(220, 150, 250);
      break;
    case "/D2":
      value = 587.33;
      pressedKey = "d2";
      col = color(50, 60, 220);
      bgColor = color(150, 160, 250);
      break;
    case "/E2":
      value = 659.25;
      pressedKey = "e2";
      col = color(60, 80, 220);
      bgColor = color(140, 160, 250);
      break;
    case "/C#":
      value = 277.18;
      pressedKey = "c#";
      col = color(45, 5, 160);
      bgColor = color(150, 100, 220);
      break;
    case "/D#":
      value = 311.13;
      pressedKey = "d#";
      col = color(20, 40, 200);
      bgColor = color(100, 120, 250);
      break;
    case "/F#":
      value = 369.99;
      pressedKey = "f#";
      col = color(100, 220, 65);
      bgColor = color(135, 250, 100);
      break;
    case "/G#":
      value = 415.30;
      pressedKey = "g#";
      col = color(255, 175, 25);
      bgColor = color(255, 200, 100);
      break;
    case "/A#":
      value = 466.16;
      pressedKey = "a#";
      col = color(220, 50, 0);
      bgColor = color(250, 150, 100);
      break;
    case "/C2#":
      value = 554.37;
      pressedKey = "c2#";
      col = color(105, 70, 210);
      bgColor = color(200, 165, 250);
      break;
    case "/D2#":
      value = 622.25;
      pressedKey = "d2#";
      col = color(60, 40, 200);
      bgColor = color(110, 90, 250);
      break;
    }
    if (event.getAction() == ControlP5.ACTION_PRESSED && pressedKey.equals("") == false) {
      playNote(value, pressedKey);
      keyboardArt.initNewShape(value, col);
    }
    else if (event.getAction() == ControlP5.ACTION_RELEASED && pressedKey.equals("") == false) {
      stopNote(pressedKey);
    }
  }
}

// Plays a Note
void playNote(float pitch, String pressedKey) {

  if (osc1.equals("0") == false && osc2.equals("0") == false) {
    return;
  }
  else if (osc1.equals("0") == false && osc2.equals("0") == true) {
    osc2 = pressedKey;
    oscillator2.freq(pitch);
    oscillator2.play();
    env.play(oscillator2, atkTime, susTime*susPedal, susLevel, releaseTime);

  }
  else if (osc1.equals("0") == true && osc2.equals("0") == false) {
    osc1 = pressedKey;
    oscillator1.freq(pitch);
    oscillator1.play();
    env.play(oscillator1, atkTime, susTime*susPedal, susLevel, releaseTime);
  }
  else {
    osc1 = pressedKey;
    oscillator1.freq(pitch);
    oscillator1.play();
    env.play(oscillator1, atkTime, susTime*susPedal, susLevel, releaseTime);
  }
}

// stops the playing note
void stopNote(String pressedKey) {
  if (pressedKey.equals(osc1) == true) {
    oscillator1.stop();
    osc1 = "0";
  }
  else if (pressedKey.equals(osc2) == true) {
    oscillator2.stop();
    osc2 = "0";
  }
}

// hide all UI Objects
void hideUIObjects() {
  if (drawSongButton != null) {
    drawSongButton.hide();
  }
  if (selfPlayingButton != null) {
    selfPlayingButton.hide();
  }
  if (exitButton != null) {
    exitButton.hide();
  }
  if (backButton != null) {
    backButton.hide();
  }
  if (selectFileButton != null) {
    selectFileButton.hide();
  }
  if (currentPage != "loadSetupDrawSong") {
    showFileName = false;
    fileName = null;
  }
  if (setupContinueButton != null) {
    setupContinueButton.hide();
  }
  if (pauseContinueButton != null) {
    pauseContinueButton.hide();
  }
  if (pauseExitButton != null) {
    pauseExitButton.hide();
  }
  if (pauseVolumeSlider != null) {
    pauseVolumeSlider.hide();
  }
  if (pauseDrawButton != null) {
    pauseDrawButton.hide();
  }
  if (saveImageButton != null) {
    saveImageButton.hide();
  }
  if (muteButton != null) {
    muteButton.hide();
  }
  if (c1B != null) {
    c1B.hide();
    d1B.hide();
    e1B.hide();
    f1B.hide();
    g1B.hide();
    a1B.hide();
    b1B.hide();
    c2B.hide();
    d2B.hide();
    e2B.hide();
    c1hB.hide();
    d1hB.hide();
    f1hB.hide();
    g1hB.hide();
    a1hB.hide();
    c2hB.hide();
    d2hB.hide();
  }

}

// create a new UI Button
Button button(String linkedFunction, String label, float posX, float posY, float w, float h, color col, color hoverCol, color pressCol, float fontSize, color fontColor) {
  Button button;
  button = ui.addButton(linkedFunction)
  .setBroadcast(false) //disable button trigger
  .setSize(int(w), int(h))
  .setPosition(posX - w/2, posY - h/2)
  .setColorBackground(col)
  .setColorForeground(hoverCol)
  .setColorActive(pressCol)
  .setColorCaptionLabel(fontColor)
  .setBroadcast(true); // enable button trigger

  button.setLabel(label);
  PFont f = createFont("Courier", fontSize, true);
  font = new ControlFont(f, int(fontSize));

  button.getCaptionLabel()
  .setFont(font)
  .toUpperCase(false);
  return button;
}

// draw new Text Label
void textLabel(String label, float posX, float posY, float fontSize, color textColor) {
  PFont f = createFont("Courier", fontSize, true);
  textFont(f);
  fill(textColor);
  textAlign(CENTER);
  textSize(fontSize);
  text(label, posX, posY);
}

// create new Slider
Slider slider(String sliderValue, String label, float posX, float posY, float w, float h, float fontSize) {
  Slider slider = ui.addSlider(sliderValue)
  .setPosition(posX - w, posY)
  .setRange(0,1)
  .setSize(int(w), int(h))
  .setColorForeground(slider_color)
  .setColorActive(slider_activeColor)
  .setColorBackground(slider_backgroundColor);

  slider.setLabel(label);
  PFont f = createFont("Courier", fontSize, true);
  font = new ControlFont(f, int(fontSize));

  slider.getCaptionLabel()
  .setFont(font)
  .toUpperCase(false);

  return slider;
}

// pauses drawing process
void pauseDraw(boolean pauseScreen) {
  if (pauseScreen) {
    showPauseScreen = true;
  }
  paused = true;
  isDrawing = false;
  inSelfPlayDraw = false;
  if (audioFile != null) {
    audioFile.pause();
  }
}
// stops drawing process
void stopDraw() {
  showPauseScreen = false;
  paused = false;
  isDrawing = false;
  inSelfPlayDraw = false;
  if (audioFile != null) {
    audioFile.stop();
    audioFile = null;
  }
}

// starts drawing process
void startDraw() {
  isDrawing = true;
  showPauseScreen = false;
  paused = false;
  if (audioFile != null) {
    audioFile.play();
  }
}

// starts Self Playing drawing process
void startSelfDraw() {
  inSelfPlayDraw = true;
  drawBackground = false;
  paused = false;
  showPauseScreen = false;
}


void keyPressed(KeyEvent e) {
  if (currentPage.equals("loadSongDrawPage") || currentPage.equals("loadSelfPlayingPage")) {
    if (key == ESC && !paused) {
      loadPauseWindow();
    }
    else if (key == ESC && paused) {
      handlePauseContinue();
    }
  }
  float value = 0;
  String pressedKey = "";
  color col = color(0, 0, 0);
  switch(key) {
    case 'y': value = 261.63; col = color(80, 0, 120); bgColor = color(220, 140, 250); if (osc1 == "c" || osc2 == "c") {return;} c1B.setColorBackground(piano_button_activeColor); pressedKey = "c"; break;
    case 's': value = 277.18; col = color(45, 5, 160); bgColor = color(150, 100, 220); if (osc1 == "c#" || osc2 == "c#") {return;} c1hB.setColorBackground(pianoHalf_button_activeColor); pressedKey = "c#"; break;
    case 'x': value = 293.66; col = color(10, 10, 200); bgColor = color(120, 120, 250); if (osc1 == "d" || osc2 == "d") {return;} d1B.setColorBackground(piano_button_activeColor); pressedKey = "d"; break;
    case 'd': value = 311.13; col = color(20, 40, 200); bgColor = color(100, 120, 250); if (osc1 == "d#" || osc2 == "d#") {return;} d1hB.setColorBackground(pianoHalf_button_activeColor); pressedKey = "d#"; break;
    case 'c': value = 329.63; col = color(30, 170, 200); bgColor = color(120, 230, 250); if (osc1 == "e" || osc2 == "e") {return;} e1B.setColorBackground(piano_button_activeColor); pressedKey = "e";break;
    case 'v': value = 349.23; col = color(30, 200, 80); bgColor = color(130, 250, 180); if (osc1 == "f" || osc2 == "f") {return;} f1B.setColorBackground(piano_button_activeColor); pressedKey = "f";break;
    case 'g': value = 369.99; col = color(100, 220, 65); bgColor = color(135, 250, 100); if (osc1 == "f#" || osc2 == "f#") {return;} f1hB.setColorBackground(pianoHalf_button_activeColor); pressedKey = "f#";break;
    case 'b': value = 392.00; col = color(255, 255, 50); bgColor = color(255, 255, 220); if (osc1 == "g" || osc2 == "g") {return;} g1B.setColorBackground(piano_button_activeColor); pressedKey = "g";break;
    case 'h': value = 415.30; col = color(255, 175, 25); bgColor = color(255, 200, 100); if (osc1 == "g#" || osc2 == "g#") {return;} g1hB.setColorBackground(pianoHalf_button_activeColor); pressedKey = "g#";break;
    case 'n': value = 440.00; col = color(255, 100, 0); bgColor = color(255, 220, 120); if (osc1 == "a" || osc2 == "a") {return;} a1B.setColorBackground(piano_button_activeColor); pressedKey = "a";break;
    case 'j': value = 466.16; col = color(220, 50, 0); bgColor = color(250, 150, 100); if (osc1 == "a#" || osc2 == "a#") {return;} a1hB.setColorBackground(pianoHalf_button_activeColor); pressedKey = "a#";break;
    case 'm': value = 493.88; col = color(200, 0, 0); bgColor = color(250, 100, 100); if (osc1 == "b" || osc2 == "b") {return;} b1B.setColorBackground(piano_button_activeColor); pressedKey = "b";break;
    case ',': value = 523.25; col = color(160, 80, 200); bgColor = color(220, 150, 250); if (osc1 == "c2" || osc2 == "c2") {return;} c2B.setColorBackground(piano_button_activeColor); pressedKey = "c2";break;
    case 'l': value = 554.37; col = color(105, 70, 210); bgColor = color(200, 165, 250); if (osc1 == "c2#" || osc2 == "c2#") {return;} c2hB.setColorBackground(pianoHalf_button_activeColor); pressedKey = "c2#";break;
    case '.': value = 587.33; col = color(50, 60, 220); bgColor = color(150, 160, 250); if (osc1 == "d2" || osc2 == "d2") {return;} d2B.setColorBackground(piano_button_activeColor); pressedKey = "d2";break;
    case 'ö': value = 622.25; col = color(60, 40, 200); bgColor = color(110, 90, 250); if (osc1 == "d2#" || osc2 == "d2#") {return;} d2hB.setColorBackground(pianoHalf_button_activeColor); pressedKey = "d2#";break;
    case '-': value = 659.25; col = color(60, 80, 220); bgColor = color(140, 160, 250); if (osc1 == "e2" || osc2 == "e2") {return;} e2B.setColorBackground(piano_button_activeColor); pressedKey = "e2"; break;
    case ' ': susPedal = 4; break;

  }
  if (value != 0) {

    playNote(value, pressedKey);
    keyboardArt.initNewShape(value, col);
  }
  key = 0;
}

void keyReleased() {
  switch(key) {
    case 'y': stopNote("c"); c1B.setColorBackground(piano_button_color);  break;
    case 's': stopNote("c#"); c1hB.setColorBackground(pianoHalf_button_color); break;
    case 'x': stopNote("d"); d1B.setColorBackground(piano_button_color); break;
    case 'd': stopNote("d#"); d1hB.setColorBackground(pianoHalf_button_color); break;
    case 'c': stopNote("e"); e1B.setColorBackground(piano_button_color); break;
    case 'v': stopNote("f"); f1B.setColorBackground(piano_button_color); break;
    case 'g': stopNote("f#"); f1hB.setColorBackground(pianoHalf_button_color); break;
    case 'b': stopNote("g"); g1B.setColorBackground(piano_button_color); break;
    case 'h': stopNote("g#"); g1hB.setColorBackground(pianoHalf_button_color); break;
    case 'n': stopNote("a"); a1B.setColorBackground(piano_button_color); break;
    case 'j': stopNote("a#"); a1hB.setColorBackground(pianoHalf_button_color); break;
    case 'm': stopNote("b"); b1B.setColorBackground(piano_button_color); break;
    case ',': stopNote("c2"); c2B.setColorBackground(piano_button_color); break;
    case 'l': stopNote("c2#"); c2hB.setColorBackground(pianoHalf_button_color); break;
    case '.': stopNote("d2"); d2B.setColorBackground(piano_button_color); break;
    case 'ö': stopNote("d2#"); d2hB.setColorBackground(pianoHalf_button_color); break;
    case '-': stopNote("e2"); e2B.setColorBackground(piano_button_color); break;
    case ' ': susPedal = 1; break;
  }
}

// scale UI to screen Size Height
public float calcHeight(float h) {
  return map(h, 0, 1080, 0, height);
}

// scale UI to screen Size Width
public float calcWidth(float w) {
  return map(w, 0, 1920, 0, width);
}

// scale Text to screen Size
public int calcFontSize(int f) {
  float x = map(f, 0, 1920, 0, displayWidth);
  float y = map(f, 0, 1080, 0, displayHeight);
  return int((x+y)/2);
}
