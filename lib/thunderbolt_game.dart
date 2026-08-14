import 'dart:math';
import 'dart:ui' as ui;
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

typedef FinishCallback = void Function(bool won, int score);

class ThunderboltGame extends FlameGame with DragCallbacks {
  ThunderboltGame({required this.onFinished});
  final FinishCallback onFinished;
  final rng = Random();
  final bullets = <Shot>[];
  final enemies = <Foe>[];
  final particles = <Spark>[];
  final stars = <Star>[];
  Vector2 player = Vector2.zero();
  double hp = 100, elapsed = 0, shotClock = 0, spawnClock = 0;
  int score = 0;
  Boss? boss;
  bool ended = false;
  late final ui.Image playerSprite;
  late final ui.Image enemySprite;
  late final ui.Image bossSprite;

  @override
  Future<void> onLoad() async {
    playerSprite = await images.load('player_robot_pixel.png');
    enemySprite = await images.load('enemy_robot_red.png');
    bossSprite = await images.load('boss_robot_red.png');
    player = Vector2(size.x / 2, size.y * .78);
    for (var i = 0; i < 85; i++) {
      stars.add(
        Star(
          rng.nextDouble() * size.x,
          rng.nextDouble() * size.y,
          30 + rng.nextDouble() * 150,
          .5 + rng.nextDouble() * 1.8,
        ),
      );
    }
  }

  @override
  // Flame names this argument `size`; keeping a distinct name avoids shadowing.
  // ignore: avoid_renaming_method_parameters
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    if (player == Vector2.zero()) {
      player = Vector2(newSize.x / 2, newSize.y * .78);
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (ended) return;
    player += event.localDelta;
    player.x = player.x.clamp(25, size.x - 25);
    player.y = player.y.clamp(size.y * .2, size.y - 45);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (ended || size.x == 0) return;
    elapsed += dt;
    shotClock += dt;
    spawnClock += dt;
    for (final s in stars) {
      s.y += s.speed * dt;
      if (s.y > size.y) {
        s.y = 0;
        s.x = rng.nextDouble() * size.x;
      }
    }
    if (shotClock > .16) {
      shotClock = 0;
      bullets.addAll([
        Shot(player.x - 10, player.y - 30, -720, true),
        Shot(player.x + 10, player.y - 30, -720, true),
      ]);
    }
    if (elapsed < 28 && spawnClock > max(.35, 1.05 - elapsed * .018)) {
      spawnClock = 0;
      _spawnEnemy();
    }
    if (elapsed >= 30 && boss == null) boss = Boss(size.x / 2, -100);
    _updateBullets(dt);
    _updateEnemies(dt);
    _updateBoss(dt);
    _updateParticles(dt);
    if (hp <= 0) _finish(false);
  }

  void _spawnEnemy() {
    final heavy = elapsed > 12 && rng.nextDouble() < .25;
    enemies.add(
      Foe(
        25 + rng.nextDouble() * (size.x - 50),
        -30,
        heavy ? 36 : 22,
        heavy ? 4 : 1,
        heavy ? 85 : 125 + rng.nextDouble() * 60,
        rng.nextDouble() * 6.28,
      ),
    );
  }

  void _updateBullets(double dt) {
    for (final b in bullets) {
      b.y += b.speed * dt;
    }
    for (final b in bullets.where((b) => b.friendly && !b.dead)) {
      for (final e in enemies.where((e) => !e.dead)) {
        if ((Offset(b.x, b.y) - Offset(e.x, e.y)).distance < e.radius + 5) {
          b.dead = true;
          e.hp--;
          if (e.hp <= 0) {
            e.dead = true;
            score += e.radius > 30 ? 300 : 100;
            _boom(e.x, e.y, const Color(0xFFFF8A35));
          }
          break;
        }
      }
      final bo = boss;
      if (!b.dead &&
          bo != null &&
          bo.active &&
          (Offset(b.x, b.y) - Offset(bo.x, bo.y)).distance < 58) {
        b.dead = true;
        bo.hp--;
        if (bo.hp <= 0) {
          score += 5000;
          _boom(bo.x, bo.y, const Color(0xFF62EAFF), count: 80);
          _finish(true);
        }
      }
    }
    for (final b in bullets.where((b) => !b.friendly && !b.dead)) {
      if ((Offset(b.x, b.y) - Offset(player.x, player.y)).distance < 19) {
        b.dead = true;
        hp -= 9;
        _boom(player.x, player.y, const Color(0xFF55DDFF), count: 8);
      }
    }
    bullets.removeWhere((b) => b.dead || b.y < -30 || b.y > size.y + 30);
  }

