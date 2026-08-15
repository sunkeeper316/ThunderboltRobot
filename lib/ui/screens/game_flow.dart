import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../game/thunderbolt_game.dart';
import '../../services/progress_service.dart';
import 'home_screen.dart';
import 'result_screen.dart';
import 'robot_select_screen.dart';
import 'stage_select_screen.dart';

enum FlowScreen { home, select, stageSelect, battle, result }

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
  int highestUnlockedStage = 1;
  int selectedStage = 1;
  final progressService = ProgressService();

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final unlocked = await progressService.loadUnlockedStage();
    if (!mounted) return;
    setState(() => highestUnlockedStage = unlocked);
  }

  Future<void> _recordStageClear(int clearedStage) async {
    final unlocked = await progressService.unlockAfterClearing(clearedStage);
    if (!mounted || unlocked == highestUnlockedStage) return;
    setState(() => highestUnlockedStage = unlocked);
  }

  void startBattle([int stage = 1]) {
    selectedStage = stage;
    final next = ThunderboltGame(
      initialStage: stage,
      onStageCleared: _recordStageClear,
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
          onStageSelect: highestUnlockedStage > 1
              ? () => setState(() => screen = FlowScreen.stageSelect)
              : null,
        ),
        FlowScreen.select => RobotSelectScreen(
          onStart: () => startBattle(1),
          onBack: () => setState(() => screen = FlowScreen.home),
        ),
        FlowScreen.stageSelect => StageSelectScreen(
          highestUnlockedStage: highestUnlockedStage,
          onSelect: startBattle,
          onBack: () => setState(() => screen = FlowScreen.home),
        ),
        FlowScreen.battle => GameWidget(game: game!),
        FlowScreen.result => ResultScreen(
          victory: victory,
          score: score,
          onRetry: () => startBattle(selectedStage),
          onHome: () => setState(() => screen = FlowScreen.home),
        ),
      },
    ),
  );
}
