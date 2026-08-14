enum ShotKind { normal, missile, lightning }

class Shot {
  Shot(
    this.x,
    this.y,
    this.speed,
    this.friendly, {
    this.dx = 0,
    this.kind = ShotKind.normal,
    this.damage = 1,
  }) : phase = x * .13 + y * .07;

  double x;
  double y;
  double speed;
  double dx;
  double phase;
  final ShotKind kind;
  final int damage;
  bool friendly;
  bool dead = false;
}
