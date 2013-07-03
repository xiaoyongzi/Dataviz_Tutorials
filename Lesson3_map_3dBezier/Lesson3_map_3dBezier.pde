import peasy.*;
PImage map;
PeasyCam cam;
float x;
float y;
float z;
float t=0;
boolean on= false;
int start;
float k;

void setup() {
  size(800,600,OPENGL);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(300);
  cam.setMaximumDistance(1000);
  cam.lookAt(400, 300, 0);
  map = loadImage("mapimage5.jpg");
  smooth(8);
}
void draw() {
  background(0);
  image(map,-400,-300);
  k=1/(2*frameRate);
  translate(400, 300, 0);
  noStroke();
  fill(255,0,0,200);
  box(20,30,50);
  stroke(255,0,0);
  strokeWeight(1);
  noFill();
  //bezier(20,20,0,20,20,30,50,50,30,50,50,0);
  colorMode(HSB);
  if(on){
  float i=0;
  //println(millis());
  while(i<t){
    x = bezierPoint(20,20,50,50,i);
    y = bezierPoint(20,20,50,50,i);
    z = bezierPoint(0,30,30,0,i);
    stroke(0+50*i,100+100*i,255);
    point(x,y,z);
    i+=0.01;
  }
  if(t<1){
  t+=k;
  } else {
    t = 1;
    //println(framerate
    println(millis()-start); 
  }
  }
}

void keyPressed() {
  on = true;
  start = millis();
}


