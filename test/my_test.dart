import 'dart:io';

import 'package:flutter_sandbox/websocket.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/signaling.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'my_test.mocks.dart';

@GenerateMocks([MediaStream, MediaStreamTrack])
void main() {
  test('Test toggle camera', () async {
    Signaling _signaling = Signaling();
    MockMediaStream myStream = MockMediaStream();
    MockMediaStreamTrack track = MockMediaStreamTrack();
    _signaling.localStream = myStream;
    when(myStream.getVideoTracks()).thenAnswer((realInvocation) {
      return [track];
    });
    when(track.enabled).thenAnswer((realInvocation) {
      return true;
    });
    expect(_signaling.toggleCamera(), isFalse);
  });

  test('Test toggle microphone', () async {
    Signaling _signaling = Signaling();
    MockMediaStream myStream = MockMediaStream();
    MockMediaStreamTrack track = MockMediaStreamTrack();
    _signaling.localStream = myStream;
    when(myStream.getAudioTracks()).thenAnswer((realInvocation) {
      return [track];
    });
    when(track.enabled).thenAnswer((realInvocation) {
      return true;
    });
    expect(_signaling.toggleMic(), isFalse);
  });

  test('Test websocket', () async {
    SimpleWebSocket websocket = SimpleWebSocket();
    bool wasOpen = false;
    bool wasClose = false;
    websocket.onOpen = () async {
      wasOpen = true;
      await websocket.close();
    };
    websocket.onClose = (r, v) {
      wasClose = true;
      expect(wasOpen, true);
      expect(wasClose, true);
    };
    await websocket.connect();
  });
}
