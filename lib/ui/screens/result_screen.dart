import 'package:flutter/material.dart';

import '../widgets/glow_button.dart';

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
