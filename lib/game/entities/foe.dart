import '../config/enemy_config.dart';

class Foe {
  Foe(this.x, this.y, this.radius, this.hp, this.speed, this.phase, this.tier);

  double x;
  double y;
  double radius;
  double speed;
  double phase;
  double fire = 0;
  int hp;
  final EnemyTier tier;
  bool dead = false;
}
