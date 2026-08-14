class ExplosionZone {
  ExplosionZone(this.x, this.y);

  double x;
  double y;
  double life = 3;
  bool damagedPlayer = false;

  static const double radius = 58;
  static const int damage = 18;
}
