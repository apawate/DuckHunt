/**
 * Duck Feeding - a game where the player takes down ducks and pelicans by feeding them bread from a bread gun until they are too full to fly.
 * @author Agastya Pawate
 * @author Antone Jung
 * @author Nicholas Lee
 * @author Caius Leung
 * @version 5/31/2023
 */

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
//import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

/**
 * Encapsulates all the classes and methods of the game and extends PApplet to facilitate Processing implementation.
 * @author Agastya Pawate
 * @author Antone Jung
 * @author Nicholas Lee
 * @author Caius Leung
 */

public class DuckFeed extends PApplet {



//SoundFile soundtrack;
//SoundFile die;

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
  
  public boolean hasCollided(GameCharacter other) {
    if (this.z == other.getCoordinates()[2]) {
      if ((this.x - this.length / 2 < (other.getCoordinates()[0] + other.getBox()[0]/2.0)) && (this.x  + this.length / 2 > (other.getCoordinates()[0] - other.getBox()[0]/2.0))) {
        if ((this.y - this.height / 2 < (other.getCoordinates()[1] + other.getBox()[1]/2.0)) && (this.y + this.height / 2 > (other.getCoordinates()[1] - other.getBox()[1]/2.0))) {
          return true;
        }
        return false;
      }
      return false;
    }
    return false;
  }
  
