import 'package:flutter/material.dart';
import 'package:flutter_sandbox/call.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_sandbox/main.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('Test Home Page', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: MyHomePage()));
    await tester.pumpAndSettle();
    await tester.press(find.byType(InkWell));
  });

  testWidgets('Test Call Page', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: CallPage()));
    await tester.pumpAndSettle();
    await tester.press(find.byKey(Key('endcall')));
    await tester.pump();
  });
}
