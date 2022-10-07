import controlP5.*;
import processing.sound.*;


//general
float dWidth;
float dHeight;
color bgColor = color(255);

// ui Elements
ControlP5 ui;
PFont f;
ControlFont font;
color button_color = color(255, 50, 50, 255);
color button_hoverColor = color(255, 100, 100, 200);
color button_pressColor = color(255, 0, 0, 255);
color text_color = color(0);

Button backButton;

String currentPage = "loadMainScreen";

// mainScreen Variables
Button drawSongButton;
Button selfPlayingButton;
Button exitButton;


//drawSong Variables
SoundFile audioFile;
Button selectFileButton;
String fileName;
boolean showFileName;

void setup() {
  size(displayWidth, displayHeight);
  ui = new ControlP5(this);
  f = createFont("Courier", 20, true);
  font = new ControlFont(f);
  dWidth = displayWidth;
  dHeight = displayHeight;

  loadMainScreen();
}


void draw() {
  //background(bgColor);
  //method(currentPage);
  if (showFileName && fileName != null) {
    textLabel(fileName, calcWidth((dWidth/2)+250), calcHeight(400+calcFontSize(35/2)), calcFontSize(35), text_color);
    showFileName = false;
  }
}

void loadMainScreen() {
  String lastPage = currentPage;
  currentPage = "loadMainScreen";
  background(bgColor);
  hideUIObjects();
  if (drawSongButton == null) {
    textLabel("See the Sound", calcWidth(dWidth/2), calcHeight(200),  calcFontSize(100), text_color);
    drawSongButton = button("handleDrawSong", "Draw Song", calcWidth(dWidth/2), calcHeight(400), calcWidth(600), calcHeight(100), button_color, button_hoverColor, button_pressColor, calcFontSize(50));
    selfPlayingButton = button("handleOwnSong", "Make your own Song", calcWidth(dWidth/2), calcHeight(550), calcWidth(600), calcHeight(100), button_color, button_hoverColor, button_pressColor, calcFontSize(50));
    exitButton = button("quitGame", "Quit", calcWidth(dWidth/2), calcHeight(700), calcWidth(600), calcHeight(100), button_color, button_hoverColor, button_pressColor, calcFontSize(50));
  }
  else {
    textLabel("See the Sound", calcWidth(dWidth/2), calcHeight(200), calcFontSize(100), text_color);
    drawSongButton.show();
    selfPlayingButton.show();
    exitButton.show();
  }
}

void loadSetupDrawSong() {
  String lastPage = currentPage;
  currentPage = "loadSetupDrawSong";
  background(bgColor);
  hideUIObjects();
  if (selectFileButton == null) {
    textLabel("Setup", calcWidth(dWidth/2), calcHeight(200), calcFontSize(80), text_color);
    drawBackButton(lastPage);
    selectFileButton = button("handleFileSelect", "Select Audiofile", calcWidth((dWidth/2)-250), calcHeight(400), calcWidth(400), calcHeight(70), button_color, button_hoverColor, button_pressColor, calcFontSize(35));

  }
  else {
    textLabel("Setup", calcWidth(dWidth/2), calcHeight(200), calcFontSize(80), text_color);
    backButton.setStringValue(lastPage);
    backButton.show();
    selectFileButton.show();
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

  font = new ControlFont(f, int(fontSize));

  button.getCaptionLabel()
  .setFont(font)
  .toUpperCase(false);
  return button;
}

void textLabel(String label, float posX, float posY, float fontSize, color textColor) {
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

void fileSelected(File file) {
  if (file != null) {
    String[] list = split(file.getAbsolutePath(), "\\");
    fileName = list[list.length-1];
    fill(color(255,0,0));

    showFileName = true;
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
