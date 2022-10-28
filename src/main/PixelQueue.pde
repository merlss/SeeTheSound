class PixelQueue {

  int max = width;

  int front = -1;
  int size = -1;
  int rear = -1;

  Column[] columns = new Column[width];



  PixelQueue(color bright, color dark) {
    for (int col = 0; col < width; col++) {

      Column column = new Column(0.01, dark, bright);
      columns[col] = column;
    }
  }

  void drawPixels() {
    int i = 0;
    for (int col = 0; col < width; col++) {
      for (int row = 0; row < height; row++) {
        if (front + col < width) {
          i = front + col;
        }
        else {
          i = front + col - width;
        }
        pixels[row * width + col] = columns[i].colors[row];
      }
    }
  }

  void enqueue(Column col) {
    if (size < 1) {
      front = 0;
      rear = 1;
      size = 1;
    }
    else if (rear == front) {
      dequeue();
      rear++;
      size++;
    }
    else if (rear == max-1) {
      rear = 0;
      size++;
    }
    else {
      rear++;
      size++;
    }
    columns[rear] = col;
  }

  void dequeue() {
    if (size < 1) {
      return;
    }
    else if (front == max-1) {
      front = 0;
      size--;
    }
    else {
      front++;
      size--;
    }
  }

}
