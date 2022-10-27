class Column {

  color[] colors = new color[height];

  Column(float wave, color dark, color bright) {
    int mid = height / 2;
    int offset = (int)map(wave, -1, 1, -height/4, height/4);

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
