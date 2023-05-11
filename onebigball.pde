float x, y, z; // variables to store ball position
float vx, vy, vz; // variables to store ball velocity
float targetx, targety, targetz = 0;
float time = 30;
float gravity = 0.05; // acceleration due to gravity
float radius = 50; // ball radius
float velscaler = 30;
float birdz = -1000;

void setup() {
  size(800, 600, P3D);
  x = width/2;
  y = height;
  z = 0;
  vz = 30;
  rectMode(CENTER);
}

void draw() {
  lights();
  noStroke();
  background(0);
  fill(255, 255, 255);
  println(vx);
  println(vy);
  translate(x, y, z);
  println("Z: " + z);
  sphere(radius);
  
  // update ball position and velocity
  x += vx;
  y += vy;
  z += vz;
  vy += gravity;
}

void keyPressed() {
  x = width/2;
  y = height;
  z = 0;
  translate(x, y, z);
  sphere(radius);
  targetx = mouseX;
  targety = mouseY;
  targetz = -1000;
  vy = (targety - y)/time*3;
  vx = (targetx - x)/time*3;
  vz = (targetz - x)/time;
}
