import 'dart:ui';

enum EnemyTier { small, medium, elite, bomber, drill }

extension EnemyTierConfig on EnemyTier {
  int get damage => switch (this) {
    EnemyTier.small => 1,
    EnemyTier.medium => 2,
    EnemyTier.elite => 5,
    EnemyTier.bomber => 10,
    EnemyTier.drill => 30,
  };

  bool get canShoot => this != EnemyTier.drill;

  int get hp => switch (this) {
    EnemyTier.small => 1,
    EnemyTier.medium => 10,
    EnemyTier.elite => 20,
    EnemyTier.bomber => 5,
    EnemyTier.drill => 40,
  };

  double get radius => switch (this) {
    EnemyTier.small => 20,
    EnemyTier.medium => 29,
    EnemyTier.elite => 36,
    EnemyTier.bomber => 32,
    EnemyTier.drill => 26,
  };

  double get speed => switch (this) {
    EnemyTier.small => 160,
    EnemyTier.medium => 115,
    EnemyTier.elite => 88,
    EnemyTier.bomber => 105,
    EnemyTier.drill => 190,
  };

  double get fireInterval => switch (this) {
    EnemyTier.small => 2.3,
    EnemyTier.medium => 1.7,
    EnemyTier.elite => 1.15,
    EnemyTier.bomber => 1.8,
    EnemyTier.drill => 1.9,
  };

  int get score => switch (this) {
    EnemyTier.small => 100,
    EnemyTier.medium => 250,
    EnemyTier.elite => 600,
    EnemyTier.bomber => 400,
    EnemyTier.drill => 350,
  };

  double get spriteScale => switch (this) {
    EnemyTier.small => .9,
    EnemyTier.medium => 1.05,
    EnemyTier.elite => 1.12,
    EnemyTier.bomber => 1.06,
    EnemyTier.drill => 1,
  };
}

abstract final class EnemyConfig {
  static const double secondBossBomberInterval = 6.5;
  static const double thirdBossDrillInterval = 7.5;
  static const int thirdBossDrillDamage = 50;

  static const List<double> firstStageEliteSchedule = [10, 23, 36, 49, 62];
  static const List<double> secondStageEliteSchedule = [
    9,
    19,
    29,
    39,
    49,
    59,
    69,
    79,
    89,
    99,
  ];
  static double enemyPhaseEndFor(int stage) => switch (stage) {
    1 => 75,
    _ => 110,
  };
  static double bossStartTimeFor(int stage) => switch (stage) {
    1 => 78,
    _ => 114,
  };
  static int bossHpFor(int stage) => switch (stage) {
    1 => 260,
    2 => 420,
    _ => 650,
  };
  static int bossDamageFor(int stage) => switch (stage) {
    1 => 5,
    2 => 10,
    _ => 15,
  };
  static double bossHitRadiusFor(int stage) => switch (stage) {
    1 => 58,
    2 => 108,
    _ => 104,
  };
  static List<double> eliteScheduleFor(int stage) => switch (stage) {
    1 => firstStageEliteSchedule,
    _ => secondStageEliteSchedule,
  };

  static const Rect redSpriteSource = Rect.fromLTWH(182, 173, 780, 1012);
  static const Rect rainbowSpriteSource = Rect.fromLTWH(197, 133, 752, 1081);
  static const Rect bossSpriteSource = Rect.fromLTWH(18, 52, 989, 1432);
  static const Rect bomberSpriteSource = Rect.fromLTWH(117, 77, 900, 1171);
  static const Rect battleshipSpriteSource = Rect.fromLTWH(23, 45, 1208, 1181);
  static const Rect drillBossSpriteSource = Rect.fromLTWH(30, 15, 1146, 1280);
  static const Rect drillEnemySpriteSource = Rect.fromLTWH(163, 211, 1181, 543);
  static const Rect drillProjectileSpriteSource = Rect.fromLTWH(
    220,
    40,
    447,
    1668,
  );
}
