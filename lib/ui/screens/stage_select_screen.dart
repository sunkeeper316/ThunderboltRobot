import 'package:flutter/material.dart';

class StageSelectScreen extends StatelessWidget {
  const StageSelectScreen({
    super.key,
    required this.highestUnlockedStage,
    required this.onSelect,
    required this.onBack,
  });

  final int highestUnlockedStage;
  final ValueChanged<int> onSelect;
  final VoidCallback onBack;

  static const _stageNames = ['銀河前線', '赤色風暴', '蒼藍鑽皇'];
  static const _stageDescriptions = [
    '75 秒 · VOID REAPER',
    '110 秒 · CRIMSON DREADNOUGHT',
    '225 秒 · AZURE DRILL TYRANT',
  ];

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0A2441), Color(0xFF01040D)],
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
              const Text(
                '選擇關卡',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(22),
              itemCount: 3,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final stage = index + 1;
                final unlocked = stage <= highestUnlockedStage;
                return Material(
                  color: unlocked
                      ? const Color(0xCC0D2942)
                      : const Color(0x880A101A),
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: unlocked ? () => onSelect(stage) : null,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: unlocked
                              ? const Color(0xFF39DFFF)
                              : Colors.white12,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            stage.toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: unlocked
                                  ? const Color(0xFF62E7FF)
                                  : Colors.white24,
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _stageNames[index],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  unlocked ? _stageDescriptions[index] : '尚未解鎖',
                                  style: const TextStyle(
                                    color: Color(0xFF8AB8CB),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(unlocked ? Icons.play_arrow : Icons.lock),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
