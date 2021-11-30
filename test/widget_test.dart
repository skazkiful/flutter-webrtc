import 'package:flutter/material.dart';
import 'package:flutter_sandbox/call.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_sandbox/main.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

Widget createWidgetForTesting({required Widget child}) {
  return MaterialApp(
    home: child,
  );
}

void main() {
  testWidgets('Home Page tester', (tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.byKey(Key('join')), findsOneWidget);
  });
  testWidgets('Call Page tester', (tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: CallPage()));
    expect(find.byKey(Key('videotoggle')), findsOneWidget);
    expect(find.byKey(Key('mictoggle')), findsOneWidget);
  });
  testWidgets('Call Page back animation tester', (tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: CallPage()));
    await tester.tap(find.byKey(Key('backInkWell')));
    await tester.pumpAndSettle(Duration(seconds: 3));
    AnimatedOpacity opacityBlock =
        tester.widget<AnimatedOpacity>(find.byKey(Key("animatedOpacity")));
    expect(opacityBlock.opacity, 0.0);
    await tester.tap(find.byKey(Key('backInkWell')));
    await tester.pumpAndSettle(Duration(seconds: 3));
    opacityBlock =
        tester.widget<AnimatedOpacity>(find.byKey(Key("animatedOpacity")));
    expect(opacityBlock.opacity, 1.0);
  });
  testWidgets('Test routes', (tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.byType(CallPage), findsNothing);
    await tester.tap(find.text("Join"));
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsNothing);
    expect(find.byType(CallPage), findsOneWidget);
  });
}
