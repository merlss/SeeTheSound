import controlP5.*;
import processing.sound.*;


//general
float dWidth;
float dHeight;
color bgColor = color(46,46,72,255);
color lightBgColor = color(116,116,142,255);

//draw
Art art;
boolean isDrawing = false;
BeatDetector beatDetector;
FFT fft;
Amplitude amplitude;
Waveform waveform;
int samples = width/2;
color defaultWaveColor = color(50);
color defaultWaveBright = color(116,116,142,255);
color defaultWaveDark = color(46,46,72,255);;

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

//Piano Buttons
SinOsc oscillator1;
SinOsc oscillator2;
String osc1 = "0";
String osc2 = "0";
Env env;
float atkTime = 0.005;
float releaseTime = 0.2;
float susLevel = 1;
float susTime = 1;
int susPedal = 1;


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
  size(displayWidth, displayHeight);
  ui = new ControlP5(this);
  PFont f = createFont("Courier", 20, true);
  font = new ControlFont(f);
  dWidth = 1920;
  dHeight = 1080;

  sound = new Sound(this);



  sineWidth = width/2+width/4;
  sineXIncrement = (TWO_PI / sinePeriod) * sineWaveResolution;
  sineYValues = new float[sineWidth/sineWaveResolution];

  oscillator1 = new SinOsc(this);
  oscillator2 = new SinOsc(this);
  env = new Env(this);

  drawBackground = true;
  bgPicture = loadImage("painting1.jpg");
  image(bgPicture, 0, 0, displayWidth, displayHeight);
  loadPixels();
  for (int i = 0; i < pixels.length; i++ ) {
  color pixel = pixels[i];
    pixels[i] = color(int(red(pixel)*darkness), int(green(pixel)*darkness), int(blue(pixel)*darkness));
  }
  updatePixels();

  art = new Art();
  beatDetector = new BeatDetector(this);
  fft = new FFT(this, 32);
  amplitude = new Amplitude(this);
  waveform = new Waveform(this, 1);

  loadMainScreen();
}


void draw() {
  background(bgColor);
  if (bgPicture != null && drawBackground == true) {
    image(bgPicture, 0, 0, displayWidth, displayHeight);
    updatePixels();
  }
  sound.volume(volume);
  if (drawBackground) {
    calcWave();
    renderWave();
  }
  if (showFileName && fileName != null) {
    textLabel(fileName, calcWidth((dWidth/2)), calcHeight(550), calcFontSize(100), text_color);
  }
  if (paused) {
    drawPauseScreen();
  }
  //println(isDrawing);
  if (isDrawing) {

    art.drawWave();
    art.initShapes();
    if (frameCount % 4 == 0) {
      art.drawSplash();
    }
    art.redraw();
  }
  if (currentPage == "loadMainScreen") {
    drawMainScreen();
  }
  else if (currentPage == "loadSetupDrawSong") {
    drawSetupScreen();
  }

}

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

void drawMainScreen() {

  textLabel("See the Sound", calcWidth(dWidth/2), calcHeight(200), calcFontSize(145), text_color);
}

void drawSetupScreen() {
  textLabel("Setup", calcWidth(dWidth/2), calcHeight(150), calcFontSize(100), text_color);
  if (showErrorMessage && errorMessage != null) {
    textLabel(errorMessage, calcWidth((dWidth/2)), calcHeight(850+calcFontSize(35/2)), calcFontSize(25), color(220,40,40));
  }
}

void drawPauseScreen() {
  stroke(color(red(lightBgColor), green(lightBgColor), blue(lightBgColor), alpha(255)));
  fill(lightBgColor);
  rect(calcWidth(width/2-500/2), calcHeight(height/2-600/2), calcWidth(500), calcHeight(600), calcWidth(30));
}

