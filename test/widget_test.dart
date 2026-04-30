// Widget test for Survive Finals Week app.
// Verifies the app bar title renders correctly on launch.

import 'package:flutter_test/flutter_test.dart';

import 'package:survive_finals_week/main.dart';

void main() {
  testWidgets('App renders title on launch', (WidgetTester tester) async {
    await tester.pumpWidget(const SurviveFinalsApp());
    expect(find.text('SURVIVE FINALS WEEK'), findsOneWidget);
  });
}
