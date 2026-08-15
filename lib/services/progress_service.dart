import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const _unlockedStageKey = 'highest_unlocked_stage';
  static const int maxStage = 3;

  Future<int> loadUnlockedStage() async {
    final preferences = await SharedPreferences.getInstance();
    return (preferences.getInt(_unlockedStageKey) ?? 1).clamp(1, maxStage);
  }

  Future<int> unlockAfterClearing(int clearedStage) async {
    final preferences = await SharedPreferences.getInstance();
    final current = (preferences.getInt(_unlockedStageKey) ?? 1).clamp(
      1,
      maxStage,
    );
    final unlocked = (clearedStage + 1).clamp(1, maxStage);
    final next = unlocked > current ? unlocked : current;
    await preferences.setInt(_unlockedStageKey, next);
    return next;
  }
}
