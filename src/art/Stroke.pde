class Stroke {

  ArrayList<float> mPoints_x = new ArrayList<float>;
  ArrayList<float> mPoints_y = new ArrayList<float>;
  ArrayList<int> mWeight = new ArrayList<int>;


  void addPoint(float x, float y) {

    mPoints_x.add(x);
    mPoints_y.add(y);
  }

  void addPoint(float x, float y, int w) {

    mPoints_x.add(x);
    mPoints_y.add(y);
    mWeight.add(w);
  }

  ArrayList<float> getStrokeX() {

    return mPoints_x;
  }

  ArrayList<float> getStrokeY() {

    return mPoints_y;
  }

  int getWeight(int i) {

    return mWeight.get(i);
  }
}
