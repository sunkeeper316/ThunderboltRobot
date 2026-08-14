/// Player robot and weapon balancing values.
abstract final class PlayerConfig {
  static const double maxHp = 100;
  static const double fireInterval = .16;
  static const double bulletSpeed = -720;
  static const double lightningTravelSpeed = 720;
  static const double missileSpeed = -360;
  static const double missileInterval = .78;

  static const int normalDamage = 1;
  static const int lightningDamage = 2;
  static const int missileDamage = 2;
  static const int maxWeaponLevel = 5;
}
