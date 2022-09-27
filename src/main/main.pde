import controlP5.*;

// ui Elements
ControlP5 ui;
ControlFont font;
color button_color = color(255, 50, 50, 255);
color button_hoverColor = color(255, 100, 100, 200);
color button_pressColor = color(255, 0, 0, 255);

Button button1;


void setup() {
  size(displayWidth, displayHeight, P3D);

  ui = new ControlP5(this);
  PFont f = createFont("Courier", 20);
  font = new ControlFont(f);

  button1 = button("Audio", 500, 500, 500, 200, button_color, button_hoverColor, button_pressColor, 24);

}

void draw() {

}

Button button(String name, float posX, float posY, int w, int h, color col, color hoverCol, color pressCol, int fontSize) {
  Button button;
  button = ui.addButton(name)
  .setValue(0)
  .setPosition(posX, posY)
  .setSize(w, h)
  .setColorBackground(col)
  .setColorForeground(hoverCol)
  .setColorActive(pressCol);

  button.getCaptionLabel()
  .setFont(font)
  .toUpperCase(false);

  return button;
}

public void controlEvent(ControlEvent event) {
  println(event.getController().getName());
}
