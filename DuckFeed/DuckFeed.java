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

    /**
     * Returns the coordinates of the character in an array.
     * @return retval An array containing the x, y, and z coordinates of the character.
     */
    public float[] getCoordinates() {
      float[] retval = {x, y, z};
      return retval;
    }

    /**
     * Returns the dimensions of the character's hitbox in an array.
     * @return retval An array containing the length and height of the character's hitbox.
     */
    public int[] getBox() {
      int[] retval = {length, height};
      return retval;
    }

    /**
     * Returns the z-coordinate of the character.
     * @return z The z-coordinate of the character.
     */
    public float getz()
    {
      return z;
    }

    /**
     * Returns whether the character has collided with another character.
     * @param other The other character to check collision with.
     * @return true if the characters have collided, false otherwise.
     */
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

    /**
     * Accelerates the character by a given amount.
     * @param changex The amount to change the x-velocity by.
     * @param changey The amount to change the y-velocity by.
     * @param changez The amount to change the z-velocity by.
     */
    public void accelerate(float changex, float changey, float changez) {
      vx = vx + changex;
      vy = vy + changey;
      vz = vz + changez;
    }

    /**
     * Displays the character on the screen and makes it move.
     */
    public void display() {
      x = x + vx;
      y = y + vy;
      z = z + vz;
      //image(img, x, y, 100, 100);
    }
  }

  /**
   * Represents a Bird in DuckFeed with a name, food count, and methods to feed, starve, fall, and attack.
   */
  class Bird extends GameCharacter {
    int foodcount;
    String name;
    boolean hasFallen;
    int foodlimit;
    int starvelimit;
    PImage[] flap = new PImage[2];
    PImage[] flop = new PImage[2];

    /**
     * Creates a Bird with a given name, position, and hitbox size.
     * @param x The x-position of the bird.
     * @param y The y-position of the bird.
     * @param z The z-position of the bird.
     * @param length The length of the bird's hitbox.
     * @param height The height of the bird's hitbox.
     */
    public Bird(float x, float y, float z, int length, int height) {
      super(x, y, z, length, height);
    }

    /**
     * Feeds the bird, increasing its food count and causing it to fall if it has eaten too much.
     * @return foodcount The amount of food the bird has eaten.
     */
    public int feed() {
      foodcount++;
      println("FED! " + name + " " + foodcount);
      if ((foodcount > foodlimit) && !hasFallen) {
        fall();
      }
      return foodcount;
    }

    /**
     * Returns whether the bird has starved.
     * @return true if the bird has starved, false otherwise.
     */
    public boolean isStarved() {
      if (foodcount < starvelimit) {
        return true;
      }
      return false;
    }

    /**
     * Returns whether the bird has fallen.
     * @return true if the bird has fallen, false otherwise.
     */
    public boolean hasFallen() {
      return hasFallen;
    }

    /**
     * Starves the bird, decreasing its food count and causing it to attack if it has starved too much.
     * @return foodcount The amount of food the bird has eaten.
     */
    public int starve() {
      foodcount--;
      if (foodcount < starvelimit) {
        attack();
      }
      return foodcount;
    }

    /**
     * Causes the bird to fall.
     */
    public void fall() {
      hasFallen = true;
      println("IM FALLING!");
      this.accelerate(0, 10, 0);
      //die.play();
    }

    /**
     * Causes the bird to attack.
     */
    public void attack() {
      println("IM MAD!");
    }

    /**
     * Displays the bird on the screen and makes it move.
     */
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

  /**
   * Represents a Duck in DuckFeed with a name, food count, and methods to feed, starve, fall, and attack.
   */
  class Duck extends Bird {
    /**
     * Creates a Duck with a given name, position, and hitbox size.
     * @param x The x-position of the duck.
     * @param y The y-position of the duck.
     * @param z The z-position of the duck.
     * @param length The length of the duck's hitbox.
     * @param height The height of the duck's hitbox.
     */
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

  /**
   * Represents a Pelican in DuckFeed with a name, food count, and methods to feed, starve, fall, and attack.
   */
  class Pelican extends Bird {
    /**
     * Creates a Pelican with a given name, position, and hitbox size.
     * @param x The x-position of the pelican.
     * @param y The y-position of the pelican.
     * @param z The z-position of the pelican.
     * @param length The length of the pelican's hitbox.
     * @param height The height of the pelican's hitbox.
     */
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

  /**
   * Represents a Bread in DuckFeed with a position, and methods to display and collide.
   */
  class Bread extends GameCharacter {
    PImage img = new PImage();
    float gravity = 0.5f;

    /**
     * Creates a Bread with a given position and hitbox size.
     * @param x The x-position of the bread.
     * @param y The y-position of the bread.
     * @param z The z-position of the bread.
     * @param length The length of the bread's hitbox.
     * @param height The height of the bread's hitbox.
     */
    public Bread(float x, float y, float z, int length, int height) {
      super(x, y, z, length, height);
      img = loadImage("bread.png");
    }

    /**
     * Displays the bread on the screen and makes it move.
     */
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

    /**
     * Returns whether the bread has collided with a bird.
     * @param other The bird to check for collision with.
     */
    public void collision(ArrayList<Bird> other) {
      for (Bird b : other) {
        if (super.hasCollided(b)) {
          b.feed();
        }
      }
    }
  }

  /**
   * Represents a Gun in DuckFeed with a position, and methods to display and fire.
   */
  class Gun {
    PFont f;

    PImage barrel = new PImage();
    Queue<Bread> ammo;
    ArrayList<Bread> fired;
    float x = width/2;
    float y = height ;
    float z = 0;

    /**
     * Creates a Gun with a given position.
     */
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

    /**
     * Fires a bread from the gun.
     * @return fired The bread that was fired.
     */
    public ArrayList<Bread> getFired() {
      return fired;
    }

    /**
     * Makes the gun turn to follow the mouse.
     */
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

    /**
     * Reloads the gun with a given bread.
     * @param nu The bread to reload the gun with.
     */
    public void reload(Bread nu) {
      ammo.add(nu);
    }

    /**
     * Reloads the gun with 10 bread.
     */
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

    /**
     * Fires a bread from the gun.
     * @return b The bread that was fired.
     */
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

  /**
   * Represents a Player in DuckFeed with a username and score.
   */
  class Player implements Comparable<Player>{
    String user;
    Integer score;

    /**
     * Creates a Player with a given username and score.
     * @param u The username of the player.
     * @param i The score of the player.
     */
    public Player (String u, Integer i)
    {
      user = u;
      score = i;
    }

    /**
     * Returns the score of the player.
     * @return score The score of the player.
     */
    public Integer score ()
    {
      return score;
    }

    /**
     * Returns the username of the player.
     * @return user The username of the player.
     */
    public String user()
    {
      return user;
    }

    /**
     * Compares the score of the player to another player.
     * @param other the object to be compared.
     * @return the difference between the scores of the two players.
     */
    public int compareTo(Player other)
    {
      return other.score() - score();
    }
  }

  /**
   * The main class of DuckFeed, which contains the game window and all the birds.
   */
  class GameWindow {
    boolean added;
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

    /**
     * Creates the GameWindow.
     */
    public GameWindow() {
      added = false;
      currentPlayer = "";
      players = new HashMap<String, Integer>();
      scoreboard = new PriorityQueue<Player>();
      f = createFont("Palatino", 20, true);
      birds = new ArrayList<Bird>();
      gameStart = false;
      back = loadImage("grass.png");
      back.resize(800, 600);
    }

    /**
     * Starts the game within the GameWindow.
     */
    public void start() {
      birds.clear();
      birds.add(spawn(0));
      birds.add(spawn(0));
      birds.add(spawn(0));
      birds.add(spawn(0));
      g = new Gun();
      clock = new Clock(1);
    }

    /**
     * Checks if mouse is pressed to start the game.
     */
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

    /**
     * Spawns the birds at random locations within a range.
     * @param seed The range of the random locations.
     * @return nu The bird that was spawned.
     */
    public Bird spawn(float seed) {
      int r = (int)(random(2));
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

    /**
     * Checks if the player has lost the game.
     * @return true if the player has lost, false otherwise.
     */
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

    /**
     * Displays the GameWindow.
     */
    public void display() {
      background(back);
      if (!gameStart) {
        fill(0);
        textFont(f, 50);
        text("DUCK FEED", 300, 200);
        textFont(f, 20);
        text("Type Username: " + currentPlayer, 300, 300);
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
          text(i + ". " + p.user() + " " + p.score(), 300, 250 + 30 * i);
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

    /**
     * Checks if a key is pressed and calls the action related to the key.
     */
    public void keyPress(char k) {
      if (!gameStart)
      {
        if (key == BACKSPACE && currentPlayer.length() > 0)
        {
          currentPlayer = currentPlayer.substring(0, currentPlayer.length() - 1);
        }
        else {
          currentPlayer = currentPlayer + key;
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

  /**
   * A class that represents the Clock in the game.
   */
  class Clock
  {
    int time;
    PFont f;

    /**
     * Creates a new Clock.
     * @param start the starting time of the clock.
     */
    public Clock (int start)
    {
      f = createFont("Palatino", 20, true);
      time = start;
    }

    /**
     * Displays the Clock.
     */
    public void display(){
      if (frameCount % 6 == 0 && time > 0)
      {
        time = time + 1;
        fill(0);
        textFont(f, 20);

      }
      text("Time: " + (double)time/10, 690, 150);
    }

    /**
     * Adds a certain amount of time to the clock.
     * @param cent the amount of time to be added.
     */
    public void add(int cent)
    {
      time += cent;
    }

    /**
     * Returns the time of the clock.
     * @return time the time of the clock.
     */
    public int getTime() {
      return time;
    }

  }

  /**
   * Sets up the graphics of the game.
   */
  public void setup() {

    window = new GameWindow();
    //soundtrack = new SoundFile(this, "biggest.wav");
    //die = new SoundFile(this, "bird.wav");
    // soundtrack.amp(0.25f);
    //soundtrack.loop();

  }

  /**
   * Draws the graphics of the game.
   */
  public void draw() {
    window.display();
  }

  /**
   * Checks if a key is pressed.
   */
  public void keyPressed() {
    window.keyPress(key);
  }

  /**
   * Checks if the mouse is pressed.
   */
  public void mousePressed(){
    window.mousePress();
  }

  /**
   * Makes the window for the Game.
   */
  public void settings() {  size(800, 600, P3D); }

  /**
   * Runs the Game.
   * @param passedArgs the arguments passed.
   */
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "DuckFeed" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
