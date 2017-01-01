

import oscP5.*;
import netP5.*;
float radius = 200; // Size of the circle
int numPoints = 10; // Number of points on the circe
float angle=TWO_PI/(float)numPoints; // Calculate the angle each point is on
float[][] xyArray;
float x, y;
PImage bg;
OscP5 oscP5;
float angle1 = 0.0;
float segLength = 200;
float c = 0;

//exw balei c*100


void setup() {
  size(1128, 851);
  bg = loadImage("omonoialex.jpg");
  oscP5 = new OscP5(this, 12001);
  stroke(0);
  strokeWeight(30);
    translate(width/2, height/2);
  //height = 500; // Window height
  //width = 500;  // Window width
  background(59);
  // CREATE A LIST OF x & y CO-ORDINATES
  xyArray = new float [numPoints][3]; // Setup the array dimentions
  for(int i=0;i<numPoints;i++) { 
    float x = radius*cos(angle*i)+width/2;
    float y = radius*sin(angle*i)+height/2;
    xyArray[i][0] = x; // Store the x co-ordinate
    xyArray[i][1] = y; // Store the x co-ordinate
    xyArray[i][2] = 0.0;
  }
}

void draw() {
  background(bg);
  angle1 = (c*113/float(width) - 4) * -(2*PI);
  pushMatrix();
  segment(x, y, angle1); 
  popMatrix();
    for(int i=0;i<numPoints;i++){ 
    float x = xyArray[i][0];
    float y = xyArray[i][1];
    for(int ii=i+1;ii<numPoints;ii++){ 
      //if(ii>i){
      //  float xx = xyArray[ii][0];
      //  float yy = xyArray[ii][1];  
        strokeWeight(10);
        //line(x, y, xx, yy);
      //}
    }
    strokeWeight(10);
    ellipse(x, y, 5, 5);
  }
  //translate(width/1.7, height/2.5);
  //rotate(angle1);
  //textSize (32);
  //text("ΟΜΟΝΟΙΑ", 10, 30);
  //fill(0);
 
}

void segment(float x, float y, float a) {
  translate(width/2, height/2);
  rotate(a);
  line(0, 0, segLength, 0);
}

void oscEvent(OscMessage angle) {
  if (angle.addrPattern().equals("/angle")) {
    c = angle.get(0).intValue();
  }
}