import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class multiplate extends PApplet {

int[][] number;
PFont font;
String input = "";
int x=500;
  int y=500;
Integrator[] inter;



public void setup(){
  size(310,300);
  inter = new Integrator[2];
  inter[0] = new Integrator(y);
  inter[1] = new Integrator(x);
  
  number = new int[9][9];
  font = loadFont("AbadiMT-CondensedExtraBold-48.vlw");
}

public void draw(){
  background(255);
  fill(0xffB5FF79,200);
  noStroke();
   //rect(20,10,30,30);
  inter[0].update();
  inter[1].update();
  
  rect(0,10+inter[0].value,310,30);      
  rect(25+inter[1].value,0,30,300);
  drawnumber();
}


public void keyPressed(){
     if(key>='1' && key<='9'){
       println(key);
       input+=PApplet.parseChar(key);
       if(input.length()>2){
         input= Character.toString(PApplet.parseChar(key));
         x=500;
       }
       if(input.length()==1){
         y=30*(PApplet.parseInt(input)-1);
         x=500;
       }else if(input.length()==2){
         x=30*(PApplet.parseInt(input.substring(1))-1);
       }
     }
      inter[0].target(y);
      inter[1].target(x);
      println(inter[0]);
     //println(int(input));
    // println(input);
    // println("the input length is "+input.length());
   }


public void drawnumber(){
  int i = 0;
  while(i<9){
      int j = 0;
  while(j<9){
    number[i][j] = (i+1)*(j+1);
    fill(100);
    text(number[i][j], (i+1)*30,(j+1)*30);
       j++;
    //print(" "+ number[i][j]);
}
    i++;
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


  Integrator() { }


  Integrator(float value) {
    this.value = value;
  }


  Integrator(float value, float damping, float attraction) {
    this.value = value;
    this.damping = damping;
    this.attraction = attraction;
  }


  public void set(float v) {
    value = v;
  }


  public void update() {
    if (targeting) {
      force += attraction * (target - value);      
    }

    accel = force / mass;
    vel = (vel + accel) * damping;
    value += vel;

    force = 0;
  }


  public void target(float t) {
    targeting = true;
    target = t;
  }


  public void noTarget() {
    targeting = false;
  }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "multiplate" });
  }
}
