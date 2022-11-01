/*
Merle Krauss
*/

// handle art in the self playing mode
class KeyboardData extends Art {

  KeyboardData() {
    super();
  }

// depending on the piano keys a new shape is initialized in the parent
  void initNewShape(float value, color col) {

    int size = 0;

    if (value > 500) {
      size = (int)map(value, 400, 623, 150, 70);
      initCircle(size, col);
    }
    else {

      size = (int)map(value, 260, 500, 50, 30);
      initSplash(size, col);
    }
  }
}
