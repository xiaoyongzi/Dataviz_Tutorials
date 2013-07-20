Bubble bubblechart;
PFont font;


void setup() {
  size(800, 600, "processing.core.PGraphicsRetina2D");
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
  bubblechart.display();
}


class Bubble {
  ArrayList<Particle> stock;
  int num_stock;
  String[] names;
  int[] values;
  int[] incr_per;
  int[] holdings;
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

  Bubble(int chartX, int chartY, int chartWidth, int chartHeight) {
    String[] rows = loadStrings("stock2.csv");
    x = new float[rows.length];
    y = new float[rows.length];
    r = new float[rows.length];
    incr_per = new int[rows.length];
    names = new String[rows.length];
    category_num = new int[rows.length];
    holdings = new int[rows.length];
    values = new int[rows.length];
    for (int i=0;i<rows.length;i++) {
      String[] pieces = split(rows[i], ',');
      names[i] = pieces[0];
      values[i] = parseInt(pieces[3]);
      incr_per[i] = int(pieces[1]);
      holdings[i] = parseInt(pieces[2]);
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
  }

  void mapping() {
    for (int i =0;i<x.length;i++) {
      y[i] = chartY+chartHeight-map(incr_per[i], min_inc, max_inc, 0, chartHeight);
      x[i] = chartX+map(holdings[i], min_hold, max_hold, 0, chartWidth);
      r[i] = map(values[i], 0, max(values), 0.01*chartHeight, 0.05*chartHeight);
      stock.add(new Particle(x[i], y[i], r[i], category_num[i], names[i]));
    }
  }

  void display() {
    for (int i = stock.size()-1; i>=0;i--) {
      Particle p = stock.get(i);
      p.display();
      p.hoverSet();
    }
  }

  //=======================================//


  void dashline(float startX, float startY, float endX, float endY) {
    float line_length = sqrt(sq(endY-startY) + sq(endX-startX));
    int interval = 10;
    int dash_num = floor(line_length / interval)+1;
    //println(dash_num);
    for (float i=0; i<=dash_num;i++) {
      float x = lerp(startX, endX, i/dash_num);
      float y = lerp(startY, endY, i/dash_num);
      point(x, y);
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
  float alpha = 255;

  color c1 = color(39, 174, 96);
  color c4 = color(255, 51, 119);
  color c2 = color(243, 156, 18);
  color c3 = color(142, 68, 173);
  color[] plate = {
    c1, c2, c3, c4
  };
  float psize=5;
  float initial_r;
  float current_r;

  Particle(float x, float y, float r, int category_number, String name) {
    this.x = x;
    this.y= y;
    this.r = r;
    initial_r = r;
    current_r = r;
    d = 2*r;
    cat_num = category_number;
    this.name = name;
  }


  void display() {
    if (hover==1) {
      alpha = 255;
      r = 2*initial_r;
    }
    else if (hover==0) {
      alpha = 200;
      r = initial_r;
    }
    stroke(255, alpha);
    strokeWeight(1);
    fill(plate[cat_num], alpha);
    ellipse(x,y,2*current_r,2*current_r);
    float offsetX=0.5;
    float offsetY=0.3; 
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
    update();
  }
  
  void hoverSet(){
    if(dist(x,y,mouseX,mouseY)<=r){
      hover=1;
    } else {
      hover=0;
    }
  }
  
  void update() {
    if(floor(abs(r-current_r))==0){
    } else {
      current_r+= 0.4*(r-current_r);
    }
  }


}





