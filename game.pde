import processing.sound.*;

class Game {
  Player p1;
  ArrayList<Food> food;
  int score;
  int lives;
  int time;
  boolean title;
  boolean isGameOver;
  boolean powerUp;
  boolean infoScreen;
  int endPower;
  PImage[] junkFood;
  PImage[] vegetables;

  PImage bg = loadImage("images/kitchen.png");
  PImage titlescreen = loadImage("images/titlescreen.png");
  PImage info = loadImage("images/info.png");
  PImage gameOver = loadImage("images/gameover.png");

  PImage john = loadImage("images/john.png");
  PImage superJohn = loadImage("images/power john.png");
  PImage bubbleTea = loadImage("images/bubble tea.png");

  PImage pizza = loadImage("images/pizza.png");
  PImage hamburger = loadImage("images/hamburger.png");
  PImage donut = loadImage("images/donut.png");

  PImage kale = loadImage("images/kale.png"); 
  PImage broccoli = loadImage("images/broccoli.png");

  PFont font12 = createFont("pcsenior.ttf", 12);
  PFont font10 = createFont("pcsenior.ttf", 10);

  SoundFile bgMusic, powerSound, bleh, yum;

  //default contructor: initializes everything
  Game(PApplet p) {
    junkFood = new PImage[3];
    junkFood[0] = pizza;
    junkFood[1] = hamburger;
    junkFood[2] = donut;

    vegetables = new PImage[2];
    vegetables[0] = kale;
    vegetables[1] = broccoli;

    p1 = new Player(john);
    food = new ArrayList<Food>();
    food.add(new Food(junkFood[floor(random(junkFood.length))], 1, false, false));

    bgMusic = new SoundFile(p, "bgmusic.wav");
    powerSound = new SoundFile(p, "powerup.wav");
    bleh = new SoundFile(p, "bleh.mp3");
    yum = new SoundFile(p, "yummy.mp3");
    bgMusic.loop();

    score = 0;
    lives = 3;
    time = 0;
    title = true;
    isGameOver = false;
    infoScreen = false;
    powerUp = false;
    endPower = 0;
  }

  // runs the game
  void run() {
    if (title) {
      if (infoScreen) { // displays info screen only if on titlescreen
        background(info);
      } else { // display title screen
        background(titlescreen);
      }
    } else if (isGameOver) {// displays game over screen
      gameOver();
    } else { // actualy gameplay
      background(bg);
      time ++;
      if (powerUp) { 
        pushStyle();
        fill(255, 255, 0, 20);
        rect(0, 0, width, height);
        textAlign(CENTER);
        textFont(font12);
        fill(100);
        text("Points 5x", width / 2, height / 2 - 50);
        popStyle();
      }
      pushStyle();
      textFont(font10);
      fill(255);
      text("lives: " + lives, 20, 20);
      text("score: " + score, height - 100, 20);
      popStyle();
      movePlayer();
      moveBall();
      collide();
      addFood();
      endPower();
    }
  }

  // draws game over screen
  void gameOver() {
    pushStyle();
    background(gameOver);
    fill(100);
    textAlign(CENTER);
    textFont(font12);
    text("score: " + score, width / 2, height / 2);
    popStyle();
  }

  // add food to the list if necessary
  void addFood() {
    int r = floor(random(10));
    // every 100ish frames, spawn food, decreasing intervals as game progresses
    if (time % (100 - time / 100) == 0) {
      if (r < 7) { // 70% chance spawning junk food
        food.add(new Food(junkFood[floor(random(junkFood.length))], 1, false, false));
      } else { // 30% chance of spawning vegetable
        food.add(new Food(vegetables[floor(random(vegetables.length))], -5, true, false));
      }
    }
    // every 10 food spawns, 50% chance of bubble tea power up
    if (time % (1000 - time / 100) == 0 && r > 4) {
      food.add(new Food(bubbleTea, 5, false, true));
    }
  }

  // move and render player
  void movePlayer() {
    p1.render();
    p1.move();
  }

  // move and render food
  void moveBall() {
    for (int i = 0; i < food.size(); i ++) {
      Food fud = food.get(i);
      fud.render();
      fud.fall();
      // if food hits the bottom, lose a life (unless a vegetable)
      if (hitBottom(fud)) {
        if (!fud.isVeg) {
          lives --;
        }
        food.remove(i);
        //checks if lives = 0
        isGameOver = isGameOver();
      }
    }
  }

  // checks collisions and acts accordingly
  void collide() {
    for (int i = 0; i < food.size(); i ++) {
      Food fud = food.get(i);
      if (p1.collide(fud)) {
        if (powerUp) {
          score+= 5 * fud.points;
        } else {
          score += fud.points;
        }
        if (fud.isVeg) {
          bleh.play(1.5, .7);
        } else if (fud.isPower) {
          powerSound.play(1.5);
          power(time);
        } else {
          yum.play(2, 2);
        }
        food.remove(i);
      }
    }
  }

  // has the given food hit the bottom?
  boolean hitBottom(Food fud) {
    return fud.y >= height - fud.radius;
  }

  // are game over conditions met?
  boolean isGameOver() {
    return lives == 0;
  }

  // power up effect
  void power(int start) {
    powerUp = true;
    endPower = start + 300;
    p1.img = superJohn;
  }
  // checks if it is time to end the power up effect
  void endPower() {
    if (powerUp && time > endPower) {
      powerUp = false;
      p1.img = john;
    }
  }

  void stopMusic() {
    bgMusic.stop();
  }
}