import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'thunderbolt_game.dart';

void main() => runApp(const ThunderboltApp());

class ThunderboltApp extends StatelessWidget {
  const ThunderboltApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thunderbolt Robot',
      theme: ThemeData(fontFamily: 'sans', brightness: Brightness.dark),
      home: const GameFlow(),
    );
  }
}

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: switch (screen) {
          FlowScreen.home => HomeScreen(
            onStart: () => setState(() => screen = FlowScreen.select),
          ),
          FlowScreen.select => RobotSelect(
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
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/hero_robot.png', fit: BoxFit.cover),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x44000000), Color(0x00000000), Color(0xDD020817)],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                const Text(
                  'THUNDERBOLT',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    color: Color(0xFFEAFBFF),
                    shadows: [Shadow(color: Color(0xFF00C8FF), blurRadius: 18)],
                  ),
                ),
                const Text(
                  'R O B O T',
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 9,
                    color: Color(0xFF55DEFF),
                  ),
                ),
                const Spacer(),
                const Text(
                  '銀河防衛作戰 · 第一章',
                  style: TextStyle(letterSpacing: 3, color: Color(0xFF9BDDF4)),
                ),
                const SizedBox(height: 18),
                GlowButton(label: '開 始 任 務', onTap: onStart),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RobotSelect extends StatelessWidget {
  const RobotSelect({super.key, required this.onStart, required this.onBack});
  final VoidCallback onStart;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF07172E), Color(0xFF01040D)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
                const Expanded(
                  child: Text(
                    '選擇機體',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '01 / 01',
                    style: TextStyle(color: Color(0xFF64DFFF)),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF22CFFF),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    color: const Color(0x221CBFEF),
                    boxShadow: const [
                      BoxShadow(color: Color(0x5500BFFF), blurRadius: 22),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/hero_robot.png',
                          fit: BoxFit.cover,
                          alignment: Alignment.bottomCenter,
                        ),
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Color(0xF2071124)],
                              ),
                            ),
                            child: SizedBox(
                              height: 190,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 20,
                          right: 20,
                          bottom: 18,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TB-01  雷霆先鋒',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '均衡型機體  ·  雙重雷射炮',
                                style: TextStyle(color: Color(0xFF83DFF9)),
                              ),
                              SizedBox(height: 12),
                              Stat(label: '火力', value: .78),
                              Stat(label: '裝甲', value: .68),
                              Stat(label: '機動', value: .85),
                            ],
                          ),
                        ),
                        const Positioned(
                          right: 14,
                          top: 14,
                          child: Chip(
                            label: Text('已選擇'),
                            avatar: Icon(
                              Icons.check_circle,
                              color: Color(0xFF27E7FF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
              child: GlowButton(label: '出 擊', onTap: onStart),
            ),
          ],
        ),
      ),
    );
  }
}

class Stat extends StatelessWidget {
  const Stat({super.key, required this.label, required this.value});
  final String label;
  final double value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Row(
      children: [
        SizedBox(width: 42, child: Text(label)),
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            minHeight: 5,
            color: const Color(0xFF1DE2FF),
            backgroundColor: Colors.white12,
          ),
        ),
      ],
    ),
  );
}

class GlowButton extends StatelessWidget {
  const GlowButton({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 58,
    child: FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF078DBE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF69E9FF), width: 2),
        ),
        elevation: 12,
        shadowColor: const Color(0xFF00D5FF),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w800,
          letterSpacing: 3,
        ),
      ),
    ),
  );
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.victory,
    required this.score,
    required this.onRetry,
    required this.onHome,
  });
  final bool victory;
  final int score;
  final VoidCallback onRetry;
  final VoidCallback onHome;
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: RadialGradient(colors: [Color(0xFF123D61), Color(0xFF010510)]),
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              victory ? Icons.workspace_premium : Icons.warning_amber_rounded,
              size: 100,
              color: victory
                  ? const Color(0xFFFFD65A)
                  : const Color(0xFFFF526B),
            ),
            const SizedBox(height: 22),
            Text(
              victory ? '任務完成' : '機體損毀',
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                letterSpacing: 5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '最終得分  $score',
              style: const TextStyle(fontSize: 20, color: Color(0xFF7DE5FF)),
            ),
            const SizedBox(height: 44),
            GlowButton(label: '再戰一次', onTap: onRetry),
            TextButton(onPressed: onHome, child: const Text('返回主畫面')),
          ],
        ),
      ),
    ),
  );
}
