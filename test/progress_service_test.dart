import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thunderbolt_robot/services/progress_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('clearing stages permanently unlocks the next stage', () async {
    SharedPreferences.setMockInitialValues({});
    final service = ProgressService();

    expect(await service.loadUnlockedStage(), 1);
    expect(await service.unlockAfterClearing(1), 2);
    expect(await service.loadUnlockedStage(), 2);
    expect(await service.unlockAfterClearing(2), 3);
    expect(await service.loadUnlockedStage(), 3);
  });

  test('progress never exceeds the available stage count', () async {
    SharedPreferences.setMockInitialValues({'highest_unlocked_stage': 3});
    final service = ProgressService();

    expect(await service.unlockAfterClearing(3), 3);
  });
}
