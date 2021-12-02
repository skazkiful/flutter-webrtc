import 'package:flutter_sandbox/call.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'unit2_test.mocks.dart';

@GenerateMocks([RTCVideoRenderer])
void main() {
  test('Test timer', () async {
    CallPage callpage = CallPage();
    var newcallpage = callpage.createState();
    expect(newcallpage.timer, isNull);
    newcallpage.startTimer();
    expect(newcallpage.timer!.isActive, isTrue);
    newcallpage.stopTimer();
    expect(newcallpage.timer!.isActive, isFalse);
  });
  test('Check initialize renderers', () async {
    CallPage callpage = CallPage();
    MockRTCVideoRenderer mylocalRenderer = MockRTCVideoRenderer();
    MockRTCVideoRenderer myremoteRenderer = MockRTCVideoRenderer();
    var newcallpage = callpage.createState();
    newcallpage.localRenderer = mylocalRenderer;
    newcallpage.remoteRenderer = myremoteRenderer;
    await newcallpage.initRenderers();
    verify(newcallpage.localRenderer.initialize());
    verify(newcallpage.remoteRenderer.initialize());
  });
}
