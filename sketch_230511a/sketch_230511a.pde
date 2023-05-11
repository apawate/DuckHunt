PImage[] img = new PImage[2];
PImage back;
int duckX = 0, duckY = 0, velo = 7;

void setup() {
  size(400,400);
  back = loadImage("download.png");
  img[0] = loadImage("duck0.png");
  img[1] = loadImage("duck1.png");
  frameRate(velo);
  
}

void draw() {
  image(back, 0 , 0, 400,400);
  image(img[frameCount%2], duckX, duckY, 100, 100);
  duckX = duckX + velo;
  if ( duckX > width+100)  {
      duckX = -250;
  }
}