void loadMainScreen() {
  drawBackground = true;
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

void loadSongDrawPage() {
  if (audioFile != null) {
    String lastPage = currentPage;
    currentPage = "loadSongDrawPage";
    background(bgColor);
    hideUIObjects();
    float xStep = calcWidth(1920/18);
    float xPos = xStep*4;
    float space = 12;
    if (c1B == null) {
      PixelQueue pixelQueue = new PixelQueue(defaultWaveBright, defaultWaveDark);
      art.setupArt(audioFile, beatDetector, amplitude, waveform, fft, pixelQueue, defaultWaveBright, defaultWaveDark);
      c1B = button("C", "C", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
      xPos += xStep + space;
      d1B = button("D", "D", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
      xPos += xStep + space;
      e1B = button("E", "E", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
      xPos += xStep + space;
      f1B = button("F", "F", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
      xPos += xStep + space;
      g1B = button("G", "G", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
      xPos += xStep + space;
      a1B = button("A", "A", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
      xPos += xStep + space;
      b1B = button("B", "B", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
      xPos += xStep + space;
      c2B = button("C2", "C", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
      xPos += xStep + space;
      d2B = button("D2", "D", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
      xPos += xStep + space;
      e2B = button("E2", "E", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));

      float xPosHalf = xStep*4+xStep/2+space/2;
      c1hB = button("C#", "C#", calcWidth(xPosHalf), calcHeight(860), calcWidth(xStep*0.7), calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
      xPosHalf += xStep + space;
      d1hB = button("D#", "D#", calcWidth(xPosHalf), calcHeight(860), calcWidth(xStep*0.7), calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
      xPosHalf += (xStep + space)*2;
      f1hB = button("F#", "F#", calcWidth(xPosHalf), calcHeight(860), calcWidth(xStep*0.7), calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
      xPosHalf += xStep + space;
      g1hB = button("G#", "G#", calcWidth(xPosHalf), calcHeight(860), calcWidth(xStep*0.7), calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
      xPosHalf += xStep + space;
      a1hB = button("A#", "A#", calcWidth(xPosHalf), calcHeight(860), calcWidth(xStep*0.7), calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
      xPosHalf += (xStep + space)*2;
      c2hB = button("C2#", "C#", calcWidth(xPosHalf), calcHeight(860), calcWidth(xStep*0.7), calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
      xPosHalf += xStep + space;
      d2hB = button("D2#", "D#", calcWidth(xPosHalf), calcHeight(860), calcWidth(xStep*0.7), calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
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
    }
  }
  else {
    showErrorMessage = true;
  }
  startDraw();
}

void loadSelfPlayingDraw() {
  String lastPage = currentPage;
  currentPage = "loadSelfPlayingDraw";
  background(bgColor);
  drawBackground = false;
  hideUIObjects();
  float xStep = calcWidth(1920/18);
  float xPos = xStep*4;
  float space = 12;
  c1B = button("C", "C", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
  xPos += xStep + space;
  d1B = button("D", "D", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
  xPos += xStep + space;
  e1B = button("E", "E", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
  xPos += xStep + space;
  f1B = button("F", "F", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
  xPos += xStep + space;
  g1B = button("G", "G", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
  xPos += xStep + space;
  a1B = button("A", "A", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
  xPos += xStep + space;
  b1B = button("B", "B", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
  xPos += xStep + space;
  c2B = button("C2", "C", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
  xPos += xStep + space;
  d2B = button("D2", "D", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));
  xPos += xStep + space;
  e2B = button("E2", "E", calcWidth(xPos), calcHeight(1000), calcWidth(xStep), calcHeight(400), piano_button_color, piano_button_hoverColor, piano_button_activeColor, calcFontSize(35), color(0));

  float xPosHalf = xStep*4+xStep/2+space/2;
  c1hB = button("C#", "C#", calcWidth(xPosHalf), calcHeight(860), calcWidth(xStep*0.7), calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
  xPosHalf += xStep + space;
  d1hB = button("D#", "D#", calcWidth(xPosHalf), calcHeight(860), calcWidth(xStep*0.7), calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
  xPosHalf += (xStep + space)*2;
  f1hB = button("F#", "F#", calcWidth(xPosHalf), calcHeight(860), calcWidth(xStep*0.7), calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
  xPosHalf += xStep + space;
  g1hB = button("G#", "G#", calcWidth(xPosHalf), calcHeight(860), calcWidth(xStep*0.7), calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
  xPosHalf += xStep + space;
  a1hB = button("A#", "A#", calcWidth(xPosHalf), calcHeight(860), calcWidth(xStep*0.7), calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
  xPosHalf += (xStep + space)*2;
  c2hB = button("C2#", "C#", calcWidth(xPosHalf), calcHeight(860), calcWidth(xStep*0.7), calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
  xPosHalf += xStep + space;
  d2hB = button("D2#", "D#", calcWidth(xPosHalf), calcHeight(860), calcWidth(xStep*0.7), calcHeight(120), pianoHalf_button_color, pianoHalf_button_hoverColor, pianoHalf_button_activeColor, calcFontSize(35), color(255));
}

void controlEvent(CallbackEvent event) {
  if (event.getAction() == ControlP5.ACTION_PRESSED || event.getAction() == ControlP5.ACTION_RELEASED) {
    float value = 0;
    String pressedKey = "";
    switch(event.getController().getAddress()) {
    case "/C":
      println("Button C Pressed");
      value = 261.63;
      pressedKey = "c";
      break;
    case "/D":
      println("Button D Pressed");
      value = 293.66;
      pressedKey = "d";
      break;
    case "/E":
      println("Button E Pressed");
      value = 329.63;
      pressedKey = "e";
      break;
    case "/F":
      println("Button F Pressed");
      value = 349.23;
      pressedKey = "f";
      break;
    case "/G":
      println("Button G Pressed");
      value = 392.00;
      pressedKey = "g";
      break;
    case "/A":
      println("Button A Pressed");
      value = 440.00;
      pressedKey = "a";
      break;
    case "/B":
      println("Button B Pressed");
      value = 493.88;
      pressedKey = "b";
      break;
    case "/C2":
      println("Button C2 Pressed");
      value = 523.25;
      pressedKey = "c2";
      break;
    case "/D2":
      println("Button D2 Pressed");
      value = 587.33;
      pressedKey = "d2";
      break;
    case "/E2":
      println("Button E2 Pressed");
      value = 659.25;
      pressedKey = "e2";
      break;
    case "/C#":
      println("Button A Pressed");
      value = 277.18;
      pressedKey = "c#";
      break;
    case "/D#":
      println("Button B Pressed");
      value = 311.13;
      pressedKey = "d#";
      break;
    case "/F#":
      println("Button C2 Pressed");
      value = 369.99;
      pressedKey = "f#";
      break;
    case "/G#":
      println("Button D2 Pressed");
      value = 415.30;
      pressedKey = "g#";
      break;
    case "/A#":
      println("Button E2 Pressed");
      value = 466.16;
      pressedKey = "a#";
      break;
    case "/C2#":
      println("Button D2 Pressed");
      value = 554.37;
      pressedKey = "c2#";
      break;
    case "/D2#":
      println("Button E2 Pressed");
      value = 622.25;
      pressedKey = "d2#";
      break;
    }
    if (event.getAction() == ControlP5.ACTION_PRESSED && pressedKey.equals("") == false) {
      println("in");
      playNote(value, pressedKey);
    }
    else if (event.getAction() == ControlP5.ACTION_RELEASED && pressedKey.equals("") == false) {
      println("out");
      stopNote(pressedKey);
    }
  }
}

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

void loadPauseWindow() {
  pauseDraw();
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

void drawBackButton(String lastPage) {
  backButton = button("changeBackButtonValue", "Back", calcWidth(80), calcHeight(80), calcWidth(120), calcHeight(60), button_color_transparent, button_hoverColor, button_pressColor, calcFontSize(30), font_color);
  backButton.setStringValue(lastPage);
}

void changeBackButtonValue() {
  method(backButton.getStringValue());
}

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

void textLabel(String label, float posX, float posY, float fontSize, color textColor) {
  PFont f = createFont("Courier", fontSize, true);
  textFont(f);
  fill(textColor);
  textAlign(CENTER);
  textSize(fontSize);
  text(label, posX, posY);
}

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


public void handleDrawSong(int value) {
  loadSetupDrawSong();
}

public void handleOwnSong(int value) {
  loadSelfPlayingDraw();
}

public void handleSetupContinue() {
  String prefix = "";
  if (fileName != null) {
    String[] list = split(fileName, ".");
    prefix = list[list.length-1];
  }
  if (fileName != null && prefix.equals("mp3")) {
    drawBackground = false;
    loadSongDrawPage();
  }
  else {
    errorMessage = "current Setup is not valid";
    showErrorMessage = true;
  }
}

public void handlePauseContinue() {
   hideUIObjects();
   loadSongDrawPage();
 }

public void handlePauseExit() {
  hideUIObjects();
  stopDraw();
  loadMainScreen();
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


public void quitGame() {
  exit();
}

public float calcHeight(float h) {
  return map(h, 0, 1080, 0, displayHeight);
}

public float calcWidth(float w) {
  return map(w, 0, 1920, 0, displayWidth);
}

public int calcFontSize(int f) {
  float x = map(f, 0, 1920, 0, displayWidth);
  float y = map(f, 0, 1080, 0, displayHeight);
  return int((x+y)/2);
}

void calcWave() {
  // Increment theta (try different values for 'angular velocity' here
  sineIncrement += 0.02;

  // For every x value, calculate a y value with sine function
  float x = sineIncrement;
  for (int i = 0; i < sineYValues.length; i++) {
    sineYValues[i] = sin(x)*sineHeight;
    x+=sineXIncrement;
  }
}

void renderWave() {
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

void pauseDraw() {
  paused = true;
  isDrawing = false;
  println("out Of Draw");
  if (audioFile != null) {
    audioFile.pause();
  }
}
void stopDraw() {
  paused = false;
  isDrawing = false;
  println("out Of Draw");
  if (audioFile != null) {
    audioFile.stop();
    audioFile = null;
  }
}

void startDraw() {
  isDrawing = true;
  println("inside Of Draw");
  paused = false;
  if (audioFile != null) {
    audioFile.play();
  }
}

void keyPressed(KeyEvent e) {
  if (currentPage.equals("loadSongDrawPage")) {
    if (key == ESC && !paused) {
      loadPauseWindow();
    }
    else if (key == ESC && paused) {
      handlePauseContinue();
    }
  }
  // Jeden Buchstaben nur einmal spielen lassen
  // if (osc1 == "c" || osc2 == "c") {return};
  float value = 0;
  String pressedKey = "";
  susPedal = 3; susLevel=2;
  switch(key) {
    case 'y': value = 261.63; if (osc1 == "c" || osc2 == "c") {return;} c1B.setColorBackground(piano_button_activeColor); pressedKey = "c"; break;
    case 's': value = 277.18; if (osc1 == "c#" || osc2 == "c#") {return;} c1hB.setColorBackground(pianoHalf_button_activeColor); pressedKey = "c#"; break;
    case 'x': value = 293.66; if (osc1 == "d" || osc2 == "d") {return;} d1B.setColorBackground(piano_button_activeColor); pressedKey = "d"; break;
    case 'd': value = 311.13; if (osc1 == "d#" || osc2 == "d#") {return;} d1hB.setColorBackground(pianoHalf_button_activeColor); pressedKey = "d#"; break;
    case 'c': value = 329.63; if (osc1 == "e" || osc2 == "e") {return;} e1B.setColorBackground(piano_button_activeColor); pressedKey = "e";break;
    case 'v': value = 349.23; if (osc1 == "f" || osc2 == "f") {return;} f1B.setColorBackground(piano_button_activeColor); pressedKey = "f";break;
    case 'g': value = 369.99; if (osc1 == "f#" || osc2 == "f#") {return;} f1hB.setColorBackground(pianoHalf_button_activeColor); pressedKey = "f#";break;
    case 'b': value = 392.00; if (osc1 == "g" || osc2 == "g") {return;} g1B.setColorBackground(piano_button_activeColor); pressedKey = "g";break;
    case 'h': value = 415.30; if (osc1 == "g#" || osc2 == "g#") {return;} g1hB.setColorBackground(pianoHalf_button_activeColor); pressedKey = "g#";break;
    case 'n': value = 440.00; if (osc1 == "a" || osc2 == "a") {return;} a1B.setColorBackground(piano_button_activeColor); pressedKey = "a";break;
    case 'j': value = 466.16; if (osc1 == "a#" || osc2 == "a#") {return;} a1hB.setColorBackground(pianoHalf_button_activeColor); pressedKey = "a#";break;
    case 'm': value = 493.88; if (osc1 == "b" || osc2 == "b") {return;} b1B.setColorBackground(piano_button_activeColor); pressedKey = "b";break;
    case ',': value = 523.25; if (osc1 == "c2" || osc2 == "c2") {return;} c2B.setColorBackground(piano_button_activeColor); pressedKey = "c2";break;
    case 'l': value = 554.37; if (osc1 == "c2#" || osc2 == "c2#") {return;} c2hB.setColorBackground(pianoHalf_button_activeColor); pressedKey = "c2#";break;
    case '.': value = 587.33; if (osc1 == "d2" || osc2 == "d2") {return;} d2B.setColorBackground(piano_button_activeColor); pressedKey = "d2";break;
    case 'ö': value = 622.25; if (osc1 == "d2#" || osc2 == "d2#") {return;} d2hB.setColorBackground(pianoHalf_button_activeColor); pressedKey = "d2#";break;
    case '-': value = 659.25; if (osc1 == "e2" || osc2 == "e2") {return;} e2B.setColorBackground(piano_button_activeColor); pressedKey = "e2"; break;
   

  }
  if (value != 0) {

    playNote(value, pressedKey);
  }
  key = 0;
}

void keyReleased() {
  susPedal = 1; susLevel=1; 
  switch(key) {
    case 'y': println("in"); stopNote("c"); c1B.setColorBackground(piano_button_color);  break;
    case 's':println("in"); stopNote("c#"); c1hB.setColorBackground(pianoHalf_button_color); break;
    case 'x':println("in"); stopNote("d"); d1B.setColorBackground(piano_button_color); break;
    case 'd':println("in"); stopNote("d#"); d1hB.setColorBackground(pianoHalf_button_color); break;
    case 'c':println("in"); stopNote("e"); e1B.setColorBackground(piano_button_color); break;
    case 'v':println("in"); stopNote("f"); f1B.setColorBackground(piano_button_color); break;
    case 'g':println("in"); stopNote("f#"); f1hB.setColorBackground(pianoHalf_button_color); break;
    case 'b':println("in"); stopNote("g"); g1B.setColorBackground(piano_button_color); break;
    case 'h':println("in"); stopNote("g#"); g1hB.setColorBackground(pianoHalf_button_color); break;
    case 'n':println("in"); stopNote("a"); a1B.setColorBackground(piano_button_color); break;
    case 'j':println("in"); stopNote("a#"); a1hB.setColorBackground(pianoHalf_button_color); break;
    case 'm':println("in"); stopNote("b"); b1B.setColorBackground(piano_button_color); break;
    case ',':println("in"); stopNote("c2"); c2B.setColorBackground(piano_button_color); break;
    case 'l':println("in"); stopNote("c2#"); c2hB.setColorBackground(pianoHalf_button_color); break;
    case '.':println("in"); stopNote("d2"); d2B.setColorBackground(piano_button_color); break;
    case 'ö':println("in"); stopNote("d2#"); d2hB.setColorBackground(pianoHalf_button_color); break;
    case '-':println("in"); stopNote("e2"); e2B.setColorBackground(piano_button_color); break;
  }
}
