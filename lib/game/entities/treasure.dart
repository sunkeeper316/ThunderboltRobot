import 'package:flutter/material.dart';

enum TreasureType { a, b, c }

class Treasure {
  Treasure(this.x, this.y, this.type) : phase = x * .1;

  double x;
  double y;
  double phase;
  final TreasureType type;
  bool collected = false;

  String get label => switch (type) {
    TreasureType.a => 'A',
    TreasureType.b => 'B',
    TreasureType.c => 'C',
  };

  Color get color => switch (type) {
    TreasureType.a => const Color(0xFF61F5FF),
    TreasureType.b => const Color(0xFFFFD34F),
    TreasureType.c => const Color(0xFFCA71FF),
  };
}
