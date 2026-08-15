import 'dart:math';
import 'dart:ui' as ui;
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'config/enemy_config.dart';
import 'config/player_config.dart';
import 'entities/boss.dart';
import 'entities/explosion_zone.dart';
import 'entities/foe.dart';
import 'entities/shot.dart';
import 'entities/spark.dart';
import 'entities/star.dart';
import 'entities/treasure.dart';

typedef FinishCallback = void Function(bool won, int score);

class ThunderboltGame extends FlameGame with DragCallbacks {
  ThunderboltGame({required this.onFinished});
  final FinishCallback onFinished;
  final rng = Random();
  final bullets = <Shot>[];
  final enemies = <Foe>[];
  final particles = <Spark>[];
  final stars = <Star>[];
  final treasures = <Treasure>[];
  final explosionZones = <ExplosionZone>[];
  Vector2 player = Vector2.zero();
  double hp = PlayerConfig.maxHp,
      elapsed = 0,
      stageElapsed = 0,
      shotClock = 0,
      spawnClock = 0,
      missileClock = 0;
  int score = 0;
  int stage = 1;
  int powerLevel = 0;
  int missileLevel = 0;
  int lightningLevel = 0;
  int scheduledElites = 0;
  Boss? boss;
  bool ended = false;
  late final ui.Image playerSprite;
  late final ui.Image enemySprite;
  late final ui.Image bossSprite;
  late final ui.Image rainbowEnemySprite;
  late final ui.Image bomberEnemySprite;
  late final ui.Image battleshipBossSprite;
  late final ui.Image drillBossSprite;

  @override
  Future<void> onLoad() async {
    playerSprite = await images.load('player_robot_pixel.png');
    enemySprite = await images.load('enemy_robot_red.png');
    bossSprite = await images.load('boss_robot_red.png');
    rainbowEnemySprite = await images.load('enemy_robot_rainbow.png');
    bomberEnemySprite = await images.load('enemy_robot_bomber.png');
    battleshipBossSprite = await images.load('boss_battleship_red.png');
    drillBossSprite = await images.load('boss_drill_robot_red_blue.png');
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
    stageElapsed += dt;
    shotClock += dt;
    missileClock += dt;
    spawnClock += dt;
    for (final s in stars) {
      s.y += s.speed * dt;
      if (s.y > size.y) {
        s.y = 0;
        s.x = rng.nextDouble() * size.x;
      }
    }
    if (shotClock > PlayerConfig.fireInterval) {
      shotClock = 0;
      _firePlayerWeapons();
    }
    if (missileLevel > 0 && missileClock > PlayerConfig.missileInterval) {
      missileClock = 0;
      for (var i = 0; i < missileLevel; i++) {
        final offset = (i - (missileLevel - 1) / 2) * 13;
        bullets.add(
          Shot(
            player.x + offset,
            player.y - 20 + i.abs() * 2,
            PlayerConfig.missileSpeed,
            true,
            kind: ShotKind.missile,
            damage: PlayerConfig.missileDamage,
          ),
        );
      }
    }
    if (stageElapsed < EnemyConfig.enemyPhaseEndFor(stage) &&
        spawnClock > max(.38, 1.05 - stageElapsed * .008)) {
      spawnClock = 0;
      _spawnEnemy();
    }
    if (stageElapsed >= EnemyConfig.bossStartTimeFor(stage) && boss == null) {
      boss = Boss(size.x / 2, -100, hp: EnemyConfig.bossHpFor(stage));
    }
    _updateBullets(dt);
    _updateEnemies(dt);
    _updateTreasures(dt);
    _updateExplosionZones(dt);
    _updateBoss(dt);
    _updateParticles(dt);
    if (hp <= 0) _finish(false);
  }

  void _spawnEnemy() {
    final roll = rng.nextDouble();
    final eliteSchedule = EnemyConfig.eliteScheduleFor(stage);
    final eliteDue =
        scheduledElites < eliteSchedule.length &&
        stageElapsed >= eliteSchedule[scheduledElites];
    final tier = eliteDue
        ? EnemyTier.elite
        : stage == 2 && roll < .2
        ? EnemyTier.bomber
        : stageElapsed > 6 && roll < .52
        ? EnemyTier.medium
        : EnemyTier.small;
    if (eliteDue) scheduledElites++;
    enemies.add(
      Foe(
        25 + rng.nextDouble() * (size.x - 50),
        -30,
        tier.radius,
        tier.hp,
        tier.speed,
        rng.nextDouble() * 6.28,
        tier,
      ),
    );
  }

