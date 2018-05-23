class Food {
  float x;
  float y;
  int radius;
  int points;
  float fallRate = .2;
  float gravity = .04;
  PImage img;
  boolean isVeg;
  boolean isPower;

  Food(PImage img, int points, boolean isVeg, boolean isPower) {
    this.img = img;
    this.points = points;
    this.isVeg = isVeg;
    this.isPower = isPower;
    x = random(radius, width - radius);
    y = 0;
    radius = 30;
  }

  void render() {
    pushStyle();
    imageMode(CENTER);
    image(img, x, y);
    popStyle();
  }

  void fall() {
    y += fallRate;
    fallRate += gravity;
  }
}