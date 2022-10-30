class MicrophoneData {

  Circ[] circs; //we will store our circles inside an array

  int howMany = 18;
  boolean ANIMATE = true;
  boolean flashNow=false;
  color[] cols = {color(255), color(255), color(255)};
  color[] strs = {color(255), color(255), color(255)};

  Amplitude amp;
  AudioIn in;
  float ampt;

  void setupMic() {

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

  void drawCircles() {

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
}
