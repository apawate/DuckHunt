Duck d;
Pelican p;
Bread b;
Duck d1;
Pelican p1;
Gun g;
class GameCharacter {
  float x;
  float y;
  float z;
  float vy;
  float vx;
  float vz;
  int length;
  int height;
  PImage img = new PImage();
  public GameCharacter(float x, float y, float z, int length, int height) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.vy = 0;
    this.vx = 0;
    this.vz = 0;
    this.length = length;
    this.height = height;
  }
  
  public float[] getCoordinates() {
    float[] retval = {x, y, z};
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
  
  void accelerate(float changex, float changey, float changez) {
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
    popMatrix();
  }
}

class Bird extends GameCharacter {
  int foodcount;
  String name;
  boolean hasFallen;
  int foodlimit;
  int starvelimit;
  PImage[] flap = new PImage[2];
  public Bird(float x, float y, float z, int length, int height) {
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
    image(flap[frameCount%2], x, y, length, height);
    x = x + vx;
    if (x > width+100) {
      x = -100;
    }
  }
}

class Duck extends Bird {
  public Duck(float x, float y, float z, int length, int height) {
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
  public Pelican(float x, float y, float z, int length, int height) {
    super (x, y, z, length, height);
    foodlimit = 25;
    name = "Pelican"; // again needs to be changed
    starvelimit = 10;
    foodcount = 15;
    flap[0] = loadImage("pelican0.png");
    flap[1] = loadImage("pelican1.png");
  }
}

class Bread extends GameCharacter {
  public Bread(float x, float y, float z, int length, int height) {
    super(x, y, z, length, height);
    img = loadImage("bread.png");
  }
    void display()
    {
      x += vx;
      y += vy;
      z += vz;
      image(img,x - 200,y - 300,50,50);
      translate(200-x, 300-y, -z);
    }
  }

class Gun {
  PImage barrel = new PImage();
  ArrayList<Bread> ammo;
  float x = width/2;
  float y = height ;
  float z = 0;
  public Gun() {
    barrel = loadImage("gun.png");
    ammo = new ArrayList<Bread>();
  }
  void turn() {
    imageMode(CENTER);
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
    imageMode(CORNER);
    translate(-width/2, 25-height,0);
  }
  
  void reload(Bread nu) {
    ammo.add(nu);
  }
  
  void reload() {
    ammo.add(new Bread(x, y, 0, 150, 150));
  }
  
  Bread fire() {
    if (ammo.size() == 0) {
      return null;
    }
    Bread b = ammo.get(0);
    float targetX = mouseX;
    float targetY = mouseY;
    float vy = -(targetY - y)*(targetY - y)/7500;
    float vx = (targetX - x )/30*3.27;
    float vz = -100;
    b.accelerate(vx, vy, vz);
    return b;
  }
}
    
    
    

void setup() {
  size(800, 600, P3D);
  g = new Gun();
  d = new Duck(0, 0, -1000, 100, 100);
  d1 = new Duck(100, 100, -1000, 100, 100);
  p = new Pelican(0, 100, -1000, 150, 150);
  p1 = new Pelican(125, 100, -1000, 150, 150);
  //d2 = new Duck(138, 642, -1000, 100, 100);
  //p2 = new Pelican(372, 135, -1000, 150, 150);
  //d3 = new Duck(853, 12, -1000, 100, 100);
  //p3 = new Pelican(753, 799, -1000, 150, 150);
  b = new Bread(500, 1000, 0, 150, 150);
  d.accelerate(8, 0, 0);
  p.accelerate(5, 0, 0);
  d1.accelerate(18, 0, 0);
  //d2.accelerate(10, 0, 0);
  //d3.accelerate(7, 0, 0);
  p1.accelerate(3, 0, 0);
  //p2.accelerate(5, 0, 0);
  //p3.accelerate(2, 0, 0);
  g.reload(b);

}
void draw() {
  image(loadImage("grass.png"), 0, 0, 800, 600);
  d.display();
  p.display();
  d1.display();
  p1.display();
  g.turn();
}

void keyPressed() {
  println("1");
  g.reload();
  g.reload();
  g.fire();
}