  void _firePlayerWeapons() {
    final bulletCount = 2 + powerLevel;
    for (var i = 0; i < bulletCount; i++) {
      final offset = (i - (bulletCount - 1) / 2) * 14;
      bullets.add(
        Shot(
          player.x + offset,
          player.y - 30,
          PlayerConfig.bulletSpeed,
          true,
          damage: PlayerConfig.normalDamage,
        ),
      );
    }
    if (lightningLevel > 0) {
      final halfFan = (lightningLevel - 1) * 6.0;
      for (var i = 0; i < lightningLevel; i++) {
        final angleDegrees = lightningLevel == 1
            ? 45.0
            : 45 - halfFan + (halfFan * 2 * i / (lightningLevel - 1));
        final angle = angleDegrees * pi / 180;
        final horizontalSpeed = sin(angle) * PlayerConfig.lightningTravelSpeed;
        final verticalSpeed = -cos(angle) * PlayerConfig.lightningTravelSpeed;
        bullets.addAll([
          Shot(
            player.x - 18,
            player.y - 24,
            verticalSpeed,
            true,
            dx: -horizontalSpeed,
            kind: ShotKind.lightning,
            damage: PlayerConfig.lightningDamage,
          ),
          Shot(
            player.x + 18,
            player.y - 24,
            verticalSpeed,
            true,
            dx: horizontalSpeed,
            kind: ShotKind.lightning,
            damage: PlayerConfig.lightningDamage,
          ),
        ]);
      }
    }
  }

