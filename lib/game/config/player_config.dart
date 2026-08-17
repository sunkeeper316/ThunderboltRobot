/// Player robot and weapon balancing values.
abstract final class PlayerConfig {
  static const double maxHp = 100;
  static const double fireInterval = .16;
  static const double bulletSpeed = -720;
  static const double lightningInterval = .5;
  static const double lightningDuration = .14;
  static const double lightningLengthScreenRatio = .5;
  static const double lightningWidthPerLevel = .24;
  static const double lightningHitWidth = 10;
  static const double missileSpeed = -360;
  static const double missileInterval = .78;

  static const int normalDamage = 1;
  static const int lightningDamage = 2;
  static const int missileDamage = 4;
  static const int maxWeaponLevel = 5;
  static const int maxWeaponsTreasureHeal = 10;
}