  public void accelerate(float changex, float changey, float changez) {
    vx = vx + changex;
    vy = vy + changey;
    vz = vz + changez;
  }
  public void display() {
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
  PImage[] flop = new PImage[2];
  public Bird(float x, float y, float z, int length, int height) {
    super(x, y, z, length, height);
  }
  
  public int feed() {
    foodcount++;
    println("FED! " + name + " " + foodcount);
    if ((foodcount > foodlimit) && !hasFallen) {
      fall();
    }
    return foodcount;
  }
  
  public boolean isStarved() {
    if (foodcount < starvelimit) {
      return true;
    }
    return false;
  }
  
  public boolean hasFallen() {
    return hasFallen;
  }
  public int starve() {
    foodcount--;
    if (foodcount < starvelimit) {
      attack();
    }
    return foodcount;
  }
  public void fall() {
    hasFallen = true;
    println("IM FALLING!");
    this.accelerate(0, 10, 0);
    //die.play();
  }
  public void attack() {
    println("IM MAD!");
  }
  public void display() {
    pushMatrix();
    translate(x, y, z);
    if (foodcount < starvelimit) {
      image(flop[frameCount/5 %2], x, y, length, height);
    }
    else {
      image(flap[frameCount/5 %2], x, y, length, height);
    }
    x = x + vx;
    y = y + vy;
    if (x > -1.5f * z) {
      x = 1.5f * z;
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
  float gravity = 0.5f;

  public Bread(float x, float y, float z, int length, int height) {
    super(x, y, z, length, height);
    img = loadImage("bread.png");
  }
    public void display()
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
    
    public void collision(ArrayList<Bird> other) {
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
    f = createFont("Palatino", 16, true);
    while (ammo.size() < 9)
    {
      ammo.add(new Bread(x, y, 0, 50, 50));
  }
  ammo.add(new Bread(x, y, 0, 150, 150));
  }
  public ArrayList<Bread> getFired() {
    return fired;
  }
  public void turn() {
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
    text("Ammo " + ammo.size(), 690, 100);
  }
  
  
  public void reload(Bread nu) {
    ammo.add(nu);
  }
  
  public void reload() {
    ammo.clear();
    while (ammo.size() < 10)
    {
    ammo.add(new Bread(x, y, 0, 50, 50));
    }
    // Megabread
    //if (ammo.size() == 9)
    //ammo.add(new Bread(x, y, 0, 150, 150));
  }
  
  public Bread fire() {
    if (ammo.size() == 0) {
      return null;
    }
    Bread b = ammo.remove();
    float targetX = mouseX;
    float targetY = mouseY;
    float vy = -(targetY - height)*(targetY - height)/7500;
    float vx = (targetX - width/2)/30*3.27f;
    float vz = -100;
    b.accelerate(vx, vy, vz);
    fired.add(b);
    return b;
  }
}

  class Player implements Comparable<Player>{
  String user;
  Integer score;
  
  public Player (String u, Integer i)
  {
    user = u;
    score = i;
  }
  
  public Integer score ()
  {
    return score;
  }
  
  public String user()
  {
    return user;
  }
  
  public int compareTo(Player other)
  {
    return other.score() - score();
  }
}
  
class GameWindow {
  boolean added;
  String typing;
  String currentPlayer;
  ArrayList<Bird> birds;
  HashMap<String, Integer> players;
  PriorityQueue<Player> scoreboard;
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
  boolean gameStart;
  PImage back;
  boolean hasSpawned = false;
  char[] code = {' ', ' ', ' '};
  int count;
  int birdcount;
  PFont f;
  public GameWindow() {
    added = false;
    typing = "";
    currentPlayer = "";
    players = new HashMap<String, Integer>();
    scoreboard = new PriorityQueue<Player>();
    f = createFont("Palatino", 20, true);
    birds = new ArrayList<Bird>();
    gameStart = false;
    back = loadImage("grass.png");
    back.resize(800, 600);
  }
  
  public void   void start() {
    birds.clear();
    birds.add(spawn(0));
    birds.add(spawn(0));
    birds.add(spawn(0));
    birds.add(spawn(0));
    g = new Gun();
    clock = new Clock(1);
  }
  
  public void mousePress() {
    if (!gameStart)
    {
      gameStart = true;
      start();
    }
    else if (gameOver)
    {
      gameStart = false;
      gameOver = false;
    }
  }
  
  public Bird spawn(float seed) {
    int r = int(random(2));
    if (r == 1) {
      nu = new Duck(-2000, random(1000) - 800, -2000, 550, 550);
      nu.accelerate(12 + random(seed), 0, 0);
    }
    else {
      nu = new Pelican(-2000, random(1000) - 800, -2000, 650, 650);
      nu.accelerate(6 + (random(seed)/3), 0, 0);
    }
    birds.add(nu);
    return nu;
  }
  
  public boolean hasLost() {
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
    if ((count >= birdcount/2.0f) && (birdcount > 20)) {
      gameOver = true;
      return true;
    }
    else {
      return false;
    }
    
  }
  
  public void display() {
    background(back);
    if (!gameStart) {
      fill(0);
      textFont(f, 50);
      text("DUCK FEED", 300, 200);
      textFont(f, 20);
      text("Enter Username: " + typing, 300, 300);
      text("Current Player: " + currentPlayer, 300, 320);
      text("*Click to Start*", 300, 500);
      scoreboard.clear();
      added = false;
    } else if (hasLost() && gameOver) {
      textFont(f, 50);
      text("GAME OVER!!", 300, 150);
      if (!added)
      {
        players.putIfAbsent(currentPlayer, score);
        if (score > players.get(currentPlayer))
        players.replace(currentPlayer, score);
        for (HashMap.Entry<String, Integer> entry : players.entrySet())
        {
         scoreboard.add(new Player(entry.getKey(), entry.getValue())); 
        }
         added = true; 
      }
      Iterator<Player> iter = scoreboard.iterator();
      int i = 0;
      while (iter.hasNext() && i <= 4)
      {
         i++;
        Player p = iter.next();
        textFont(f, 20);
        text("Scoreboard (top 5): ", 300, 250);
        text(i + ". " + p.user() + " " + p.score, 300, 250 + 30 * i);
      }
      text("*Click to Restart*", 300, 500);
    } else {
      text("Player: " + currentPlayer, 600, 230);
    for (int i = 0; i < birds.size(); i++) {
      birds.get(i).display();
    }
    g.turn();
    for (Bread a: g.getFired()) {
      a.collision(birds);
    }
    clock.display();
    if ((clock.getTime() % 50 == 0) && !hasSpawned) {
      spawn((clock.getTime()/100.0f));
      spawn((clock.getTime()/100.0f));
      spawn((clock.getTime()/100.0f));
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
  
  public void keyPress(char k) {
    if (!gameStart)
    {
      if (key == '\n')
      {
        currentPlayer = typing;
        typing = "";
      } else if (key == BACKSPACE && typing.length() > 0)
      {
        typing = typing.substring(0, typing.length() - 1);
      }
      else {
        typing = typing + key;
      }
    } else {
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
      textFont(f, 100);
      text("MEGABREAD!", 0, 400);
      for (int j = 0; j < 10; j++) {
        g.reload(new Bread(g.x, g.y, 0, 150, 150));
      }
    }
    println(code);
  }
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
    
    public void display(){
      if (frameCount % 6 == 0 && time > 0)
      {
        time = time + 1;
        fill(0);
        textFont(f, 20);
        
      }
      text("Time: " + (double)time/10, 690, 150);   
    }
   
    public void add(int cent)
    {
      time += cent;
    }
    
    public int getTime() {
      return time;
    }
    
  }

public void setup() {
  
  window = new GameWindow();
  //soundtrack = new SoundFile(this, "biggest.wav");
  //die = new SoundFile(this, "bird.wav");
 // soundtrack.amp(0.25f);
  //soundtrack.loop();

}
public void draw() {
  window.display();
}

public void keyPressed() {
  window.keyPress(key);
}

public void mousePressed(){
  window.mousePress();
}
  public void settings() {  size(800, 600, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "DuckFeed" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
