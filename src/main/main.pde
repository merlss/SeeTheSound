import controlP5.*;
import processing.sound.*;


//general
float dWidth;
float dHeight;
color bgColor = color(46,46,72,255);
color lightBgColor = color(116,116,142,255);

// ui Elements
ControlP5 ui;
//PFont f;
ControlFont font;
color button_color = color(77,76,108,255);
color button_hoverColor = color(87,86,118,255);
color button_pressColor = color(36,36,62,255);
color text_color = color(255);

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
boolean showPauseWindow;
Button pauseContinueButton;
Button pauseExitButton;

//background
boolean drawBackground;
int sineWaveResolution = 8;
int sineWidth;
float sineIncrement = 0.0;
float sineHeight = 140.0;
float sinePeriod = 500.0;
float sineXIncrement;
float[] sineYValues;
color sineColor = color(92,118,199,255);

void setup() {
  size(displayWidth, displayHeight);
  ui = new ControlP5(this);
  PFont f = createFont("Courier", 20, true);
  font = new ControlFont(f);
  dWidth = displayWidth;
  dHeight = displayHeight;

  sineWidth = width/2+width/4;
  sineXIncrement = (TWO_PI / sinePeriod) * sineWaveResolution;
  sineYValues = new float[sineWidth/sineWaveResolution];

  drawBackground = true;

  loadMainScreen();
}


void draw() {
  background(bgColor);
  if (drawBackground) {
    calcWave();
    renderWave();
  }
  if (showFileName && fileName != null) {
    textLabel(fileName, calcWidth((dWidth/2)+250), calcHeight(400+calcFontSize(35/2)), calcFontSize(35), text_color);
  }
  if (showErrorMessage && errorMessage != null) {
    textLabel(errorMessage, calcWidth((dWidth/2)), calcHeight(700+calcFontSize(35/2)), calcFontSize(25), color(220,40,40));
  }
  if (showPauseWindow) {
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
  textLabel("See the Sound", calcWidth(dWidth/2), calcHeight(200), calcFontSize(100), text_color);
}

void drawSetupScreen() {
  textLabel("Setup", calcWidth(dWidth/2), calcHeight(200), calcFontSize(80), text_color);
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
    drawSongButton = button("handleDrawSong", "Draw Song", calcWidth(dWidth/2), calcHeight(400), calcWidth(600), calcHeight(100), button_color, button_hoverColor, button_pressColor, calcFontSize(50));
    selfPlayingButton = button("handleOwnSong", "Make your own Song", calcWidth(dWidth/2), calcHeight(550), calcWidth(600), calcHeight(100), button_color, button_hoverColor, button_pressColor, calcFontSize(50));
    exitButton = button("quitGame", "Quit", calcWidth(dWidth/2), calcHeight(700), calcWidth(600), calcHeight(100), button_color, button_hoverColor, button_pressColor, calcFontSize(50));
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
  String lastPage = currentPage;
  currentPage = "loadSetupDrawSong";
  background(bgColor);
  hideUIObjects();
  if (selectFileButton == null) {
    drawSetupScreen();
    drawBackButton(lastPage);
    selectFileButton = button("handleFileSelect", "Select Audiofile", calcWidth((dWidth/2)-250), calcHeight(400), calcWidth(400), calcHeight(70), button_color, button_hoverColor, button_pressColor, calcFontSize(35));
    setupContinueButton = button("handleSetupContinue", "Continue", calcWidth(dWidth/2), calcHeight(800), calcWidth(600), calcHeight(100), button_color, button_hoverColor, button_pressColor, calcFontSize(50));
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
    audioFile.play();
  }
  else {
    showErrorMessage = true;
  }
}

void loadPauseWindow() {
  showPauseWindow = true;
  if (pauseContinueButton == null) {
    pauseContinueButton = button("handlePauseContinue", "Continue", calcWidth(dWidth/2), calcHeight(320), calcWidth(380), calcHeight(100), button_color, button_hoverColor, button_pressColor, calcFontSize(50));
    pauseExitButton = button("handlePauseExit", "Exit", calcWidth(dWidth/2), calcHeight(750), calcWidth(380), calcHeight(100), button_color, button_hoverColor, button_pressColor, calcFontSize(50));
  }
  else {
    pauseContinueButton.show();
    pauseExitButton.show();
  }
}

void drawBackButton(String lastPage) {
  backButton = button("changeBackButtonValue", "Back", calcWidth(80), calcHeight(80), calcWidth(120), calcHeight(60), button_color, button_hoverColor, button_pressColor, calcFontSize(30));
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
   showPauseWindow = false;
 }

public void handlePauseExit() {
  hideUIObjects();
  showPauseWindow = false;
  loadMainScreen();
}
void fileSelected(File file) {
  if (file != null) {
    String path = file.getAbsolutePath();
    audioFile = new SoundFile(this, path);
    String[] list = split(path, "\\");
    fileName = list[list.length-1];

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
  strokeWeight(10);
  for (int x = 1; x < sineYValues.length; x++) {
    float g = map((x-1)*sineWaveResolution, 0, sineWidth, 0, 255);
    col = color(red(sineColor), g, blue(sineColor));
    stroke(col);
    line((x-1)*sineWaveResolution, height/2+sineYValues[(x-1)], x*sineWaveResolution, height/2+sineYValues[x]);
  }
}

void keyPressed() {
  if (key == ESC) {
    key = 0;
    loadPauseWindow();
  }
}
