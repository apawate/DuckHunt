float x, y, z; // variables to store ball position
float vx, vy, vz; // variables to store ball velocity
float targetx, targety, targetz = 0;
float time = 30;
float gravity = 0.5; // acceleration due to gravity
float radius = 50; // ball radius
float velscaler = 100;
PImage img = new PImage();
PImage barrel = new PImage();

void setup() {
  size(800, 600, P3D);
  x = width/2;
  y = height;
  z = 0;
  vz = 50;
  imageMode(CENTER); 
  img = loadImage("bread.png");
  barrel = loadImage("gun.png");
}

void draw() {
  lights();
  noStroke();
  background(255);
  fill(255, 255, 255);
  translate(x - 200, y - 300, z);
  image(img,x - 200,y - 300,50,50);
  translate(200-x, 300-y, -z);
  translate(width/2, height - 25, 0);
  if (width/2 != mouseX && mouseX > width/2)
  rotate(atan((height - mouseY)/(width/2 - mouseX)) + PI/2);
  if (width/2 != mouseX && mouseX < width/2)
  rotate(atan((height - mouseY)/(width/2 - mouseX)) + 3 * PI/ 2);
  image(barrel, 0, 0, 60, 120);
  if (width/2 != mouseX && mouseX > width/2)
  rotate(-atan((height - mouseY)/(width/2 - mouseX)) - PI/2);
  if (width/2 != mouseX && mouseX < width/2)
  rotate(-atan((height - mouseY)/(width/2 - mouseX)) - 3 * PI/ 2);
  // update ball position and velocity
  x += vx;
  y += vy;
  z += vz;
  println(z);
  vy += gravity;
}

void keyPressed() {
  x = width/2;
  y = height ;
  z = 0;
  translate( x, y, z);
  targetx = mouseX;
  targety = mouseY;
  vy = -(targety - y)*(targety - y)/7500;
  vx = (targetx - x )/time*3.27;
  vz = -velscaler;
}
