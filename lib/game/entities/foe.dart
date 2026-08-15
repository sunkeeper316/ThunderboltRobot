import '../config/enemy_config.dart';

enum EnemyMovement { downward, horizontal }

class Foe {
  Foe(
    this.x,
    this.y,
    this.radius,
    this.hp,
    this.speed,
    this.phase,
    this.tier, {
    this.movement = EnemyMovement.downward,
    this.horizontalDirection = 1,
  });

  double x;
  double y;
  double radius;
  double speed;
  double phase;
  double fire = 0;
  int hp;
  final EnemyTier tier;
  final EnemyMovement movement;
  final double horizontalDirection;
  bool dead = false;
}
