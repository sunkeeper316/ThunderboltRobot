class Boss {
  Boss(this.x, this.y, {required this.hp});

  double x;
  double y;
  double fire = 0;
  double summonClock = 0;
  int hp;
  bool active = false;
}
