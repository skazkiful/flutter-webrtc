import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/signaling.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_sandbox/websocket.dart';
import 'my_test.mocks.dart';

class NewSignaling extends Signaling{
  @override
  Future<MediaStream> createStream() async {
    MockMediaStream myStream = MockMediaStream();
    MockMediaStreamTrack track = MockMediaStreamTrack();
    track.enabled = true;
    myStream.addTrack(track);
    return myStream;
  }
}

Widget createWidgetForTesting({required Widget child}) {
  return MaterialApp(
    home: child,
  );
}

@GenerateMocks([MediaStream,MediaStreamTrack])
void main() {
  test('Test toggle camera', () async {
    var toggle = true;
    Signaling _signaling = NewSignaling();
    _signaling.localStream = await _signaling.createStream();
    when(_signaling.localStream!.getVideoTracks()).thenAnswer((realInvocation){
      return _signaling.localStream!.getVideoTracks();
    });
    when(_signaling.localStream).thenAnswer((_){
      return _signaling.localStream;
    });
    print(_signaling.toggleCamera());
  });

  /*test('Test toggle microphone', () async {
    Signaling _signaling = MockSignaling();
    bool mic = true;
    when(_signaling.toggleMic()).thenReturn(!mic);
    mic = _signaling.toggleMic();
    verify(_signaling.toggleMic());
    expect(mic, isFalse);
  });

  test('Test websocket', () async {
    Signaling _signaling = MockSignaling();
    bool mic = true;
    when(_signaling.toggleMic()).thenReturn(!mic);
    mic = _signaling.toggleMic();
    verify(_signaling.toggleMic());
    expect(mic, isFalse);
  });*/
}
