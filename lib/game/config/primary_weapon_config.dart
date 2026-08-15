enum PrimaryWeaponType { cannon, laser }

extension PrimaryWeaponTypeInfo on PrimaryWeaponType {
  String get displayName => switch (this) {
    PrimaryWeaponType.cannon => '主炮',
    PrimaryWeaponType.laser => '直線雷射',
  };

  String get description => switch (this) {
    PrimaryWeaponType.cannon => '增加彈道數量，近距離可集中命中',
    PrimaryWeaponType.laser => '持續貫穿直線目標，升級提高寬度與傷害',
  };
}

abstract final class PrimaryWeaponConfig {
  static const double laserDamageInterval = .5;
  static const int laserBaseDamage = 2;
  static const int laserDamagePerLevel = 1;
  static const double laserBaseWidth = 8;
  static const double laserWidthPerLevel = 4;

  static int laserDamageFor(int level) =>
      laserBaseDamage + level * laserDamagePerLevel;

  static double laserWidthFor(int level) =>
      laserBaseWidth + level * laserWidthPerLevel;
}
