// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:thunderbolt_robot/main.dart';

void main() {
  testWidgets('opens settings and shows privacy policy entry', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ThunderboltApp());

    expect(find.text('ThunderForce'), findsOneWidget);
    expect(find.text('開 始 任 務'), findsOneWidget);

    await tester.tap(find.byTooltip('設定'));
    await tester.pumpAndSettle();
    expect(find.text('版本'), findsOneWidget);
    expect(find.text('聯絡我們'), findsOneWidget);
    expect(find.text('隱私權政策與服務條款'), findsOneWidget);
  });
}
