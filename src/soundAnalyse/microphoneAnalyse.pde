import processing.sound.*;


Circ[] circs; //we will store our circles inside an array

int howMany = 18;
boolean ANIMATE = true;
boolean flashNow=false;
color[] cols = {color(255), color(255), color(255)};
color[] strs = {color(255), color(255), color(255)};

Amplitude amp;
AudioIn in;
float ampt;



void setup() {

  size(800, 600);
  fill(255, 204);
  noStroke();
  smooth();
  circs = new Circ[howMany];

  for (int i = 0; i < howMany; i++) {

    circs[i] = new Circ(random(width), random(height), random(10)+5, cols[int(random(3))], strs[int(random(3))], 2, random(-3, 3));
    circs[i].display();
  }

  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
}


void draw() {
  background(0, 0, 0);

  ampt = amp.analyze();
  println(ampt);



  if (ampt>0.030) {
    flashNow=true;
  } else
  flashNow=false;

  for (int x = 0; x < howMany; x++) {
    if (flashNow) {
      circs[x].col=color(random(255), random(255));
      ;
    } else {
      circs[x].col=color(255);
    }


    if (ANIMATE) {
      circs[x].update();
    }

    circs[x].display();
  }
}

class Circ {

  float xpos;
  float ypos ;
  float d; // diameter
  color col;
  color strCol;
  int strW;
  float speedX;
  float speedY;

  Circ(float ixp, float iyp, float id, color c, color s, int sW, float sp) {
    //println ("circle created");
    xpos = ixp;
    ypos = iyp;
    d = id;
    col = c;
    strCol = s;
    strW = sW;
    speedX  = sp;
    speedY  = sp;
  }

  void display() {
    //if (ANIMATE)
    fill(col);

    stroke(strCol);
    strokeWeight(strW);
    ellipse(xpos, ypos, 60, 60);
  }

  void update() {
    if ((xpos > width)||(xpos < 0)) {
      //println("x edge detected");
      speedX *= -1;
      //println("speed now: " + speedX);
    }
    if ((ypos > height)||(ypos <0)) {
      //println("y edge detected");
      speedY *= -1;
      //println("speed now: " + speedY);
    }
    //updates xpos and ypos
    xpos = xpos + speedX;
    ypos = ypos + speedY;
  }
}

void mousePressed() {
  background(255);
  println(frameRate);

  for (int x = 0; x < howMany; x++) { //
    circs[x].update();
    circs[x].xpos = random(0, width);
    circs[x].ypos = random(0, height);
    circs[x].display();
  }
}

void keyPressed() {
  if (key=='1') ANIMATE= true;
  if (key=='2') ANIMATE= false;
  println("Animate?: ", ANIMATE);
}
