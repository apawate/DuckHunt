public class GameCharacter {
  int x;
  int y;
  int z;
  int vy;
  int vx;
  int vz;
  int length;
  int height;
  public GameCharacter(int x, int y, int z, int length, int height) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.vy = 0;
    this.vx = 0;
    this.vz = 0;
    this.length = length;
    this.height = height;
  }
  
  public int[] getCoordinates() {
    return {x, y, z};
  }
  
  public int[] getBox() {
    return {length, height};
  }
  
  boolean hasCollided(GameCharacter other) {
    if (this.z == other.getCoordinates[2]) {
      if (((this.x + this.length/2.0) > other.getCoordinates[0]) && (this.x - this.length/2.0) < other.getCoordinates[0])) && ((this.y + this.height/2.0) > other.getCoordinates[1]) && (this.y - this.height/2.0) < other.getCoordinates[1]))) {
        return true;
      }
    }
    return false;
  }
  
  void accelerate(int changex, int changey, int changez) {
    vx = vx + changex;
    vy = vy + changey;
    vz = vz + changez;
  void display() {
    x = x + vx;
    y = y + vy;
    z = z + vz;
    pushMatrix();
    translate(x, y, z);
    
}

public class Bird extends GameCharacter {
  int foodcount;
  String name;
  boolean hasFallen;
  int foodlimit;
  int starvelimit;
  PImage[] flap = new PImage[2];
  public Bird(int x, int y, int z, int length, int height) {
    super(x, y, z, length, height);
  }
  
  int hit() {
    hasFallen = true;
  }
  int feed() {
    foodcount++;
  }
  void fall() {
    // Animation stuff
  }
  void attack() {
    // More animation stuff
  }
  void display() {
    image(flap[frameCount%2], x, y, 100, 100);
    x = x + vx;
    if (x > width+100) {
      x = -100;
    }
}

class Duck extends Bird {
  public Duck(int x, int y, int z, int length, int height) {
    super(x, y, z, length, height);
  }
    
