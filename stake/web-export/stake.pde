Bubble bubblechart;
PFont font;


void setup() {
  size(800, 600);//"processing.core.PGraphicsRetina2D");
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

void mouseClicked() {
  if(bubblechart.getHoverIndex()>=0){
    bubblechart.click[bubblechart.getHoverIndex()]*=-1;
  }
  //println(bubblechart.getHoverIndex());
}

class Bubble {
  ArrayList<Particle> stock;
  ArrayList<Particle> index;
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
  PImage drag;
  int[] click;



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
    index = new ArrayList<Particle>();
    range_num = 50;
    incre = 200;
    drag = loadImage("drag.png");
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

    String[] indexName = {"农林牧渔","采矿业","制造业","水电煤气","建筑业","批发零售","运输仓储","信息技术","商务服务","科研服务","公共环保","卫生","文化传播"};
    for (int i=0; i<indexName.length;i++) {
      index.add(new Particle(chartX+53*i, chartY-75, 10.0f, i+1, indexName[i], true));
    }
    click = new int[indexName.length];
    for(int i=0;i<click.length;i++){
      click[i] = 1;
    }
  }

  void display() {
    for (int i = stock.size()-1; i>=0;i--) {
      Particle p = stock.get(i);
      p.display(click);
      //p.filterBubble(click);
      distance[i] = p.distance();
    }

    for (int i = index.size()-1;i>=0;i--) {
      Particle p = index.get(i);
      p.display2();
      p.filterIndex(click[i]);
    }
  }

  int getHoverIndex(){
    int hoverindex = -1;
    for(int i=index.size()-1; i>=0;i--){
      Particle p = index.get(i);
      if(p.hover==1){
        hoverindex = i;
      }
    }
    return hoverindex;
  }



//======================================//

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
    image(drag, chartX-76, chartY+incre-40, 50, 25);
    text(0+" %", chartX-76, chartY+map(0, min_inc, max_inc, chartHeight, 0));
    textAlign(CENTER, CENTER);
    text("减持", chartX+0.5*chartWidth-20, chartY+chartHeight+10);
    text("增持", chartX+0.5*chartWidth+20, chartY+chartHeight+10);
    triangle(chartX+0.5*chartWidth+40, chartY+chartHeight+13, chartX+0.5*chartWidth+35, chartY+chartHeight+9, chartX+0.5*chartWidth+35, chartY+chartHeight+17);
    triangle(chartX+0.5*chartWidth-41, chartY+chartHeight+13, chartX+0.5*chartWidth-36, chartY+chartHeight+9, chartX+0.5*chartWidth-36, chartY+chartHeight+17); 
    textSize(16);
    text("增幅", chartX-40, chartY);
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
      //constrain(incre, 0, chartHeight);
    }
  }

    void setR() {
    for (int i=stock.size()-1;i>=0;i--) {
      Particle p = stock.get(i);
      //p.Rupdate();
      if (p.y>chartY+incre) {
        //p.r = 0.01*chartHeight;
        p.sel = false;
      } 
      else {
        //p.r = r[i];
        p.sel = true;
      }
    }
  }

  //=======================================//

    void drawFreq() {
    drawFreqX();
    drawFreqY();
  }

  void drawFreqX() {
    fill(200, 250);
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


  void drawFreqY() {
    fill(200, 250);
    //stroke(0);
    //strokeWeight(2);
    beginShape();

    vertex(chartX, chartY);
    //curveVertex(chartX, chartY);
    curveVertex(chartX, chartY);
    for (int i=0;i<range_num;i++) {
      curveVertex(chartX-freqPosY()[i], chartY+chartHeight/range_num*0.5+chartHeight/range_num*i);
    }
    vertex(chartX, chartY+chartHeight);
    endShape();
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
      pos[i] = map(freq[i], 0, max(freq), 0, 40);
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
      pos[i] = map(freq[i], 0, max(freq), 0, 40);
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


  //=======================================//


  void hoverSet() {
    int indexD = minIndex(distance);
    for (int i=stock.size()-1;i>=0;i--) {
      Particle p = stock.get(i);
      if (i == indexD && p.distance()<= p.r) {
        p.hover = 1;
        p.alpha=255;
        textSize(18);
        text("股票名称: "+ names[i] + "    类别: "+ category_names[i]+"     增幅: " + incr_per[i]+"%    持有情况: " + holdings[i] + "万元", 400, 550);
      } 
      else {
        p.hover = 0;
        p.alpha = 50;
      }
    }
    
    for(int i=index.size()-1; i>=0;i--){
      Particle p = index.get(i);
      if(p.distance()<= p.r){
        p.hover = 1;
        p.alpha = 200;
      } else {
        p.hover = 0;
        p.alpha = 255;
      }
      //println(p.r);
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

//=======================================//
  
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
  color c6 = color(26, 188, 156);
  color c9 = color(19,222,232);//color(46, 204, 113);
  color c10 = color(22, 160, 133);
  color c1 = color(39, 174, 96);
  color c4 = color(255, 51, 119);
  color c15 = color(230, 126, 34);
  color c2 = color(243, 156, 18);
  color c7 = color(211, 84, 0);
  color c5 = color(52, 152, 219);
  color c11 = color(38, 209, 249);
  color c12 = color(155, 89, 182);
  color c3 = color(142, 68, 173);
  color c13 = color(231, 76, 60);
  color c14 = color(192, 57, 43);
  color c16 = color(52, 73, 94);
  color c8 = color(41, 211, 139);
  color[] plate = {
    c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16
  };
  float psize=5;
  float initial_r;
  float current_r;
  //Integrator inter;

  Particle(float x, float y, float r, int category_number, String name, boolean selected) {
    this.x = x;
    this.y= y;
    this.r = r;
    initial_r = r;
    current_r = r;
    sel = selected;
    d = 2*r;
    cat_num = category_number;
    this.name = name;
    //inter = new Integrator(2*r);
  }

  
//  void Rupdate(){
//    inter.target(2*r);
//    inter.update();
//  }

  void filterIndex(int click){
    if(click==1){
      r = 1.5*initial_r;
    } else {
      r = initial_r;
    }
  }


  void display(int[] catSel) {
    if (hover==1) {
      alpha = 255;
    }
    else if (hover==0) {
      alpha = 200;
    }
    stroke(255, alpha);
    strokeWeight(1);
    fill(plate[cat_num], alpha);
    ellipse(x,y,2*current_r,2*current_r);
    //ellipse(x, y, inter.value, inter.value);
    //    noFill();
    //    stroke(plate[cat_num],alpha);
    //    dashcircle();
    float offsetX=0.5;
    float offsetY=0.3; 
   if(catSel[cat_num-1] == 1){
      if(sel){
      r = initial_r;
      if(hover==1){
        fill(0);
        psize=10;
        offsetX=0.8;
        offsetY=1;
      } else {
        fill(100);
        psize= 8;
        offsetX=0.3;
        offsetY=0.3;
      }
      textSize(psize);
      textAlign(CENTER, CENTER);
      text(name, x-offsetX*r, y-offsetY*r); 
    } else {
      r = 0.01*400;
    }
    } else {
      r =  0;//initial_r;
    }
    
    //Rupdate();
    update();
  }

  void display2() {
    if (hover==1) {
      alpha = 255;
    }
    else if (hover==0) {
      alpha = 200;
    }
    stroke(255, alpha);
    strokeWeight(1);
    fill(plate[cat_num], alpha);
    //ellipse(x,y,d,d);
    //ellipse(x, y, 2*current_r, 2*current_r);
    ellipse(x,y,2*current_r,2*current_r);
    //println(inter.value);
    //    noFill();
    //    stroke(plate[cat_num],alpha);
    //    dashcircle();
    float offsetX=0;
    float offsetY=2.2;
    fill(200); 
    psize = 10;
    textSize(psize);
    textAlign(CENTER, CENTER);
    text(name, x-offsetX*r, y+offsetY*15);
   update(); 
  }
  
  void update() {
    if(floor(abs(r-current_r))==0){
    } else {
      current_r+= 0.4*(r-current_r);
    }
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


  float distance() {
    return dist(x, y, mouseX, mouseY);
  }
}

class Integrator {

  final float DAMPING = 0.5f;
  final float ATTRACTION = 0.5f;

  float value;
  float vel;
  float accel;
  float force;
  float mass = 1;

  float damping = DAMPING;
  float attraction = ATTRACTION;
  boolean targeting;
  float target;


//  Integrator() {
//  }


  Integrator(float value) {
    this.value = value;
  }

//
//  Integrator(float value, float damping, float attraction) {
//    this.value = value;
//    this.damping = damping;
//    this.attraction = attraction;
//  }


  void set(float v) {
    value = v;
  }
  
  float getvalue(){
    return value;
  }


  void update() {
    if (targeting==true) {
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




