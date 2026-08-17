import 'package:flutter/material.dart';

import '../widgets/glow_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onStart,
    required this.onSettings,
    this.onStageSelect,
  });
  final VoidCallback onStart;
  final VoidCallback onSettings;
  final VoidCallback? onStageSelect;

  @override
  Widget build(BuildContext context) => Stack(
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
              if (onStageSelect != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: onStageSelect,
                    icon: const Icon(Icons.map_outlined),
                    label: const Text(
                      '選 擇 關 卡',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF85E9FF),
                      side: const BorderSide(color: Color(0xFF37BFD9)),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      SafeArea(
        child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: IconButton.filledTonal(
              onPressed: onSettings,
              tooltip: '設定',
              icon: const Icon(Icons.settings_outlined),
              style: IconButton.styleFrom(
                foregroundColor: const Color(0xFFEAFBFF),
                backgroundColor: const Color(0xAA071A2D),
                side: const BorderSide(color: Color(0x8847DDFB)),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
