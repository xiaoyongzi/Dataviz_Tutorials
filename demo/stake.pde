Bubble bubblechart;
PFont font;

void setup() {
  size(800,600);//"processing.core.PGraphicsRetina2D");
  bubblechart = new Bubble(100, 100, 640, 400);
  smooth(8);
  bubblechart.mapping();
  font = createFont("MicrosoftYaHei", 20);
  textFont(font);
  //hint(ENABLE_RETINA_PIXELS);
}

void draw() {
  background(255);
  stroke(0);
  noFill();
  //rect(80, 100, 640, 400);
  bubblechart.setR();
  bubblechart.hoverSet();
  bubblechart.drawRefline();
  bubblechart.display();
  bubblechart.drawFreq();
  bubblechart.drawRefarrow();
}

void mouseReleased() {
  bubblechart.lock = false;
}

class Bubble {
  ArrayList<Particle> stock;
  int num_stock;
  String[] names;
  int[] values;
  int[] incr_per;
  int[] holdings;
  String[] category_names;
  int[] category_num;
  float[] x;
  float[] y;
  float[] r;
  int chartX;
  int chartY;
  int chartHeight;
  int chartWidth;
  int min_inc;
  int max_inc;
  int min_hold;
  int max_hold;
  int rowCount;
  int max_value;
  float[] distance;
  int range_num;
  float incre;
  boolean lock = false;


  Bubble(int chartX, int chartY, int chartWidth, int chartHeight) {
    String[] rows = loadStrings("stock.csv");
    x = new float[rows.length];
    y = new float[rows.length];
    r = new float[rows.length];
    distance = new float[rows.length];
    incr_per = new int[rows.length];
    names = new String[rows.length];
    category_names = new String[rows.length];
    category_num = new int[rows.length];
    holdings = new int[rows.length];
    values = new int[rows.length];
    for (int i=0;i<rows.length;i++) {
      String[] pieces = split(rows[i], ',');
      //println(pieces);
      names[i] = pieces[0];
      values[i] = parseInt(pieces[3]);
      //println(pieces[2]);
      incr_per[i] = int(pieces[1]);
      holdings[i] = parseInt(pieces[2]);
      category_names[i] = pieces[5];
      category_num[i] = parseInt(pieces[4]);
    }
    this.chartX = chartX;
    this.chartY = chartY;
    this.chartHeight = chartHeight;
    this.chartWidth = chartWidth;
    min_inc = min(incr_per);
    max_inc = max(incr_per);
    min_hold= min(holdings);
    max_hold= max(holdings);
    max_value = max(values);
    rowCount = rows.length;
    stock = new ArrayList<Particle>();
    range_num = 15;
    incre = 200;
  }

  void mapping() {
    for (int i =0;i<x.length;i++) {
      y[i] = chartY+chartHeight-map(incr_per[i], min_inc, max_inc, 0, chartHeight);
      if (holdings[i]>=0) {
        x[i] = chartX+map(holdings[i], 0, max_hold, 0.5*chartWidth, chartWidth);
      } 
      else {
        x[i] = chartX+map(holdings[i], min_hold, 0, 0, 0.5*chartWidth);
      }
      r[i] = map(values[i], 0, max(values), 0.01*chartHeight, 0.05*chartHeight);
      stock.add(new Particle(x[i], y[i], r[i], category_num[i], names[i], true));
    }
  }

  void drawFreq() {
    drawFreqX();
    drawFreqY();
  }


  void drawRefline() {
    dashline(chartX, chartY+map(0, min_inc, max_inc, chartHeight, 0), chartX+chartWidth, chartY+map(0, min_inc, max_inc, chartHeight, 0));
    dashline(chartX+0.5*chartWidth, chartY, chartX+0.5*chartWidth, chartY+chartHeight+20);
    dashline(chartX, chartY+incre, chartX+chartWidth, chartY+incre);
    int percent = int(map(chartHeight-incre, 0, chartHeight, min_inc, max_inc));
    mouseCursor();
    moveLine();
    textSize(12);
    textAlign(LEFT, CENTER);
    text(percent+" %", chartX-76, chartY+incre);
    text(0+" %", chartX-76, chartY+map(0, min_inc, max_inc, chartHeight, 0));
    textAlign(CENTER, CENTER);
    text("抛出", chartX+0.5*chartWidth-20, chartY+chartHeight+10);
    text("持有", chartX+0.5*chartWidth+20, chartY+chartHeight+10);
    triangle(chartX+0.5*chartWidth+40, chartY+chartHeight+13, chartX+0.5*chartWidth+35, chartY+chartHeight+9,chartX+0.5*chartWidth+35, chartY+chartHeight+17);
    triangle(chartX+0.5*chartWidth-41, chartY+chartHeight+13, chartX+0.5*chartWidth-36, chartY+chartHeight+9,chartX+0.5*chartWidth-36, chartY+chartHeight+17); 
  }

