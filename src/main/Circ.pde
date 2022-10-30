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
