//ArtGenerator gen1;

Generator gen1;

void setup() {

  size(800, 600);
  background(0);
  stroke(100);
  smooth();
  frameRate(16);

  //noLoop();

  gen1 = new Generator();
  gen1.initShape();
}

void draw() {

  //gen1.drawCircle();

  gen1.drawShape();




}
