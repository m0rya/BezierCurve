Bz tes;
int n;
int fineness = 100;
boolean[] mode = new boolean[3];
boolean point_onf = true;
boolean flow_mode = false;
boolean menu = true;

void setup() {
  n = 4;

  colorMode(HSB, 360, 100, 100);
  size(800, 800);
  tes = new Bz(n, fineness);
  tes.setAc();
  mode[2] = true;
}

void draw() {

  background(40);

  tes.setBz();
  if (!flow_mode) {
    tes.drawBz();
  } else {
    tes.flowBz();
  }

  if (mode[2]) {
    tes.movingPoint();
  }
  if (menu) {
    textSize(15);
    fill(20, 100, 100);
    text("N  (UP : 'SPACE', DOWN : 'z') :" + n, 20, 20);
    text("fineness:" + fineness, 20, 40);

    fill(300, 100, 100);
    text ("show point ('q') : " + tes.swt_txt_pnt, 20, 60);
    text("Expansin and contraction ('w') : " + flow_mode, 20, 80);

    fill(100, 100, 100);
    text("set point yourself  ('a')", 20, 120);
    text("you can dragg   ('s')", 20, 140);
    text("moving  ('d')", 20, 160);

    for (int i=0; i<3; i++) {
      if (mode[i]) fill(20, 100, 100);
      else fill(100, 100, 100);
      text(": " + str(mode[i]), 200, i*20+120);
    }
  }
}


void mouseReleased() {
  if (mode[0]) {
    tes.mouseReleased();
  }
}

void mouseDragged() {
  if (mode[1]) {
    tes.mouseDragged();
  }
}



void keyPressed() {
  if (key == ' ') {
    n++;
    fineness = int(map(n, 4, 200, 100, 500));
    boolean tmp = tes.swt_txt_pnt;

    tes = new Bz(n, fineness);
    tes.swt_txt_pnt = tmp;
    tes.setAc();
  }

  if (key == 'z') {
    n--;
    fineness = int(map(n, 4, 200, 100, 1000));
    boolean tmp = tes.swt_txt_pnt;
    tes = new Bz(n, fineness);
    tes.swt_txt_pnt = tmp;
    tes.setAc();
  }

  if (key == 'q') {
    tes.swt_txt_pnt = !tes.swt_txt_pnt;
  }
  if (key == 'w') {
    flow_mode =! flow_mode;
  }
  if (key == 'm') {
    menu =! menu;
  }
  if (keyPressed) {
    if (key=='a' || key=='s' || key=='d') {
      for (int i=0; i<3; i++) {
        mode[i] = false;
      }

      switch(key) {
      case 'a':
        mode[0] = true;
        break;

      case 's':
        mode[1] = true;
        break;

      case 'd':
        mode[2] = true;
        break;
      }
    }
  }
}


