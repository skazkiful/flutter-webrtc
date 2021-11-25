import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_webrtc_app/main.dart';

void main() {
  testWidgets('Test Home Page', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    await tester.press(find.textContaining('Join'));
  });
}
