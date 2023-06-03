import java.util.*;
import processing.sound.*;
import processing.serial.*;
SoundFile soundtrack;
SoundFile die;
Serial myPort;
String input = "";
boolean connected = false;
int kanye;
int deg;
boolean reloaded = false;

GameWindow window;
/** Represents a single game character in DuckFeed with a position, velocity, collision detection and display method.
 * @author Agastya Pawate
 */
class GameCharacter {
  float x;
  float y;
  float z;
  float vy;
  float vx;
  float vz;
  int length;
  int height;
  /** Creates a given game character with initial position and hitbox size.
   * 
   * @param x The x-position of the character.
   * @param y The y-position of the character.
   * @param z The z-position of the character.
   * @param length The length of the character's hitbox (the smallest box containing them on screen).
   * @param height The height of the character's hitbox (the smallest box containing them on screen).
   */
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
  
  /** Gets the current coordinates of the character.
   * @return float[] retval containing the x, y and z coordinates of the character. 
   */
  public float[] getCoordinates() {
    float[] retval = {x, y, z};
    return retval;
  }
  
  /** Gets the hitbox of the character.
   * @return int[] retval containing the length and height of the hitbox.
   */
  
  public int[] getBox() {
    int[] retval = {length, height};
    return retval;
  }
  
  /** Gets the z-coordinate (3D depth) of the character.
   * @return z the z coordinate of the character.
   */
  public float getz()
  {
    return z;
  }
  
  /** Decides if this object has collided with the other object (whether the hitboxes overlap).
   * @param other The other GameCharacter.
   * @return A boolean describing if the two objects have collided or not.
   */
  
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
  
  /** Instantaneously accelerates or decelerates the object.
   * @param changex The change in x-velocity.
   * @param changey The change in y-velocity.
   * @param changez The change in z-velocity.
   */
  void accelerate(float changex, float changey, float changez) {
    vx = vx + changex;
    vy = vy + changey;
    vz = vz + changez;
  }
  /** Updates the character's position according to velocity values. */
  void display() {
    x = x + vx;
    y = y + vy;
    z = z + vz;
    //image(img, x, y, 100, 100);
  }
}

/**
 * Represents a bird in the game. Extends GameCharacter.
 * @author Agastya Pawate
 * @author Caius Leung
 */
class Bird extends GameCharacter {
  int foodcount;
  String name;
  boolean hasFallen;
  int foodlimit;
  int starvelimit;
  PImage[] flap = new PImage[2];
  PImage[] flop = new PImage[2];
  public Bird(float x, float y, float z, int length, int height) {
    super(x, y, z, length, height);
  }
  
  int feed() {
    foodcount++;
    println("FED! " + name + " " + foodcount);
    if ((foodcount > foodlimit) && !hasFallen) {
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
    die.play();
  }
  void attack() {
    println("IM MAD!");
  }
  void display() {
    pushMatrix();
    translate(x, y, -3000);
    if (foodcount < starvelimit) {
      image(flop[frameCount/5 %2], x, y, length, height);
    }
    else {
      image(flap[frameCount/5 %2], x, y, length, height);
    }
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
    flop[0] = loadImage("ducktint0.png");
    flop[1] = loadImage("ducktint1.png");
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
    flop[0] = loadImage("pelicantint0.png");
    flop[1] = loadImage("pelicantint1.png");
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
  int mx;
  int my;
  public Gun() {
    barrel = loadImage("gun.png");
    ammo = new LinkedList<Bread>();
    fired = new ArrayList<Bread>();
    f = createFont("Palatino", 16, true);
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
    if (!connected) {
      mx = mouseX;
      my = mouseY;
    }
    if (connected) {
      mx = (int) map(deg - 90, 180, 0, 0, width);
      my = (int) map(kanye, 255, 0, 0, height);
    }
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
    if (width/2 != mx && mx > width/2)
    rotate(atan((height - my)/(width/2 - mx)) + PI/2);
    if (width/2 != mx && mx < width/2)
    rotate(atan((height - my)/(width/2 - mx)) + 3 * PI/ 2);
    image(barrel, 0, 0, 60, 120);
    popMatrix();
    imageMode(CORNER);
    fill(0);
    textFont(f, 20);
    text("Ammo " + ammo.size(), 690, 100);
  }
  
  
  void reload(Bread nu) {
    ammo.add(nu);
  }
  
  void reload() {
    ammo.clear();
    int a = 10;
    if (connected) {
      a = 100;
    }
    while (ammo.size() < a)
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
    float targetX = mx;
    float targetY = my;
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
  boolean gameOver = false;
  PImage back;
  boolean hasSpawned = false;
  char[] code = {' ', ' ', ' '};
  int count;
  int birdcount;
  PFont f;
  public GameWindow() {
    f = createFont("Palatino", 20, true);
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
    count = 0;
    birdcount = 0;
    for (Bird antone : birds) {
      if (antone.isStarved() && !antone.hasFallen()) {
        count++;
      }
      if (!antone.hasFallen()) {
        birdcount++;
      }
    }
    score = birds.size() - birdcount;
    fill(0);
    textFont(f, 20);
    text("Score " + score, 690, 50);
    text("Starved birds: " + count + " of " + birdcount, 550, 200);
    println("Score: " + score);
    if ((count >= birdcount/2.0) && (birdcount > 20)) {
      gameOver = true;
      return true;
    }
    else {
      return false;
    }
    
  }
  
  void display() {
    background(back);
    if (hasLost() && gameOver) {
      textFont(f, 50);
      text("GAME OVER!!", 30, 400);

    }
    else {
    for (int i = 0; i < birds.size(); i++) {
      birds.get(i).display();
    }
    g.turn();
    for (Bread a: g.getFired()) {
      a.collision(birds);
    }
    clock.display();
    if ((clock.getTime() % 50 == 0) && !hasSpawned) {
      spawn((clock.getTime()/100.0));
      spawn((clock.getTime()/100.0));
      spawn((clock.getTime()/100.0));
      hasSpawned = true;
      for (Bird q : birds) {
        q.starve();
        q.starve();
      }
    }
    if ((clock.getTime() % 50 != 0)) {
      hasSpawned = false;
    }
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
      text("Time: " + (double)time/10, 690, 150);   
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
  //myPort = new Serial(this, "/dev/ttyACM0", 9600); // Change this to the port that your Arduino is connected at
  //myPort.bufferUntil('#');
  connected = true;
  window = new GameWindow();
  soundtrack = new SoundFile(this, "biggest2.wav");
  die = new SoundFile(this, "bird.wav");
  soundtrack.amp(0.25);
  soundtrack.loop();

}

void serialEvent(Serial myPort) {
  input = myPort.readStringUntil('#');
}

void draw() {
  window.display();
  println(connected);
  String degree = "0";
  String power = "0";
  if (input.length() == 7) {
     connected = true;
     degree = input.substring(0, 3);
     power = input.substring(3, 6);
  }
  else {
    connected = false;
  }
  println("Degree " + degree);
  println("Power " + power);
  deg = Integer.parseInt(degree);
  kanye = Integer.parseInt(power);
  if (connected) {
    if ((kanye == 0)) {
      window.keyPress('r');
    }
    else {
      window.keyPress('k');
    }
    
  }
}

void keyPressed() {
      window.keyPress(key);
}