  void _updateEnemies(double dt) {
    for (final e in enemies) {
      e.y += e.speed * dt;
      e.x += sin(elapsed * 2 + e.phase) * 38 * dt;
      e.fire += dt;
      if (e.fire > (e.radius > 30 ? 1.3 : 2.2)) {
        e.fire = 0;
        bullets.add(Shot(e.x, e.y + e.radius, 260, false));
      }
      if ((Offset(e.x, e.y) - Offset(player.x, player.y)).distance <
          e.radius + 18) {
        e.dead = true;
        hp -= 20;
        _boom(e.x, e.y, const Color(0xFFFF6A40));
      }
    }
    enemies.removeWhere((e) => e.dead || e.y > size.y + 50);
  }

  void _updateBoss(double dt) {
    final b = boss;
    if (b == null || b.hp <= 0) return;
    if (b.y < 115) {
      b.y += 55 * dt;
    } else {
      b.active = true;
      b.x = size.x / 2 + sin(elapsed * .8) * size.x * .28;
      b.fire += dt;
      if (b.fire > .52) {
        b.fire = 0;
        for (var i = -2; i <= 2; i++) {
          bullets.add(
            Shot(b.x + i * 16, b.y + 38, 250 + i.abs() * 22, false, dx: i * 45),
          );
        }
      }
    }
  }

  void _updateParticles(double dt) {
    for (final p in particles) {
      p.life -= dt;
      p.x += p.dx * dt;
      p.y += p.dy * dt;
    }
    particles.removeWhere((p) => p.life <= 0);
  }

  void _boom(double x, double y, Color color, {int count = 18}) {
    for (var i = 0; i < count; i++) {
      final a = rng.nextDouble() * pi * 2, v = 40 + rng.nextDouble() * 190;
      particles.add(
        Spark(x, y, cos(a) * v, sin(a) * v, .3 + rng.nextDouble() * .7, color),
      );
    }
  }

  void _finish(bool won) {
    if (ended) return;
    ended = true;
    Future.delayed(
      const Duration(milliseconds: 650),
      () => onFinished(won, score),
    );
  }

