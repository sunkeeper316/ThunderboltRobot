import 'dart:ui';

enum EnemyTier { small, medium, elite, bomber }

extension EnemyTierConfig on EnemyTier {
  int get hp => switch (this) {
    EnemyTier.small => 1,
    EnemyTier.medium => 3,
    EnemyTier.elite => 5,
    EnemyTier.bomber => 4,
  };

  double get radius => switch (this) {
    EnemyTier.small => 20,
    EnemyTier.medium => 29,
    EnemyTier.elite => 36,
    EnemyTier.bomber => 32,
  };

  double get speed => switch (this) {
    EnemyTier.small => 160,
    EnemyTier.medium => 115,
    EnemyTier.elite => 88,
    EnemyTier.bomber => 105,
  };

  double get fireInterval => switch (this) {
    EnemyTier.small => 2.3,
    EnemyTier.medium => 1.7,
    EnemyTier.elite => 1.15,
    EnemyTier.bomber => 1.8,
  };

  int get score => switch (this) {
    EnemyTier.small => 100,
    EnemyTier.medium => 250,
    EnemyTier.elite => 600,
    EnemyTier.bomber => 400,
  };

  double get spriteScale => switch (this) {
    EnemyTier.small => .9,
    EnemyTier.medium => 1.05,
    EnemyTier.elite => 1.12,
    EnemyTier.bomber => 1.06,
  };
}

abstract final class EnemyConfig {
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

  static double enemyPhaseEndFor(int stage) => stage == 1 ? 75 : 110;
  static double bossStartTimeFor(int stage) => stage == 1 ? 78 : 114;
  static int bossHpFor(int stage) => stage == 1 ? 260 : 420;
  static List<double> eliteScheduleFor(int stage) =>
      stage == 1 ? firstStageEliteSchedule : secondStageEliteSchedule;

  static const Rect redSpriteSource = Rect.fromLTWH(182, 173, 780, 1012);
  static const Rect rainbowSpriteSource = Rect.fromLTWH(197, 133, 752, 1081);
  static const Rect bossSpriteSource = Rect.fromLTWH(18, 52, 989, 1432);
  static const Rect bomberSpriteSource = Rect.fromLTWH(117, 77, 900, 1171);
}
