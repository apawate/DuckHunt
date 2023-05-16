import java.util.*;
PImage[] imgd = new PImage[2];
PImage[] imgp = new PImage[2];
PImage back;
int velo = 8, x = 0,rand,type;

void setup() {
  size(400,400);
  back = loadImage("download.png");
  imgd[0] = loadImage("duck0.png");
  imgd[1] = loadImage("duck1.png");
  imgp[0] = loadImage("pelican0.png");
  imgp[1] = loadImage("pelican1.png");
  frameRate(velo);
  rand = (int)(Math.random()*300);
  type = (int)(Math.random()*2);
}

void draw() {
  image(back, 0 , 0, 400,400);
  animal(type, rand);
}

void animal(int type, int Y){
  if(type == 0){
  image(imgd[frameCount%2], x, Y, 100, 100);
  x = x + velo+3;
  if ( x > width+100)  {
      x = -100;
  }
  }else{
  image(imgp[frameCount%2], x, Y, 100, 100);
  x = x + velo;
  if ( x > width+100)  {
      x = -100;
  }
  }
}