  @override
  // Short canvas name keeps the custom rendering code readable.
  // ignore: avoid_renaming_method_parameters
  void render(Canvas c) {
    super.render(c);
    c.drawRect(
      size.toRect(),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF020611), Color(0xFF071A35), Color(0xFF030816)],
        ).createShader(size.toRect()),
    );
    c.drawCircle(
      Offset(size.x * .15, size.y * .28),
      size.x * .35,
      Paint()
        ..color = const Color(0x111D76FF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80),
    );
    for (final s in stars) {
      c.drawCircle(
        Offset(s.x, s.y),
        s.r,
        Paint()
          ..color = Color.fromARGB(
            (100 + s.r * 60).clamp(0, 255).toInt(),
            170,
            225,
            255,
          ),
      );
    }
    for (final b in bullets) {
      final color = b.friendly
          ? const Color(0xFF67F4FF)
          : const Color(0xFFFF4567);
      c.drawLine(
        Offset(b.x, b.y),
        Offset(b.x - b.dx * .025, b.y + (b.friendly ? 18 : -13)),
        Paint()
          ..color = color
          ..strokeWidth = b.friendly ? 4 : 5
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
    }
    for (final e in enemies) {
      _drawEnemy(c, e);
    }
    if (boss case final b?) _drawBoss(c, b);
    for (final p in particles) {
      c.drawCircle(
        Offset(p.x, p.y),
        2 + p.life * 3,
        Paint()..color = p.color.withValues(alpha: p.life.clamp(0, 1)),
      );
    }
    if (!ended || hp > 0) _drawPlayer(c);
    _drawHud(c);
  }

  void _drawPlayer(Canvas c) {
    c.drawImageRect(
      playerSprite,
      const Rect.fromLTWH(61, 145, 902, 1289),
      Rect.fromCenter(
        center: Offset(player.x, player.y),
        width: 68,
        height: 97,
      ),
      Paint()..filterQuality = FilterQuality.none,
    );
  }

  void _drawEnemy(Canvas c, Foe e) {
    final scale = e.radius > 30 ? 1.18 : 1.0;
    c.drawImageRect(
      enemySprite,
      const Rect.fromLTWH(182, 173, 780, 1012),
      Rect.fromCenter(
        center: Offset(e.x, e.y),
        width: e.radius * 2.15 * scale,
        height: e.radius * 2.8 * scale,
      ),
      Paint()..filterQuality = FilterQuality.none,
    );
  }

  void _drawBoss(Canvas c, Boss b) {
    c.drawImageRect(
      bossSprite,
      const Rect.fromLTWH(18, 52, 989, 1432),
      Rect.fromCenter(center: Offset(b.x, b.y), width: 142, height: 176),
      Paint()..filterQuality = FilterQuality.none,
    );
  }

  void _drawHud(Canvas c) {
    final tp = TextPaint(
      style: const TextStyle(
        color: Color(0xFFE9FBFF),
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
    tp.render(c, 'SCORE  ${score.toString().padLeft(6, '0')}', Vector2(18, 18));
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(18, 45, size.x * .38, 9),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0x553C6170),
    );
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(18, 45, size.x * .38 * (hp / 100).clamp(0, 1), 9),
        const Radius.circular(5),
      ),
      Paint()
        ..color = hp > 30 ? const Color(0xFF29E4FF) : const Color(0xFFFF4865),
    );
    final remain = max(0, 30 - elapsed).ceil();
    if (boss == null) tp.render(c, 'BOSS  $remain', Vector2(size.x - 90, 18));
    if (boss case final b?) {
      tp.render(c, 'VOID REAPER', Vector2(size.x / 2 - 50, 62));
      c.drawRect(
        Rect.fromLTWH(30, 85, size.x - 60, 8),
        Paint()..color = const Color(0x554D1122),
      );
      c.drawRect(
        Rect.fromLTWH(30, 85, (size.x - 60) * (b.hp / 260).clamp(0, 1), 8),
        Paint()..color = const Color(0xFFFF3F70),
      );
    }
    if (elapsed < 4) {
      final hint = TextPaint(
        style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 16),
      );
      hint.render(c, '拖曳機體移動 · 自動射擊', Vector2(size.x / 2 - 92, size.y * .62));
    }
  }
}

class Star {
  Star(this.x, this.y, this.speed, this.r);
  double x, y, speed, r;
}

class Shot {
  Shot(this.x, this.y, this.speed, this.friendly, {this.dx = 0});
  double x, y, speed, dx;
  bool friendly, dead = false;
}

class Foe {
  Foe(this.x, this.y, this.radius, this.hp, this.speed, this.phase);
  double x, y, radius, speed, phase, fire = 0;
  int hp;
  bool dead = false;
}

class Boss {
  Boss(this.x, this.y);
  double x, y, fire = 0;
  int hp = 260;
  bool active = false;
}

class Spark {
  Spark(this.x, this.y, this.dx, this.dy, this.life, this.color);
  double x, y, dx, dy, life;
  Color color;
}
