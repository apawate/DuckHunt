ArrayList<Bird> birds;
Duck d;
Pelican p;
Bread b;
Duck d1;
Pelican p1;
Gun g;
float gravity = 0.5;
class GameCharacter {
  float x;
  float y;
  float z;
  float vy;
  float vx;
  float vz;
  int length;
  int height;
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
  
  public float getz()
  {
    return z;
  }
  
  boolean hasCollided(GameCharacter other) {
    if (this.z == other.getCoordinates()[2]) {
      if ((this.x < (other.getCoordinates()[0] + other.getBox()[0]/2.0)) && (this.x > (other.getCoordinates()[0] - other.getBox()[0]/2.0))) {
        if ((this.y < (other.getCoordinates()[1] + other.getBox()[1]/2.0)) && (this.y > (other.getCoordinates()[1] - other.getBox()[1]/2.0))) {
          return true;
        }
        return false;
      }
      return false;
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
    //image(img, x, y, 100, 100);
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
  }
  
  void hit() {
    hasFallen = true;
  }
  int feed() {
    foodcount++;
    println("FED! " + foodcount);
    if (foodcount > foodlimit) {
      fall();
    }
    return foodcount;
  }
  int starve() {
    foodcount--;
    if (foodcount < foodlimit) {
      attack();
    }
    return foodcount;
  }
  void fall() {
    println("IM FALLING!");
  }
  void attack() {
    println("IM MAD!");
  }
  void display() {
    pushMatrix();
    translate(x, y, -3000);
    image(flap[frameCount/5 %2], x, y, length, height);
    x = x + vx;
    if (x > -1.5 * z) {
      x = 1.5 * z;
    }
    popMatrix();
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
  PImage img = new PImage();
  public Bread(float x, float y, float z, int length, int height) {
    super(x, y, z, length, height);
    img = loadImage("bread.png");
  }
    void display()
    {
      pushMatrix();
      translate(x - 200, y - 300, z);
      image(img,x - 200,y - 300, 50,50);
      popMatrix();
      x += vx;
      y += vy;
      z += vz;
      vy += gravity;
    }
    
    void collision(ArrayList<Bird> other) {
      for (Bird b : other) {
        if (super.hasCollided(b)) {
          b.feed();
        }
      }
    }
  }

class Gun {
  PImage barrel = new PImage();
  ArrayList<Bread> ammo;
  ArrayList<Bread> fired;
  float x = width/2;
  float y = height ;
  float z = 0;
  public Gun() {
    barrel = loadImage("gun.png");
    ammo = new ArrayList<Bread>();
    fired = new ArrayList<Bread>();
  }
  ArrayList<Bread> getFired() {
    return fired;
  }
  void turn() {
    imageMode(CENTER);
    for (int i = 0; i < fired.size(); i++)
    {
      if (fired.get(i).getz() > -3000)
      {
        fired.get(i).display();
      }
      else fired.remove(i);
    }
    pushMatrix();
    translate(width/2, height - 25, 0);
    if (width/2 != mouseX && mouseX > width/2)
    rotate(atan((height - mouseY)/(width/2 - mouseX)) + PI/2);
    if (width/2 != mouseX && mouseX < width/2)
    rotate(atan((height - mouseY)/(width/2 - mouseX)) + 3 * PI/ 2);
    image(barrel, 0, 0, 60, 120);
    popMatrix();
    imageMode(CORNER);
  }
  
  
  void reload(Bread nu) {
    ammo.add(nu);
  }
  
  void reload() {
    ammo.add(new Bread(x, y, 0, 50, 50));
  }
  
  Bread fire() {
    if (ammo.size() == 0) {
      return null;
    }
    Bread b = ammo.remove(0);
    float targetX = mouseX;
    float targetY = mouseY;
    float vy = -(targetY - height)*(targetY - height)/7500;
    float vx = (targetX - width/2)/30*3.27;
    float vz = -100;
    b.accelerate(vx, vy, vz);
    fired.add(b);
    return b;
  }
}
    
    
    

void setup() {
  size(800, 600, P3D);
  birds = new ArrayList<Bird>();
  g = new Gun();
  d = new Duck(-2000, 0, -2000, 700, 700);
  d1 = new Duck(-2000, 100, -2000, 700, 700);
  p = new Pelican(-2000, 100, -2000, 700, 700);
  p1 = new Pelican(-2000, 100, -2000, 700, 700);
  //d2 = new Duck(138, 642, -1000, 100, 100);
  //p2 = new Pelican(372, 135, -1000, 150, 150);
  //d3 = new Duck(853, 12, -1000, 100, 100);
  //p3 = new Pelican(753, 799, -1000, 150, 150);
  b = new Bread(500, 1000, 0, 150, 150);
  d.accelerate(18, 0, 0);
  p.accelerate(8, 0, 0);
  d1.accelerate(25, 0, 0);
  //d2.accelerate(10, 0, 0);
  //d3.accelerate(7, 0, 0);
  p1.accelerate(6, 0, 0);
  //p2.accelerate(5, 0, 0);
  //p3.accelerate(2, 0, 0);
  birds.add(d);
  birds.add(p);
  birds.add(d1);
  birds.add(p1);
  g.reload(b);

}
void draw() {
  PImage img;
  img = loadImage("grass.png");
  img.resize(800,600);
  background(img);
  d.display();
  p.display();
  d1.display();
  p1.display();
  g.turn();
  for (Bread b : g.getFired()) {
    b.collision(birds);
  }
}

void keyPressed() {
  if (key == 'r') {
    g.reload();
  }
  else {
    g.fire();
  }
  println(g.fired.size());
}
