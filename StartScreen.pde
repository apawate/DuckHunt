import java.util.*;
PImage img;
int buttonX, buttonY;
boolean rectOver = false;
color rectColor, rectHighlight, currentColor;
void setup(){
    img = loadImage("start.png");
    size(800,600);
    textSize(40);
    rectColor = color(0);
  rectHighlight = color(51);
  buttonX = 280;
  buttonY = 267;
  currentColor = color(102);
}

void draw(){
    update(mouseX, mouseY);
    image(img, 0 , 0, 800,600);
    if (rectOver) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(255);
  rect(buttonX, buttonY, 250, 150);
  fill(0,408,612);
  text("Start", 350, 350);
  

}
boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
void update(int x, int y) {
  if ( overRect(buttonX, buttonY, 250, 150) ) {
    rectOver = true;
  } else {
    rectOver = false;
  }
}
void mousePressed() {
  if (rectOver) {
    currentColor = rectColor;
    System.out.println("Button pressed!");
  }
}
