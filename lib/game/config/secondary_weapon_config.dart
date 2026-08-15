enum SecondaryWeaponType { homingMissile, lightning, straightMissile }

extension SecondaryWeaponTypeInfo on SecondaryWeaponType {
  String get displayName => switch (this) {
    SecondaryWeaponType.homingMissile => '追蹤導彈',
    SecondaryWeaponType.lightning => '自然閃電',
    SecondaryWeaponType.straightMissile => '直線飛彈',
  };

  String get shortName => switch (this) {
    SecondaryWeaponType.homingMissile => '追蹤',
    SecondaryWeaponType.lightning => '閃電',
    SecondaryWeaponType.straightMissile => '直線彈',
  };
}

abstract final class SecondaryWeaponConfig {
  static const double straightMissileStartAngle = 30;
  static const double straightMissileAngleStep = 15;

  static double straightMissileAngleFor(int index) =>
      straightMissileStartAngle + index * straightMissileAngleStep;
}
