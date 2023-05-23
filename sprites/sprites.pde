Duck d;
Pelican p;
class GameCharacter {
  int x;
  int y;
  int z;
  int vy;
  int vx;
  int vz;
  int length;
  int height;
  PImage image = new PImage();
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
    int[] retval = {x, y, z};
    return retval;
  }
  
  public int[] getBox() {
    int[] retval = {length, height};
    return retval;
  }
  
  boolean hasCollided(GameCharacter other) {
    if (this.z == other.getCoordinates()[2]) {
      if ((((this.x + this.length/2.0) > other.getCoordinates()[0]) && ((this.x - this.length/2.0) < other.getCoordinates()[0]) && ((this.y + this.height/2.0) > other.getCoordinates()[1]) && (this.y - this.height/2.0) < other.getCoordinates()[1])) {
        return true;
      }
    }
    return false;
  }
  
  void accelerate(int changex, int changey, int changez) {
    vx = vx + changex;
    vy = vy + changey;
    vz = vz + changez;
  }
  void display() {
    x = x + vx;
    y = y + vy;
    z = z + vz;
    image(img, x, y, 100, 100);
    pushMatrix();
    translate(x, y, z);
  }
}

class Bird extends GameCharacter {
  int foodcount;
  String name;
  boolean hasFallen;
  int foodlimit;
  int starvelimit;
  PImage[] flap = new PImage[2];
  public Bird(int x, int y, int z, int length, int height) {
    super(x, y, z, length, height);
      frameRate(8);
  }
  
  void hit() {
    hasFallen = true;
  }
  int feed() {
    foodcount++;
    return foodcount;
  }
  int starve() {
    foodcount--;
    return foodcount;
  }
  void fall() {
    if (foodcount > foodlimit) {
      // Animation stuff
    }
  }
  void attack() {
    if (foodcount < starvelimit) {
      // Animation stuff
    }
  }
  void display() {
    image(flap[frameCount%2], x, y, 100, 100);
    x = x + vx;
    if (x > width+100) {
      x = -100;
    }
  }
}

class Duck extends Bird {
  public Duck(int x, int y, int z, int length, int height) {
    super(x, y, z, length, height);
    foodlimit = 15;
    name = "Duck"; // Needs to be changed to some kind of unique identifier
    starvelimit = 5;
    foodcount = 10;
    flap[0] = loadImage("duck0.png");
    flap[1] = loadImage("duck1.png");
  }
}

class Pelican extends Bird {
  public Pelican(int x, int y, int z, int length, int height) {
    super (x, y, z, length, height);
    foodlimit = 25;
    name = "Pelican"; // again needs to be changed
    starvelimit = 10;
    foodcount = 15;
    flap[0] = loadImage("pelican0.png");
    flap[1] = loadImage("pelican1.png");
  }
}

void setup() {
  size(400, 400);
  d = new Duck(0, 0, -1000, 10, 10);
  p = new Pelican(0, 100, -1000, 10, 10);
  d.accelerate(8, 0, 0);
  p.accelerate(5, 0, 0);

}
void draw() {
  image(loadImage("download.png"), 0, 0, 400, 400);
  d.display();
  p.display();
}

class Bread extends GameCharacter {
  
