ArtGenerator gen1;

void setup() {

  size(800, 600);
  background(255);
  strokeWeight(2);
  smooth();

  gen1 = new ArtGenerator();
  gen1.initShape(10);
}

void draw() {

  //gen1.drawCircle();

  gen1.drawLines();




}
