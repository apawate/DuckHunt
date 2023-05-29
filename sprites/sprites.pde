import java.util.*;
GameWindow window;
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
  
  int feed() {
    foodcount++;
    println("FED! " + name + " " + foodcount);
    if (foodcount > foodlimit) {
      fall();
    }
    return foodcount;
  }
  
  boolean isStarved() {
    if (foodcount < starvelimit) {
      return true;
    }
    return false;
  }
  
  boolean hasFallen() {
    return hasFallen;
  }
  int starve() {
    foodcount--;
    if (foodcount < starvelimit) {
      attack();
    }
    return foodcount;
  }
  void fall() {
    hasFallen = true;
    println("IM FALLING!");
    this.accelerate(0, 10, 0);
  }
  void attack() {
    println("IM MAD!");
  }
  void display() {
    pushMatrix();
    translate(x, y, -3000);
    image(flap[frameCount/5 %2], x, y, length, height);
    x = x + vx;
    y = y + vy;
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
    name = "Pelican";
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
  float gravity = 0.5;

  public Bread(float x, float y, float z, int length, int height) {
    super(x, y, z, length, height);
    img = loadImage("bread.png");
  }
    void display()
    {
      pushMatrix();
      translate(x - 200, y - 300, z);
      image(img,x - 200,y - 300, length, height);
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
      PFont f;

  PImage barrel = new PImage();
  Queue<Bread> ammo;
  ArrayList<Bread> fired;
  float x = width/2;
  float y = height ;
  float z = 0;
  public Gun() {
    barrel = loadImage("gun.png");
    ammo = new LinkedList<Bread>();
    fired = new ArrayList<Bread>();
        f = createFont("Arial", 16, true);
    while (ammo.size() < 9)
    {
      ammo.add(new Bread(x, y, 0, 50, 50));
  }
  ammo.add(new Bread(x, y, 0, 150, 150));
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
    fill(0);
    textFont(f, 20);
    text(ammo.size(), 700, 100);
  }
  
  
  void reload(Bread nu) {
    ammo.add(nu);
  }
  
  void reload() {
    ammo.clear();
    while (ammo.size() < 10)
    {
    ammo.add(new Bread(x, y, 0, 50, 50));
    }
    // Megabread
    //if (ammo.size() == 9)
    //ammo.add(new Bread(x, y, 0, 150, 150));
  }
  
  Bread fire() {
    if (ammo.size() == 0) {
      return null;
    }
    Bread b = ammo.remove();
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

class GameWindow {
  ArrayList<Bird> birds;
  Duck d;
  Pelican p;
  Bread b;
  Duck d1;
  Pelican p1;
  Gun g;
  Clock clock;
  Bird nu;
  int score;
  boolean gameOver;
  PImage back;
  boolean hasSpawned = false;
  char[] code = {' ', ' ', ' '};
  public GameWindow() {
    birds = new ArrayList<Bird>();
    d = new Duck(-2000, 0, -2000, 700, 700);
    d1 = new Duck(-2000, 100, -2000, 700, 700);
    p = new Pelican(-2000, 100, -2000, 700, 700);
    p1 = new Pelican(-2000, 100, -2000, 700, 700);
    g = new Gun();
    d.accelerate(18, 0, 0);
    p.accelerate(8, 0, 0);
    d1.accelerate(25, 0, 0);
    p1.accelerate(6, 0, 0);
    birds.add(d);
    birds.add(p);
    birds.add(d1);
    birds.add(p1);
    clock = new Clock(1);
    back = loadImage("grass.png");
    back.resize(800, 600);
  }
  
  Bird spawn(float seed) {
    int r = int(random(2));
    if (r == 1) {
      nu = new Duck(-2000, random(300), -2000, 700, 700);
      nu.accelerate(20 + random(seed), 0, 0);
    }
    else {
      nu = new Pelican(-2000, random(300), -2000, 700, 700);
      nu.accelerate(6 + (random(seed)/3), 0, 0);
    }
    birds.add(nu);
    return nu;
  }
  
  boolean hasLost() {
    int count = 0;
    int birdcount = 0;
    for (Bird antone : birds) {
      if (antone.isStarved() && !antone.hasFallen()) {
        count++;
      }
      if (!antone.hasFallen()) {
        birdcount++;
      }
    }
    println("Starved birds: " + count + " of " + birdcount);
    if ((count >= birdcount/2.0) && (birdcount != 0)) {
      gameOver = true;
      return true;
    }
    else {
      gameOver = false;
      return false;
    }
  }
  
  void display() {
    background(back);
    if (hasLost()) {
      println("YOU LOST!");
      println("New high score: " + clock.getTime());
    }
    for (int i = 0; i < birds.size(); i++) {
      birds.get(i).display();
    }
    g.turn();
    for (Bread a: g.getFired()) {
      a.collision(birds);
    }
    clock.display();
    if ((clock.getTime() % 100 == 0) && !hasSpawned) {
      spawn((clock.getTime()/100.0));
      spawn((clock.getTime()/100.0));
      spawn((clock.getTime()/100.0));
      hasSpawned = true;
      for (Bird q : birds) {
        q.starve();
      }
    }
    if ((clock.getTime() % 100 != 0)) {
      hasSpawned = false;
    }
  }
  void keyPress(char k) {
    if (k == 'r') {
      g.reload();
    }
    else {
      g.fire();
    }
    code[0] = code[1];
    code[1] = code[2];
    code[2] = k;
    if ((code[0] == 'l') && (code[1] == 'h') && (code[2] == 's')) {
      for (int j = 0; j < 10; j++) {
        g.reload(new Bread(g.x, g.y, 0, 150, 150));
      }
    }
    println(code);
  }
}
    
class Clock
  {
    int time;
    PFont f;
    public Clock (int start)
    {
      f = createFont("Palatino", 20, true);
      time = start;
    }
    
    void display(){
      if (frameCount % 6 == 0 && time > 0)
      {
        time = time + 1;
        fill(0);
        textFont(f, 20);
        
      }
     if (time == 0)
        {
          text("u suck", 700, 150);
        }
     else
          text("" + (double)time/10, 700, 150);        
    }
   
    void add(int cent)
    {
      time += cent;
    }
    
    int getTime() {
      return time;
    }
    
  }

void setup() {
  size(800, 600, P3D);
  window = new GameWindow();

}
void draw() {
  window.display();
}

void keyPressed() {
  window.keyPress(key);
}