  void drawRefarrow() {
    noStroke();
    fill(100);
    triangle(chartX-30, chartY+incre, chartX-35, chartY+incre-3, chartX-35, chartY+incre+3);
  }

  void mouseCursor() {
    if (mouseX>=chartX-40 && mouseX<= chartX+0.2*chartWidth && mouseY>=chartY+incre-0.1*chartHeight && mouseY<= chartY+incre+0.1*chartHeight) {
      cursor(CROSS);
    } 
    else {
      cursor(ARROW);
    }
  }

  void moveLine() {
    if (mouseX>=chartX-40 && mouseX<= chartX+0.2*chartWidth && mouseY>=chartY+incre-0.05*chartHeight && mouseY<= chartY+incre+0.05*chartHeight && mousePressed) {
      lock = true;
    }
    if (lock) {
      incre = mouseY-chartY;
      constrain(incre, 0, chartHeight);
    }
  }

  void drawFreqX() {
    fill(180, 240);
    //stroke(0);
    //strokeWeight(2);
    beginShape();
    vertex(chartX, chartY+chartHeight);
    curveVertex(chartX, chartY+chartHeight);
    for (int i=0;i<range_num;i++) {
      curveVertex(chartX+(chartWidth/range_num*0.5)+chartWidth/range_num*i, chartY+chartHeight-freqPosX()[i]);
    }
    curveVertex(chartX+chartWidth, chartY+chartHeight);
    vertex(chartX+chartWidth, chartY+chartHeight);
    endShape();
  }

  void drawFreqZ() {
    fill(180, 240);
    for (int i=0;i<range_num;i++) {
      rect(chartX-freqPosY()[i], float(chartY+chartHeight/range_num+chartHeight/range_num*i), freqPosY()[i], chartHeight/range_num);
    }
  }

  void drawFreqY() {
    fill(180, 240);
    //stroke(0);
    //strokeWeight(2);
    beginShape();
    vertex(chartX, chartY+chartHeight);
    vertex(chartX, chartY);
    curveVertex(chartX, chartY);
    curveVertex(chartX, chartY);
    for (int i=0;i<range_num;i++) {
      curveVertex(chartX-freqPosY()[i], chartY+chartHeight/range_num*0.5+chartHeight/range_num*i);
    }
    endShape(CLOSE);
  }
  
  void setR(){
    for(int i=stock.size()-1;i>=0;i--){
      Particle p = stock.get(i);
      if(p.y>chartY+incre){
        p.d = 0.02*chartHeight;
        p.psize = 0;
      } else {
        p.d = 2*r[i];
        p.psize = 6;
      }
    }
  }

  float[] freqPosY() {
    int range = chartHeight/range_num;
    float[] freq = new float[range_num+100];
    float[] pos = new float[range_num+100];
    for (int i=0;i<y.length;i++) {
      int f = floor((y[i]-chartY)/range);
      freq[f]++;
    }
    for (int i=0;i<freq.length;i++) {
      pos[i] = map(freq[i], 0, max(freq), 0, 30);
    }
    return pos;
  }

  float[] freqPosX() {
    int range = chartWidth/range_num;
    float[] freq = new float[range_num+100];
    float[] pos = new float[range_num+100];
    for (int i=0;i<x.length;i++) {
      int f = floor((x[i]-chartX)/range);
      freq[f]++;
    }
    for (int i=0;i<freq.length;i++) {
      pos[i] = map(freq[i], 0, max(freq), 0, 30);
    }
    return pos;
  }

  void dashline(float startX, float startY, float endX, float endY) {
    float line_length = sqrt(sq(endY-startY) + sq(endX-startX));
    int interval = 10;
    int dash_num = floor(line_length / interval)+1;
    //println(dash_num);
    for (float i=0; i<=dash_num;i++) {
      float x = lerp(startX, endX, i/dash_num);
      float y = lerp(startY, endY, i/dash_num);
      point(x, y);
      //println(i/dash_num);
    }
  }

