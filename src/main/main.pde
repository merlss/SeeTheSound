import controlP5.*;

// ui Elements
ControlP5 ui;
PFont f;
ControlFont font;
color button_color = color(255, 50, 50, 255);
color button_hoverColor = color(255, 100, 100, 200);
color button_pressColor = color(255, 0, 0, 255);
color text_color = color(0);

Button drawSongButton;
Button selfPlayingButton;
Button exitButton;
Button backButton;

String currentPage;


void setup() {
  size(displayWidth, displayHeight);
  ui = new ControlP5(this);
  f = createFont("Courier", 20);
  font = new ControlFont(f);


  loadMainScreen();
}


void draw() {

}

void loadMainScreen() {
  background(255);
  hideUIObjects();
  if (drawSongButton == null) {
    textLabel("See the Sound", displayWidth/2, 200, 100, text_color);
    drawSongButton = button("handleDrawSong", "Draw Song", displayWidth/2, 400, 600, 100, button_color, button_hoverColor, button_pressColor, 50);
    selfPlayingButton = button("handleOwnSong", "Make your own Song", displayWidth/2, 550, 600, 100, button_color, button_hoverColor, button_pressColor, 50);
    exitButton = button("quitGame", "Quit", displayWidth/2, 700, 600, 100, button_color, button_hoverColor, button_pressColor, 50);
  }
  else {
    textLabel("See the Sound", displayWidth/2, 200, 100, text_color);
    drawSongButton.show();
    selfPlayingButton.show();
    exitButton.show();
  }
  currentPage = "loadMainScreen";
}

void loadSetupDrawSong() {
  background(255);
  hideUIObjects();
  if (backButton == null) {
    textLabel("Setup", displayWidth/2, 200, 80, text_color);
    drawBackButton(currentPage);
  }
  else {
    backButton.setStringValue(currentPage);
    backButton.show();
  }
  currentPage = "loadSetupDrawSong";
}

void drawBackButton(String lastPage) {
  backButton = button("changeBackButtonValue", "Back", 80, 80, 120, 60, button_color, button_hoverColor, button_pressColor, 30);
  backButton.setStringValue(currentPage);
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

}

Button button(String linkedFunction, String label, float posX, float posY, int w, int h, color col, color hoverCol, color pressCol, int fontSize) {
  Button button;
  button = ui.addButton(linkedFunction)
  .setBroadcast(false) //disable button trigger
  .setSize(w, h)
  .setPosition(posX - w/2, posY - h/2)
  .setColorBackground(col)
  .setColorForeground(hoverCol)
  .setColorActive(pressCol)
  .setBroadcast(true); // enable button trigger

  button.setLabel(label);

  font = new ControlFont(f, fontSize);

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
  println(value);
}


public void quitGame() {
  exit();
}
