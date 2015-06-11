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


/*
///////Bezier class
*/

class Bz {

  int n;
  PVector[] P;
  PVector[] R;
  float fineness;
  PVector[] ac;
  boolean swt_txt_pnt=true;


  Bz(int _n, int fine) {
    this.n = _n;
    P = new PVector[n];
    setPoint_random();

    fineness = fine;
    R = new PVector[int(fineness)];
    ac = new PVector[n];
  }

  void setPoint_random() {
    for (int i=0; i<n; i++) {
      P[i] = new PVector(int(random(600)), int(random(600)));
    }
  }

  int mR_count=0;
  //set point yourself
  void mouseReleased() {
    P[mR_count].x = mouseX;
    P[mR_count].y = mouseY;

    mR_count ++;
    if (mR_count == n) mR_count = 0;
  }



  double makeBt(int i, float ttt) {
    double ans=(float)1.0;
    int count=0;
    int cmb_c=0;
    int fCount = 0;

    if (i < (n-1)/2) {
      fCount = n-1-i;
    } else {
      fCount = i;
    }

    if (n-1 == i) {
      cmb_c = 0;
    } else  if (i > int((n-1)/2)) {
      cmb_c = n-1-i;
    } else {
      cmb_c = i;
    }

    while (count < fCount) {
      if (count < cmb_c) {
        ans *= (float)(n-1-count);
        ans /= (float)(cmb_c-count);
      }

      if (count < n-1-i) {
        ans*=(1-ttt);
      }

      if (count < i) {
        ans*=ttt;
      }

      count++;
    }

    return ans;
  }


  void drawPoint() {
    for (int i=0; i<n; i++) {
      int c = int(map((P[i].x+P[i].y)/2, 0, (width+height)/2, 0, 360));
      noStroke();
      fill(c, 100, 100, 150);

      ellipse(P[i].x, P[i].y, 10, 10);
    }
  }

  void drawText() {
    fill(255);
    for (int i=0; i<n; i++) {
      String s = "P" + str(i);
      text(s, P[i].x+10, P[i].y+10);
    }
  }


  void setBz() {
    if (swt_txt_pnt) {
      drawPoint();
      drawText();
    }

    int tt;
    float t = 0.0;
    float ts = (float)1 / fineness;

    double[] Bt = new double[n];

    noFill();
    stroke(255);

    for (tt = 0; tt < fineness; tt++) {

      for (int i=0; i<n; i++) {

        Bt[i] = makeBt(i, t);

        //Bt[i] = combi(n-1, i) * pow((1-t), n-1-i) * pow(t, i);
        /*
        println("make_ans["+i+"]:" + make_ans(i, t));
         //println("Bt["+i+"]:   " + Bt[i]);
         println("=======================");
         */
      }

      R[tt] = new PVector(0, 0);

      for (int i=0; i<n; i++) {
        R[tt].x += Bt[i] * P[i].x;
        R[tt].y += Bt[i] * P[i].y;
      }

      t += ts;
    }
  }

  void drawBz() {
    int tt;
    for (tt = 0; tt<fineness; tt++) {
      int c = int(map((R[tt].x + R[tt].y)/2, 0, (width+height)/2*0.8, 0, 360));
      stroke(c, 100, 100);
      if (tt != 0) line(R[tt-1].x, R[tt-1].y, R[tt].x, R[tt].y);
    }
  }
  boolean flowBz_swt;

  void flowBz() {
    int tt;
    int tmp = frameCount%int(fineness);
    if (flowBz_swt) {

      for (tt = 0; tt<tmp; tt++) {
        int c = int(map((R[tt].x + R[tt].y)/2, 0, (width+height)/2*0.8, 0, 360));
        stroke(c, 100, 100);
        if (tt != 0) line(R[tt-1].x, R[tt-1].y, R[tt].x, R[tt].y);
      }
      if (tmp == fineness-1) flowBz_swt =! flowBz_swt;
    } else {
      
      for (tt = int(fineness)-tmp-1; tt>0; tt--) {
     
        int c = int(map((R[tt].x + R[tt].y)/2, 0, (width+height)/2*0.8, 0, 360));
        stroke(c, 100, 100);
        if (tt != 0) line(R[tt-1].x, R[tt-1].y, R[tt].x, R[tt].y);
      }

      if (tmp == fineness-1) flowBz_swt =! flowBz_swt;
    }
  }


  //mousePointer dragg the point
  void mouseDragged() {
    for (int i=0; i<n; i++) {
      int dis = int(dist(mouseX, mouseY, P[i].x, P[i].y)); 
      if (dis < 40) {
        P[i].x = mouseX; 
        P[i].y = mouseY; 
        break;
      }
    }
  }

  //set poiont's acc
  void setAc() {
    for (int i=0; i<n; i++) {
      ac[i] = new PVector(); 
      ac[i].x = int(random(1, 5)); 
      ac[i].y = int(random(1, 5));
    }
  }

  void movingPoint() {
    for (int i=0; i<n; i++) {
      P[i].x += ac[i].x; 
      P[i].y += ac[i].y; 

      if (P[i].x > width || P[i].x < 0) ac[i].x *= -1; 
      if (P[i].y > height || P[i].y < 0) ac[i].y *= -1;
    }
  }
}