  void hoverSet() {
    int index = minIndex(distance);
    for (int i=stock.size()-1;i>=0;i--) {
      Particle p = stock.get(i);
      if (i == index && p.distance()<= p.r) {
        p.hover = 1;
        p.alpha=255;
        textSize(18);
        text("股票名称: "+ names[i] + "    类别: "+ category_names[i]+"     增幅: " + incr_per[i]+"%    持有情况: " + holdings[i] + "万元",400,550);
      } 
      else {
        p.hover = 0;
        p.alpha = 50;
      }
    }
  }

  int minIndex(float[] array) {
    int index = 0;
    for (int i=1;i<array.length;i++) {
      if (array[i]<array[index])
        index = i;
    }
    return index;
  }

  void display() {
    for (int i = stock.size()-1; i>=0;i--) {
      Particle p = stock.get(i);
      p.display();
      //println(stock.size());
      //println(x.length);
      distance[i] = p.distance();
      //p.hover();
    }
  }
}

class Particle {
  float x;
  float y;
  float r;
  float d;
  int cat_num;
  String name;
  int hover;
  boolean sel;
  float alpha = 255;
  color c5 = color(26, 188, 156);
  color c8 = color(46, 204, 113);
  color c9 = color(22, 160, 133);
  color c7 = color(39, 174, 96);
  color c1 = color(241, 196, 15);
  color c6 = color(230, 126, 34);
  color c4 = color(243, 156, 18);
  color c10 = color(211, 84, 0);
  color c3 = color(52, 152, 219);
  color c2 = color(41, 128, 185);
    color c11 = color(155, 89, 182);
  color c12 = color(142, 68, 173);
  color c13 = color(231, 76, 60);
  color c14 = color(192, 57, 43);
  color c15 = color(52, 73, 94);
    color c16 = color(44, 62, 80);
  color[] plate = {
    c1, c2, c3, c4, c5, c6, c7, c8, c9, c10,c11,c12,c13,c14,c15,c16
  };
      float psize=5;

  Particle(float x, float y, float r, int category_number, String name, boolean selected) {
    this.x = x;
    this.y= y;
    this.r = r;
    sel = selected;
    d = 2*r;
    cat_num = category_number;
    this.name = name;
  }


  void Selecet() {
    if (sel) {
      alpha = 255;
    } 
    else {
      alpha = 50;
    }
  }

  float interpolate(float current, float target) {
    current += (target-current)*0.03;
    return current;
  }

  void display() {
    //noStroke();
    if (hover==1) {
      alpha = 255;
      //cursor(HAND);
    }
    else if (hover==0) {
      alpha = 200;
      //cursor(ARROW);
    }
    stroke(255,alpha);
    strokeWeight(1);
    //println(cat_num);
    fill(plate[cat_num], alpha);
    ellipse(x, y, d, d);
    //    noFill();
    //    stroke(plate[cat_num],alpha);
    //    dashcircle();
    float offsetX=0.5;
    float offsetY=0.3; 
    if (hover==1) {
      fill(0);
      //psize=16;
      offsetX=1.6;
      offsetY=1.3;
      //cursor(HAND);
    }
    else if (hover==0) {
      fill(180);
      //psize= map(r, 0, 40, 0, 16);
      offsetX=0.5;
      offsetY=0.3;
      //cursor(ARROW);
    }
    textSize(psize);
    textAlign(CENTER, CENTER);

    text(name, x-offsetX*r, y-offsetY*r);
  }

  void dashcircle() {
    float px;
    float py;
    for (int i=0;i<=50;i++) {
      px = x + 1.2*r*sin(i*0.02*2*PI);
      py = y + 1.2*r*cos(i*0.02*2*PI);
      point(px, py);
    }
  }
  
//  void subtitle(){
//    if(hover==1){
//    text("股票名称:“+name+"    增幅:"+int(

  float distance() {
    return dist(x, y, mouseX, mouseY);
  }
}

class Integrator {

  final float DAMPING = 0.5f;
  final float ATTRACTION = 0.2f;

  float value;
  float vel;
  float accel;
  float force;
  float mass = 1;

  float damping = DAMPING;
  float attraction = ATTRACTION;
  boolean targeting;
  float target;


  Integrator() {
  }


  Integrator(float value) {
    this.value = value;
  }


  Integrator(float value, float damping, float attraction) {
    this.value = value;
    this.damping = damping;
    this.attraction = attraction;
  }


  void set(float v) {
    value = v;
  }


  void update() {
    if (targeting) {
      force += attraction * (target - value);
    }

    accel = force / mass;
    vel = (vel + accel) * damping;
    value += vel;

    force = 0;
  }


  void target(float t) {
    targeting = true;
    target = t;
  }


  void noTarget() {
    targeting = false;
  }
}


