class Column {

  color[] colors = new color[height];

  Column(float wave, color dark, color bright) {
    int mid = height / 2;
    int offset;
    if (wave > 0) {
      offset = (int)map(wave, 0, 1, height/16, height/8);
    }
    else {
      offset = (int)map(wave, -1, 0, -height/8, -height/16);
    }

    for(int i = 0; i < height; i++) {
      if (mid - abs(offset) <= i && mid + abs(offset) >= i) {
        colors[i] = dark;
      }
      else {
        colors[i] = bright;
      }
    }
  }
}
