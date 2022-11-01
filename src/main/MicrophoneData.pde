/*
Phuong
*/

import processing.sound.*;

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


  void setupMic(AudioIn _in, Amplitude _amp) {

    circs = new Circ[howMany];
    in = _in;
    amp = _amp;
    _in.start();
    _amp.input(in);

    for (int i = 0; i < howMany; i++) {

      circs[i] = new Circ(random(width), random(height), random(10)+5, cols[int(random(3))], strs[int(random(3))], 2, random(-3, 3));
      circs[i].display();
    }
  }

  void drawCircles() {

    ampt = amp.analyze();

    if (ampt>0.030) {
      flashNow=true;
    } else
    flashNow=false;

    for (int x = 0; x < howMany; x++) {
      if (flashNow) {
        circs[x].col=color(random(255), random(255));
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
