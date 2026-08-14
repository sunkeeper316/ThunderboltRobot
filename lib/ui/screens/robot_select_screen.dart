import 'package:flutter/material.dart';

import '../widgets/glow_button.dart';
import '../widgets/robot_stat.dart';

class RobotSelectScreen extends StatelessWidget {
  const RobotSelectScreen({
    super.key,
    required this.onStart,
    required this.onBack,
  });
  final VoidCallback onStart;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Container(
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
                  border: Border.all(color: const Color(0xFF22CFFF), width: 2),
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
                          child: SizedBox(height: 190, width: double.infinity),
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
                            RobotStat(label: '火力', value: .78),
                            RobotStat(label: '裝甲', value: .68),
                            RobotStat(label: '機動', value: .85),
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
