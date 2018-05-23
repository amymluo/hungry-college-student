/*
Amy Luo
 Programming Basics
 myd3monbutler@gmail.com
 Assignment 7
 Hungry College Student
 */
Game game;

void setup() {
  size(500, 500);
  game = new Game(this);
}

void draw() {
  game.run();
}

void keyPressed() {
  if (key == ENTER || key == RETURN) {
    game.title = false;
  }
  if (key == 'R' || key == 'r') {
    game.stopMusic();
    game = new Game(this);
  }
  if (key == 'I' || key == 'i') {
    game.infoScreen = !game.infoScreen;
  }
}