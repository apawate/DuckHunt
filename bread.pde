float x, y, z; // variables to store ball position
float vx, vy, vz; // variables to store ball velocity
float targetx, targety, targetz = 0;
float time = 30;
float gravity = 0.6; // acceleration due to gravity
float radius = 50; // ball radius
float velscaler = 100;
PImage img = new PImage();

void setup() {
  size(800, 600, P3D);
  x = width/2;
  y = height;
  z = 0;
  vz = 50;
  rectMode(CENTER); 
  img = loadImage("bread.png");
}

void draw() {
  lights();
  noStroke();
  background(0);
  fill(255, 255, 255);
  println(vx);
  println(vy);
  translate(x - 225, y - 250, z);
  println("Z: " + z);
  image(img,x - 225,y - 250,100,100);
  
  // update ball position and velocity
  x += vx;
  y += vy;
  z += vz;
  vy += gravity;
}

void keyPressed() {
  x = width/2;
  y = height ;
  z = 0;
  translate(x, y, z);
  targetx = mouseX;
  targety = mouseY;
  vy = (targety - y)/time*1.25;
  vx = (targetx - x )/time*3.75;
  vz = -velscaler;
}