  void _updateBullets(double dt) {
    for (final b in bullets) {
      if (b.kind == ShotKind.missile && b.friendly) _guideMissile(b, dt);
      b.x += b.dx * dt;
      b.y += b.speed * dt;
    }
    for (final b in bullets.where((b) => b.friendly && !b.dead)) {
      for (final e in enemies.where((e) => !e.dead)) {
        if ((Offset(b.x, b.y) - Offset(e.x, e.y)).distance < e.radius + 5) {
          b.dead = true;
          e.hp -= b.damage;
          if (e.hp <= 0) {
            e.dead = true;
            score += e.tier.score;
            _boom(e.x, e.y, const Color(0xFFFF8A35));
            if (e.tier == EnemyTier.elite) {
              treasures.add(
                Treasure(
                  e.x,
                  e.y,
                  TreasureType.values[rng.nextInt(TreasureType.values.length)],
                ),
              );
            }
            if (e.tier == EnemyTier.bomber) {
              explosionZones.add(ExplosionZone(e.x, e.y));
            }
          }
          break;
        }
      }
      final bo = boss;
      if (!b.dead &&
          bo != null &&
          bo.active &&
          (Offset(b.x, b.y) - Offset(bo.x, bo.y)).distance <
              EnemyConfig.bossHitRadiusFor(stage)) {
        b.dead = true;
        bo.hp -= b.damage;
        if (bo.hp <= 0) {
          score += 5000;
          _boom(bo.x, bo.y, const Color(0xFF62EAFF), count: 80);
          if (stage < 3) {
            _startNextStage();
          } else {
            _finish(true);
          }
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
    bullets.removeWhere(
      (b) =>
          b.dead ||
          b.y < -40 ||
          b.y > size.y + 40 ||
          b.x < -50 ||
          b.x > size.x + 50,
    );
  }

  void _guideMissile(Shot b, double dt) {
    Offset? target;
    var distance = double.infinity;
    for (final e in enemies.where((e) => !e.dead)) {
      final d = (Offset(b.x, b.y) - Offset(e.x, e.y)).distance;
      if (d < distance) {
        distance = d;
        target = Offset(e.x, e.y);
      }
    }
    final bo = boss;
    if (bo != null && bo.active && bo.hp > 0) target ??= Offset(bo.x, bo.y);
    if (target != null) {
      final desired = (target.dx - b.x).clamp(-260.0, 260.0);
      b.dx += (desired - b.dx) * min(1, dt * 5);
    }
  }

  void _updateTreasures(double dt) {
    for (final item in treasures) {
      item.y += 92 * dt;
      item.phase += dt * 4;
      item.x += sin(item.phase) * 18 * dt;
      if ((Offset(item.x, item.y) - Offset(player.x, player.y)).distance < 30) {
        item.collected = true;
        score += 500;
        switch (item.type) {
          case TreasureType.a:
            powerLevel = min(PlayerConfig.maxWeaponLevel, powerLevel + 1);
          case TreasureType.b:
            missileLevel = min(PlayerConfig.maxWeaponLevel, missileLevel + 1);
          case TreasureType.c:
            lightningLevel = min(
              PlayerConfig.maxWeaponLevel,
              lightningLevel + 1,
            );
        }
        _boom(item.x, item.y, item.color, count: 14);
      }
    }
    treasures.removeWhere((item) => item.collected || item.y > size.y + 30);
  }

  void _updateExplosionZones(double dt) {
    for (final zone in explosionZones) {
      zone.life -= dt;
      if (!zone.damagedPlayer &&
          (Offset(zone.x, zone.y) - Offset(player.x, player.y)).distance <
              ExplosionZone.radius + 18) {
        zone.damagedPlayer = true;
        hp -= ExplosionZone.damage;
        _boom(player.x, player.y, const Color(0xFFFF6A32), count: 12);
      }
    }
    explosionZones.removeWhere((zone) => zone.life <= 0);
  }

  void _updateEnemies(double dt) {
    for (final e in enemies) {
      if (e.dead) continue;
      // Scheduled elite robots hold formation until defeated, guaranteeing
      // all five treasure opportunities remain available during the stage.
      if (e.tier != EnemyTier.elite || e.y < size.y * .42) {
        e.y += e.speed * dt;
      }
      e.x += sin(elapsed * 2 + e.phase) * 38 * dt;
      e.fire += dt;
      if (e.fire > e.tier.fireInterval) {
        e.fire = 0;
        bullets.add(Shot(e.x, e.y + e.radius, 260, false));
      }
      if ((Offset(e.x, e.y) - Offset(player.x, player.y)).distance <
          e.radius + 18) {
        e.dead = true;
        hp -= 20;
        _boom(e.x, e.y, const Color(0xFFFF6A40));
        if (e.tier == EnemyTier.bomber) {
          explosionZones.add(ExplosionZone(e.x, e.y));
        }
      }
    }
    enemies.removeWhere((e) => e.dead || e.y > size.y + 50);
  }

  void _updateBoss(double dt) {
    final b = boss;
    if (b == null || b.hp <= 0) return;
    final targetY = switch (stage) {
      1 => 115.0,
      2 => 125.0,
      _ => 135.0,
    };
    if (b.y < targetY) {
      b.y += 55 * dt;
    } else {
      b.active = true;
      b.x = size.x / 2 + sin(elapsed * .8) * size.x * .28;
      b.fire += dt;
      if (b.fire > .52) {
        b.fire = 0;
        for (var i = -2; i <= 2; i++) {
          bullets.add(
            Shot(
              b.x + i * (stage == 1 ? 16 : 28),
              b.y + (stage == 1 ? 38 : 88),
              250 + i.abs() * 22,
              false,
              dx: i * 45,
            ),
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

  void _startNextStage() {
    stage++;
    stageElapsed = 0;
    scheduledElites = 0;
    spawnClock = 0;
    boss = null;
    for (final enemy in enemies) {
      enemy.dead = true;
    }
    for (final treasure in treasures) {
      treasure.collected = true;
    }
    for (final shot in bullets.where((shot) => !shot.friendly)) {
      shot.dead = true;
    }
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
      final color = switch (b.kind) {
        ShotKind.missile => const Color(0xFFFFD34F),
        ShotKind.lightning => const Color(0xFFB96CFF),
        ShotKind.normal =>
          b.friendly ? const Color(0xFF67F4FF) : const Color(0xFFFF4567),
      };
      final start = Offset(b.x, b.y);
      final end = Offset(b.x - b.dx * .025, b.y + (b.friendly ? 20 : -16));
      final coreColor = switch (b.kind) {
        ShotKind.missile => const Color(0xFFFFFFFF),
        ShotKind.lightning => const Color(0xFFFFFFFF),
        ShotKind.normal =>
          b.friendly ? const Color(0xFFFFFFFF) : const Color(0xFFFFF0B8),
      };
      if (b.kind == ShotKind.lightning) {
        _drawLightning(c, b);
      } else {
        // A wide glow makes projectiles readable against dark space, while
        // the second pass provides a fully opaque core.
        c.drawLine(
          start,
          end,
          Paint()
            ..color = color.withValues(alpha: .72)
            ..strokeWidth = 11
            ..strokeCap = StrokeCap.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
        );
        c.drawLine(
          start,
          end,
          Paint()
            ..color = coreColor
            ..strokeWidth = 5
            ..strokeCap = StrokeCap.round,
        );
      }
    }
    for (final e in enemies) {
      _drawEnemy(c, e);
    }
    for (final zone in explosionZones) {
      _drawExplosionZone(c, zone);
    }
    for (final item in treasures) {
      _drawTreasure(c, item);
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

  void _drawLightning(Canvas c, Shot shot) {
    final pulse = .78 + sin(elapsed * 85 + shot.phase) * .22;
    final trailVector = Offset(-shot.dx * .12, -shot.speed * .12);
    final trailLength = trailVector.distance;
    final along = trailVector / trailLength;
    final perpendicular = Offset(-along.dy, along.dx);
    final tail = Offset(shot.x, shot.y) + trailVector;
    final points = <Offset>[Offset(shot.x, shot.y)];
    final path = Path()..moveTo(shot.x, shot.y);
    for (var i = 1; i <= 9; i++) {
      final t = i / 9;
      final baseX = shot.x + (tail.dx - shot.x) * t;
      final baseY = shot.y + (tail.dy - shot.y) * t;
      final jitter = i == 9
          ? 0.0
          : (sin(elapsed * 78 + shot.phase + i * 2.7) * 7 +
                cos(elapsed * 51 + i * 4.1) * 3);
      final point = Offset(baseX, baseY) + perpendicular * jitter;
      points.add(point);
      path.lineTo(point.dx, point.dy);
    }

    final branches = Path();
    for (final index in [2, 4, 6, 7]) {
      final origin = points[index];
      final direction = index.isEven ? -1.0 : 1.0;
      final branchLength = 9.0 + (index % 3) * 4;
      final middle =
          origin + along * 6 + perpendicular * direction * branchLength;
      final end =
          origin + along * 14 + perpendicular * direction * (branchLength + 7);
      branches
        ..moveTo(origin.dx, origin.dy)
        ..lineTo(middle.dx, middle.dy)
        ..lineTo(end.dx, end.dy);
    }

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20 * pulse
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xA8328CFF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11);
    c.drawPath(path, glowPaint);
    c.drawPath(branches, glowPaint..strokeWidth = 11 * pulse);
    c.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8 * pulse
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = const Color(0xFF72D8FF),
    );
    c.drawPath(
      branches,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = const Color(0xFFB7E9FF),
    );
    c.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.7
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = Colors.white,
    );

    final head = Offset(shot.x, shot.y);
    c.drawCircle(
      head,
      13 * pulse,
      Paint()
        ..color = const Color(0xCC3A9DFF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
    );
    c.drawCircle(head, 3.5 * pulse, Paint()..color = Colors.white);
    final sparkPaint = Paint()
      ..color = const Color(0xFF9CF7FF)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 4; i++) {
      final angle = elapsed * 12 + shot.phase + i * pi / 2;
      c.drawLine(
        head + Offset(cos(angle) * 5, sin(angle) * 5),
        head + Offset(cos(angle) * 12 * pulse, sin(angle) * 12 * pulse),
        sparkPaint,
      );
    }
  }

  void _drawEnemy(Canvas c, Foe e) {
    final sprite = switch (e.tier) {
      EnemyTier.elite => rainbowEnemySprite,
      EnemyTier.bomber => bomberEnemySprite,
      _ => enemySprite,
    };
    final source = switch (e.tier) {
      EnemyTier.elite => EnemyConfig.rainbowSpriteSource,
      EnemyTier.bomber => EnemyConfig.bomberSpriteSource,
      _ => EnemyConfig.redSpriteSource,
    };
    final scale = e.tier.spriteScale;
    c.drawImageRect(
      sprite,
      source,
      Rect.fromCenter(
        center: Offset(e.x, e.y),
        width: e.radius * 2.15 * scale,
        height: e.radius * 2.8 * scale,
      ),
      Paint()..filterQuality = FilterQuality.none,
    );
  }

  void _drawExplosionZone(Canvas c, ExplosionZone zone) {
    final progress = (zone.life / 3).clamp(0.0, 1.0);
    final pulse = .88 + sin(elapsed * 18) * .12;
    final center = Offset(zone.x, zone.y);
    final radius = ExplosionZone.radius * pulse;
    c.drawCircle(
      center,
      radius,
      Paint()..color = Color.fromRGBO(255, 48, 20, .13 * progress),
    );
    c.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = Color.fromRGBO(255, 86, 28, .9 * progress)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
    );
    c.drawCircle(
      center,
      radius * .68,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Color.fromRGBO(255, 220, 70, .9 * progress),
    );
    for (var i = 0; i < 8; i++) {
      final angle = i * pi / 4 + elapsed * 1.5;
      final inner = center + Offset(cos(angle), sin(angle)) * radius * .72;
      final outer = center + Offset(cos(angle), sin(angle)) * radius;
      c.drawLine(
        inner,
        outer,
        Paint()
          ..color = Color.fromRGBO(255, 190, 55, progress)
          ..strokeWidth = 3,
      );
    }
  }

  void _drawTreasure(Canvas c, Treasure item) {
    final center = Offset(item.x, item.y);
    final pulse = 1 + sin(item.phase * 2) * .08;
    c.drawCircle(
      center,
      20 * pulse,
      Paint()
        ..color = item.color.withValues(alpha: .2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
    );
    final rect = Rect.fromCenter(center: center, width: 31, height: 31);
    c.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(7)),
      Paint()..color = const Color(0xDD07101D),
    );
    c.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(7)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = item.color,
    );
    TextPaint(
      style: TextStyle(
        color: item.color,
        fontSize: 21,
        fontWeight: FontWeight.w900,
      ),
    ).render(c, item.label, Vector2(item.x - 7, item.y - 13));
  }

  void _drawBoss(Canvas c, Boss b) {
    final sprite = switch (stage) {
      1 => bossSprite,
      2 => battleshipBossSprite,
      _ => drillBossSprite,
    };
    final source = switch (stage) {
      1 => EnemyConfig.bossSpriteSource,
      2 => EnemyConfig.battleshipSpriteSource,
      _ => EnemyConfig.drillBossSpriteSource,
    };
    final bossSize = switch (stage) {
      1 => const Size(142, 176),
      2 => const Size(246, 238),
      _ => const Size(218, 250),
    };
    c.drawImageRect(
      sprite,
      source,
      Rect.fromCenter(
        center: Offset(b.x, b.y),
        width: bossSize.width,
        height: bossSize.height,
      ),
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
        Rect.fromLTWH(
          18,
          45,
          size.x * .38 * (hp / PlayerConfig.maxHp).clamp(0, 1),
          9,
        ),
        const Radius.circular(5),
      ),
      Paint()
        ..color = hp > 30 ? const Color(0xFF29E4FF) : const Color(0xFFFF4865),
    );
    final remain = max(
      0,
      EnemyConfig.bossStartTimeFor(stage) - stageElapsed,
    ).ceil();
    if (boss == null) tp.render(c, 'BOSS  $remain', Vector2(size.x - 90, 18));
    tp.render(c, 'STAGE $stage', Vector2(size.x - 86, 43));
    final weapons = 'A$powerLevel  B$missileLevel  C$lightningLevel';
    TextPaint(
      style: const TextStyle(
        color: Color(0xFFFFD76A),
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    ).render(c, weapons, Vector2(18, 61));
    if (boss case final b?) {
      tp.render(c, switch (stage) {
        1 => 'VOID REAPER',
        2 => 'CRIMSON DREADNOUGHT',
        _ => 'AZURE DRILL TYRANT',
      }, Vector2(size.x / 2 - 65, 62));
      c.drawRect(
        Rect.fromLTWH(30, 85, size.x - 60, 8),
        Paint()..color = const Color(0x554D1122),
      );
      c.drawRect(
        Rect.fromLTWH(
          30,
          85,
          (size.x - 60) * (b.hp / EnemyConfig.bossHpFor(stage)).clamp(0, 1),
          8,
        ),
        Paint()..color = const Color(0xFFFF3F70),
      );
    }
    if (stageElapsed < 4) {
      final hint = TextPaint(
        style: const TextStyle(
          color: Color(0xEEFFFFFF),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
      hint.render(c, switch (stage) {
        1 => 'STAGE 1 · 銀河前線',
        2 => 'STAGE 2 · 赤色風暴',
        _ => 'STAGE 3 · 蒼藍鑽皇',
      }, Vector2(size.x / 2 - 88, size.y * .58));
    }
  }
}
