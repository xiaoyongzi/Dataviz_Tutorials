float chart_areaX = 80;
float chart_areaY = 100;
float chart_width = 400;
float chart_height = chart_width*0.618;
float axisY_interval;
float axisX_interval;
int axisY_interval_num = 5;
int axisX_interval_num = 5;
float [][] data;
int columnsCount;
int rowsCount;
String[] columnsNames;
String[] rowsNames;
float mindata;
float maxdata;
int currentrow = 0;
float [] row;
float maxtop;
//PImage left;
//PImage right;

String unit;
  float top;
  
PFont zh;
//PFont en;

void setup(){
  size(550, 420, "processing.core.PGraphicsRetina2D");
  //left = loadImage("left.png");
  //right = loadImage("right.png");
  zh = createFont("SimHei", 32);//Microsoft YaHei
  textFont(zh);
  axisY_interval = chart_height / axisY_interval_num;
  //rect(chart_areaX,chart_areaY,chart_width,chart_height);
  //dashline(50, 50, 200, 50);
  
  //load the data from file into an String array
  //each row containing one line unseperated text
  String [] rows = loadStrings("data.txt");
  data = new float[rows.length][];
  rowsNames = new String[rows.length-1];
  
  
  
  //an example for trimming the empty cells automatically
  /*int j = 0;
  for(int i=0;i<columnNames_before.length();i++){
    if(columnNames_before[i] == ""){
    } else {
      columnNames[j] = columnNames_before[i];
      j++;
    }
  }*/
  
//Put the values into a 2-dimention array. Retrieve the names of rows into one array
//Ignore the first row [0] and column (subset) that is the row/column of names.
  for(int i=1;i<rows.length;i++){
      data[i-1]= parseFloat(subset(split(rows[i], "\t"),1));
      rowsNames[i-1]= split(rows[i],"\t")[0]; 
  }
  
//record the number of rows/columns  
  columnsCount = data[0].length;
  rowsCount = rows.length-1;
  
  columnsNames = new String[columnsCount];
  //retrieving the names of each columns
  columnsNames = subset(split(rows[0],"\t"),1);
  
  maxdata = max2d(data);
  mindata = min2d(data);
  
  row = new float[columnsCount];
  
  //initialization
  for(int i=0;i<columnsCount;i++){
   row[i] = data[0][i];
  }
  //println(columnsNames);
  unitY(axisY_interval_num,maxdata,mindata);
}

void draw(){
  background(#16a085);
  drawChartArea();
  drawline();
  drawXaxis();
  drawYaxis();
  //fill(38,44,54);
  //noStroke();
  //rect(0,33,width,40);
  pushMatrix();
  translate(chart_areaX,chart_areaY);
  textAlign(LEFT);
  textSize(32);
  fill(#ecf0f1);
  text(rowsNames[currentrow] + "人历年访问量", -41, -35);
  //image(left,350,-50,20,20);
  //image(right,380,-50,20,20);
  popMatrix();
}

/*void arrow(String arrowname, boolean hover){
  if(current == 3){
    image(left,350,-50,20,20);
  } else if(current==0){
    image(right,380,-50,20,20);
  }*/
  

float[] interpolate(int current){
  float[] target = data[current];
   for(int i=0;i<row.length;i++){
      row[i] += (target[i]-row[i])*0.03;
    }
  return row;
}

void drawline(){
  noFill();
  strokeCap(ROUND);
  strokeJoin(BEVEL);
  pushMatrix();
  translate(chart_areaX,chart_areaY);
  beginShape();
  for(int i=0;i<columnsCount;i++){
    float x = chart_width*i/(columnsCount-1);
    float y = chart_height - map(interpolate(currentrow)[i],0,maxtop,0,chart_height);
    vertex(x,y);
    /*
    noStroke();
    fill(34,175,149);
    ellipse(x,y,15,15);
    fill(255);
    ellipse(x,y,12,12);
    */
    noFill();
    stroke(255);
    strokeWeight(5);
  }
  endShape();
  popMatrix();
}

void drawXaxis(){
  textSize(10);
  pushMatrix();
  translate(chart_areaX, chart_areaY);
  for(int i =0;i<columnsCount;i++){
    if(i==0){
      textAlign(LEFT);
    } else if(i== columnsCount-1){
      textAlign(RIGHT);
    } else {
      textAlign(CENTER);
    }
    text(columnsNames[i],chart_width*i/(columnsCount-1),chart_height+20);
  }
  popMatrix();
}

void unitY(int num, float max, float min){
  if(min>100000){
    unit = "M";
    top = ceil(maxdata/100000);
  } else if (maxdata>1000){
    unit = "K";
    top = ceil(maxdata/1000);
  }
  for(int i=0;i<=100;i++){
    int test;
    if(i>top){
      test = i%10;
      //println(test);
      if(test == 0){
        top = i;
        break;
      }
    }
  }
  if(unit=="M"){
    maxtop = top*100000;
  } else if(unit=="K"){
    maxtop = top*1000;
  }
}
  

void drawYaxis(){
  textSize(10);
  pushMatrix();
  translate(chart_areaX, chart_areaY);
  for(float i =0;i<axisY_interval_num+1;i++){
    //println(i/axisY_interval_num);
    text(int(lerp(0,top,i/axisY_interval_num)) + unit,-20,chart_height-i*(chart_height/axisY_interval_num));//nf(lerp(0,top,i/axisY_interval_num),1,1)
  }
  popMatrix();
}


  

void keyPressed(){
  if(currentrow<rowsCount-1){
    if(key == 'x'){
      currentrow++;
      
    }
  }
  
  if(currentrow>0){
    if(key == 'z'){
      currentrow--;
    }
  }
  
  if(key== '0'){
    currentrow=0;
  }  
}

float max2d(float matrix[][]){
  float[] eachrows = new float[rowsCount];
  for(int i=0;i<rowsCount;i++){
    eachrows[i] = max(matrix[i]);
  }
  float max2dm = max(eachrows);
  return max2dm;
}

float min2d(float matrix[][]){
  float[] eachrows = new float[rowsCount];
  for(int i=0;i<rowsCount;i++){
    eachrows[i] = min(matrix[i]);
  }
  float min2dm = min(eachrows);
  return min2dm;
}



void drawChartArea(){
  stroke(#1abc9c);
  strokeWeight(2);
  for(int i=0;i<axisY_interval_num+1;i++){
    dashline(chart_areaX,chart_areaY+i*axisY_interval,chart_areaX+chart_width,chart_areaY+i*axisY_interval);
  }
}

void dashline(float startX, float startY, float endX, float endY){
  float line_length = sqrt(sq(endY-startY) + sq(endX-startX));
  int interval = 10;
  int dash_num = floor(line_length / interval)+1;
   //println(dash_num);
  for(float i=0; i<=dash_num;i++){
    float x = lerp(startX, endX, i/dash_num);
    float y = lerp(startY, endY, i/dash_num);
    point(x, y);
    //println(i/dash_num);
  }
}


  
  
