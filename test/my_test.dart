import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/signaling.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'my_test.mocks.dart';

class MockMediaStream extends Mock implements MediaStream {}

Widget createWidgetForTesting({required Widget child}) {
  return MaterialApp(
    home: child,
  );
}

@GenerateMocks([Signaling])
void main() {
  test('Test toggle camera', () async {
    var _signaling = MockSignaling();
    bool cam = true;
    when(_signaling.toggleCamera()).thenReturn(!cam);
    cam = _signaling.toggleCamera();
    verify(_signaling.toggleCamera());
    expect(cam, isFalse);
  });

  test('Test toggle microphone', () async {
    var _signaling = MockSignaling();
    bool mic = true;
    when(_signaling.toggleMic()).thenReturn(!mic);
    mic = _signaling.toggleMic();
    verify(_signaling.toggleMic());
    expect(mic, isFalse);
  });
}
