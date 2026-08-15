class ExplosionZone {
  ExplosionZone(this.x, this.y) : life = duration;

  double x;
  double y;
  double life;
  bool damagedPlayer = false;

  static const double radius = 58;
  static const int damage = 18;
  static const double duration = 10;
  static const double scrollSpeed = 60;
}
