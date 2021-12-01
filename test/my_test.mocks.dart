// Mocks generated by Mockito 5.0.16 from annotations
// in flutter_sandbox/test/my_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:flutter_webrtc/src/interface/media_stream.dart' as _i2;
import 'package:flutter_webrtc/src/interface/media_stream_track.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeMediaStream_0 extends _i1.Fake implements _i2.MediaStream {}

/// A class which mocks [MediaStream].
///
/// See the documentation for Mockito's code generation for more information.
class MockMediaStream extends _i1.Mock implements _i2.MediaStream {
  MockMediaStream() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set onAddTrack(_i2.MediaTrackCallback? _onAddTrack) =>
      super.noSuchMethod(Invocation.setter(#onAddTrack, _onAddTrack),
          returnValueForMissingStub: null);
  @override
  set onRemoveTrack(_i2.MediaTrackCallback? _onRemoveTrack) =>
      super.noSuchMethod(Invocation.setter(#onRemoveTrack, _onRemoveTrack),
          returnValueForMissingStub: null);
  @override
  String get id =>
      (super.noSuchMethod(Invocation.getter(#id), returnValue: '') as String);
  @override
  String get ownerTag =>
      (super.noSuchMethod(Invocation.getter(#ownerTag), returnValue: '')
          as String);
  @override
  _i4.Future<void> getMediaTracks() =>
      (super.noSuchMethod(Invocation.method(#getMediaTracks, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> addTrack(_i5.MediaStreamTrack? track,
          {bool? addToNative = true}) =>
      (super.noSuchMethod(
          Invocation.method(#addTrack, [track], {#addToNative: addToNative}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> removeTrack(_i5.MediaStreamTrack? track,
          {bool? removeFromNative = true}) =>
      (super.noSuchMethod(
          Invocation.method(
              #removeTrack, [track], {#removeFromNative: removeFromNative}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  List<_i5.MediaStreamTrack> getTracks() =>
      (super.noSuchMethod(Invocation.method(#getTracks, []),
          returnValue: <_i5.MediaStreamTrack>[]) as List<_i5.MediaStreamTrack>);
  @override
  List<_i5.MediaStreamTrack> getAudioTracks() =>
      (super.noSuchMethod(Invocation.method(#getAudioTracks, []),
          returnValue: <_i5.MediaStreamTrack>[]) as List<_i5.MediaStreamTrack>);
  @override
  List<_i5.MediaStreamTrack> getVideoTracks() =>
      (super.noSuchMethod(Invocation.method(#getVideoTracks, []),
          returnValue: <_i5.MediaStreamTrack>[]) as List<_i5.MediaStreamTrack>);
  @override
  _i5.MediaStreamTrack? getTrackById(String? trackId) =>
      (super.noSuchMethod(Invocation.method(#getTrackById, [trackId]))
          as _i5.MediaStreamTrack?);
  @override
  _i2.MediaStream clone() => (super.noSuchMethod(Invocation.method(#clone, []),
      returnValue: _FakeMediaStream_0()) as _i2.MediaStream);
  @override
  _i4.Future<void> dispose() =>
      (super.noSuchMethod(Invocation.method(#dispose, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  String toString() => super.toString();
}

/// A class which mocks [MediaStreamTrack].
///
/// See the documentation for Mockito's code generation for more information.
class MockMediaStreamTrack extends _i1.Mock implements _i5.MediaStreamTrack {
  MockMediaStreamTrack() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set onMute(_i5.StreamTrackCallback? _onMute) =>
      super.noSuchMethod(Invocation.setter(#onMute, _onMute),
          returnValueForMissingStub: null);
  @override
  set onUnMute(_i5.StreamTrackCallback? _onUnMute) =>
      super.noSuchMethod(Invocation.setter(#onUnMute, _onUnMute),
          returnValueForMissingStub: null);
  @override
  set onEnded(_i5.StreamTrackCallback? _onEnded) =>
      super.noSuchMethod(Invocation.setter(#onEnded, _onEnded),
          returnValueForMissingStub: null);
  @override
  bool get enabled =>
      (super.noSuchMethod(Invocation.getter(#enabled), returnValue: false)
          as bool);
  @override
  set enabled(bool? b) => super.noSuchMethod(Invocation.setter(#enabled, b),
      returnValueForMissingStub: null);
  @override
  Map<String, dynamic> getConstraints() =>
      (super.noSuchMethod(Invocation.method(#getConstraints, []),
          returnValue: <String, dynamic>{}) as Map<String, dynamic>);
  @override
  _i4.Future<void> applyConstraints([Map<String, dynamic>? constraints]) =>
      (super.noSuchMethod(Invocation.method(#applyConstraints, [constraints]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> stop() => (super.noSuchMethod(Invocation.method(#stop, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  Map<String, dynamic> getSettings() =>
      (super.noSuchMethod(Invocation.method(#getSettings, []),
          returnValue: <String, dynamic>{}) as Map<String, dynamic>);
  @override
  _i4.Future<bool> switchCamera() =>
      (super.noSuchMethod(Invocation.method(#switchCamera, []),
          returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
  @override
  _i4.Future<void> adaptRes(int? width, int? height) =>
      (super.noSuchMethod(Invocation.method(#adaptRes, [width, height]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  void setVolume(double? volume) =>
      super.noSuchMethod(Invocation.method(#setVolume, [volume]),
          returnValueForMissingStub: null);
  @override
  void setMicrophoneMute(bool? mute) =>
      super.noSuchMethod(Invocation.method(#setMicrophoneMute, [mute]),
          returnValueForMissingStub: null);
  @override
  void enableSpeakerphone(bool? enable) =>
      super.noSuchMethod(Invocation.method(#enableSpeakerphone, [enable]),
          returnValueForMissingStub: null);
  @override
  _i4.Future<bool> hasTorch() =>
      (super.noSuchMethod(Invocation.method(#hasTorch, []),
          returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
  @override
  _i4.Future<void> setTorch(bool? torch) =>
      (super.noSuchMethod(Invocation.method(#setTorch, [torch]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> dispose() =>
      (super.noSuchMethod(Invocation.method(#dispose, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  String toString() => super.toString();
}
