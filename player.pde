class Player {
  int x;
  int radius = 42;
  PImage img;
  

  Player(PImage img) {
    x = width / 2;
    this.img = img;
  }

  void render() {
    pushStyle();
    imageMode(CENTER);
    image(img, x, height - radius);
    popStyle();
  }

  void move() {
    if (keyPressed) {
      if (key == CODED) {
        if (keyCode == LEFT && x > radius) {
          x -= 8;
        } else if (keyCode == RIGHT && x < width - radius) {
          x += 8;
        }
      }
    }
  }

  boolean collide(Food fud) {
    float distance = dist(x, height - radius, fud.x, fud.y);
    float minDist = fud.radius + radius;
    return distance < minDist;
  }
}