class Stroke {

  FloatList mPoints_x = new FloatList();
  FloatList mPoints_y = new FloatList();
  ArrayList<Integer> mWeight = new ArrayList<Integer>();


  void addPoint(float x, float y) {

    mPoints_x.append(x);
    mPoints_y.append(y);
  }

  void addPoint(float x, float y, int w) {

    mPoints_x.append(x);
    mPoints_y.append(y);
    mWeight.add(w);
  }

  FloatList getStrokeX() {

    return mPoints_x;
  }

  FloatList getStrokeY() {

    return mPoints_y;
  }

  int getWeight(int i) {

    return mWeight.get(i);
  }
}
