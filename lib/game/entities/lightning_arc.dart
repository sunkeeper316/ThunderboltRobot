import 'dart:ui';

class LightningArc {
  LightningArc({
    required this.start,
    required this.end,
    required this.seed,
    required this.life,
    required this.widthScale,
  }) : maxLife = life;

  final Offset start;
  final Offset end;
  final int seed;
  final double maxLife;
  final double widthScale;
  double life;
}
