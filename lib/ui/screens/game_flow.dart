import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../game/thunderbolt_game.dart';
import 'home_screen.dart';
import 'result_screen.dart';
import 'robot_select_screen.dart';

enum FlowScreen { home, select, battle, result }

class GameFlow extends StatefulWidget {
  const GameFlow({super.key});

  @override
  State<GameFlow> createState() => _GameFlowState();
}

class _GameFlowState extends State<GameFlow> {
  FlowScreen screen = FlowScreen.home;
  ThunderboltGame? game;
  bool victory = false;
  int score = 0;

  void startBattle() {
    final next = ThunderboltGame(
      onFinished: (won, finalScore) {
        if (!mounted) return;
        setState(() {
          victory = won;
          score = finalScore;
          screen = FlowScreen.result;
        });
      },
    );
    setState(() {
      game = next;
      screen = FlowScreen.battle;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: switch (screen) {
        FlowScreen.home => HomeScreen(
          onStart: () => setState(() => screen = FlowScreen.select),
        ),
        FlowScreen.select => RobotSelectScreen(
          onStart: startBattle,
          onBack: () => setState(() => screen = FlowScreen.home),
        ),
        FlowScreen.battle => GameWidget(game: game!),
        FlowScreen.result => ResultScreen(
          victory: victory,
          score: score,
          onRetry: startBattle,
          onHome: () => setState(() => screen = FlowScreen.home),
        ),
      },
    ),
  );
}
