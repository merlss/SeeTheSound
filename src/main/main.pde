import controlP5.*;
import processing.sound.*;


//general
float dWidth;
float dHeight;
color bgColor = color(46,46,72,255);
color lightBgColor = color(116,116,142,255);

// ui Elements
ControlP5 ui;

Sound sound;
//PFont f;
ControlFont font;

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

  drawBackground = true;
  int rand = int(random(1,4));
  if (rand == 1) {
    bgPicture = loadImage("painting1.jpg");
    image(bgPicture, 0, 0, displayWidth, displayHeight);
    loadPixels();
    for (int i = 0; i < pixels.length; i++ ) {
    color pixel = pixels[i];
      pixels[i] = color(int(red(pixel)*darkness), int(green(pixel)*darkness), int(blue(pixel)*darkness));
    }
    updatePixels();
  updatePixels();
  } else if (rand == 2) {
    bgPicture = loadImage("painting1.jpg");
    image(bgPicture, 0, 0, displayWidth, displayHeight);
    loadPixels();
    for (int i = 0; i < pixels.length; i++ ) {
    color pixel = pixels[i];
      pixels[i] = color(int(red(pixel)*darkness), int(green(pixel)*darkness), int(blue(pixel)*darkness));
    }
    updatePixels();
  } else if (rand == 3) {
    bgPicture = loadImage("painting1.jpg");
    image(bgPicture, 0, 0, displayWidth, displayHeight);
    loadPixels();
    for (int i = 0; i < pixels.length; i++ ) {
    color pixel = pixels[i];
      pixels[i] = color(int(red(pixel)*darkness), int(green(pixel)*darkness), int(blue(pixel)*darkness));
    }
    updatePixels();
  }

  loadMainScreen();
}


void draw() {
  background(bgColor);
  if (bgPicture != null) {
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
  if (currentPage == "loadMainScreen") {
    drawMainScreen();
  }
  else if (currentPage == "loadSetupDrawSong") {
    drawSetupScreen();
  }
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
  hideUIObjects();
  if (drawSongButton == null) {
    drawMainScreen();
    int x = 1600;
    drawSongButton = button("handleDrawSong", "Draw Song", calcWidth(dWidth/2), calcHeight(800), calcWidth(400), calcHeight(50), button_color_transparent, button_hoverColor, button_pressColor, calcFontSize(35));
    selfPlayingButton = button("handleOwnSong", "Make your own Song", calcWidth(dWidth/2), calcHeight(880), calcWidth(400), calcHeight(50), button_color_transparent, button_hoverColor, button_pressColor, calcFontSize(35));
    exitButton = button("quitGame", "Quit", calcWidth(dWidth/2), calcHeight(960), calcWidth(400), calcHeight(50), button_color_transparent, button_hoverColor, button_pressColor, calcFontSize(35));
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
    selectFileButton = button("handleFileSelect", "Select Audiofile", calcWidth((dWidth/2)), calcHeight(780), calcWidth(400), calcHeight(50), button_color_transparent, button_hoverColor, button_pressColor, calcFontSize(35));
    setupContinueButton = button("handleSetupContinue", "Continue", calcWidth(dWidth/2), calcHeight(920), calcWidth(400), calcHeight(50), button_color_transparent, button_hoverColor, button_pressColor, calcFontSize(35));
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
  }
  else {
    showErrorMessage = true;
  }
  startDraw();
}

void loadPauseWindow() {
  pauseDraw();
  if (pauseContinueButton == null) {
    pauseContinueButton = button("handlePauseContinue", "Continue", calcWidth(dWidth/2), calcHeight(320), calcWidth(380), calcHeight(100), button_color, button_hoverColor, button_pressColor, calcFontSize(50));
    pauseExitButton = button("handlePauseExit", "Exit", calcWidth(dWidth/2), calcHeight(750), calcWidth(380), calcHeight(100), button_color, button_hoverColor, button_pressColor, calcFontSize(50));
    pauseVolumeSlider = slider("volume", " Volume", calcWidth(dWidth/2), calcHeight(450), calcWidth(200), calcHeight(40), calcFontSize(50));
  }
  else {
    pauseContinueButton.show();
    pauseExitButton.show();
    pauseVolumeSlider.show();
  }
}

void drawBackButton(String lastPage) {
  backButton = button("changeBackButtonValue", "Back", calcWidth(80), calcHeight(80), calcWidth(120), calcHeight(60), button_color_transparent, button_hoverColor, button_pressColor, calcFontSize(30));
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
}


Button button(String linkedFunction, String label, float posX, float posY, float w, float h, color col, color hoverCol, color pressCol, float fontSize) {
  Button button;
  button = ui.addButton(linkedFunction)
  .setBroadcast(false) //disable button trigger
  .setSize(int(w), int(h))
  .setPosition(posX - w/2, posY - h/2)
  .setColorBackground(col)
  .setColorForeground(hoverCol)
  .setColorActive(pressCol)
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
   startDraw();
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
  if (audioFile != null) {
    audioFile.pause();
  }
}
void stopDraw() {
  paused = false;
  if (audioFile != null) {
    audioFile.stop();
    audioFile = null;
  }
}

void startDraw() {
  paused = false;
  if (audioFile != null) {
    audioFile.play();
  }
}

void keyPressed() {
  if (currentPage.equals("loadSongDrawPage")) {
    if (key == ESC && !paused) {
      loadPauseWindow();
    }
    else if (key == ESC && paused) {
      handlePauseContinue();
    }
  }
  key = 0;
}
