int[][] number;
PFont font;
String input = "";
int x=500;
  int y=500;
Integrator[] inter;



void setup(){
  size(310,300);
  inter = new Integrator[2];
  inter[0] = new Integrator(y);
  inter[1] = new Integrator(x);
  
  number = new int[9][9];
  font = loadFont("AbadiMT-CondensedExtraBold-48.vlw");
}

void draw(){
  background(255);
  fill(#B5FF79,200);
  noStroke();
   //rect(20,10,30,30);
  inter[0].update();
  inter[1].update();
  
  rect(0,10+inter[0].value,310,30);      
  rect(25+inter[1].value,0,30,300);
  drawnumber();
}


void keyPressed(){
     if(key>='1' && key<='9'){
       
       input+=char(key);
       if(input.length()>2){
         input= Character.toString(char(key));
         x=500;
       }
       if(input.length()==1){
         y=30*(int(input)-1);
         x=500;
       }else if(input.length()==2){
         x=30*(int(input.substring(1))-1);
       }
     }
      inter[0].target(y);
      inter[1].target(x);
      println(char(key));
   }


void drawnumber(){
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
