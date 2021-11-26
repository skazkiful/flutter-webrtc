import 'dart:convert';
import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'random_string.dart';

import 'websocket.dart';

/// States of signaling.
enum SignalingState {
  /// Calls when connection to websocket was opened.
  ConnectionOpen,

  /// Calls when connection to websocket was closed.
  ConnectionClosed,

  /// Calls when websocket returns error.
  ConnectionError,
}

/// States of call.
enum CallState {
  /// Calls when was created new session.
  CallStateNew,

  /// Calls when one of users whant to end call.
  CallStateBye,
}

/// Session view.
///
/// Where [sid] - session id.
/// And [pid] - peer id.
class Session {
  Session({required this.sid, required this.pid});
  String pid;
  String sid;
  RTCPeerConnection? pc;
  RTCDataChannel? dc;
  List<RTCIceCandidate> remoteCandidates = [];
}

/// Signaling class used to make connection between 2 users.
class Signaling {
  Signaling();

  /// [selfId] - random number to define own id.
  String selfId = randomNumeric(6);

  /// [_socket] - used to interact with [SimpleWebSocket] class.
  SimpleWebSocket? _socket;

  /// List of users sessions.
  Map<String, Session> _sessions = {};

  /// Local video and audio stream.
  MediaStream? _localStream;

  /// Remote users video and audio streams.
  List<MediaStream> _remoteStreams = <MediaStream>[];

  /// Used to encode string to json.
  JsonEncoder _encoder = JsonEncoder();

  /// Used to decode json to string.
  JsonDecoder _decoder = JsonDecoder();

  /// List of ice servers.
  Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'url': 'stun:stun.stunprotocol.org:3478'},
      {'url': 'stun:stun.l.google.com:19302'},
    ]
  };

  /// Config of creating peer connection.
  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ]
  };

  /// Calls when need to change signaling state.
  Function(SignalingState state)? onSignalingStateChange;

  /// Calls when need to change call state.
  Function(Session session, CallState state)? onCallStateChange;

  /// Calls when users local video and audio turns on or off.
  Function(MediaStream stream)? onLocalStream;

  /// Calls when need to add remote users video and audio stream.
  Function(Session session, MediaStream stream)? onAddRemoteStream;

  /// Calls when remote users audio and video was removed.
  Function(Session session, MediaStream stream)? onRemoveRemoteStream;

  /// Calls when peers was updated.
  Function(dynamic event)? onPeersUpdate;

  /// Calls when was received new message from webrtc.
  Function(Session session, RTCDataChannel dc, RTCDataChannelMessage data)?
      onDataChannelMessage;

  /// Calls when was created new DataChannel.
  Function(Session session, RTCDataChannel dc)? onDataChannel;

  /// Closes connection to websocket and cleans sessions.
  close() async {
    await _cleanSessions();
    await _socket?.close();
  }

  /// Turn off and turn on users microphone.
  toggleMic() {
    if (_localStream != null) {
      bool enabled = _localStream!.getAudioTracks()[0].enabled;
      _localStream!.getAudioTracks()[0].enabled = !enabled;
      return !enabled;
    }
  }

  /// This method trun off and turn on users camera.
  toggleCamera() {
    if (_localStream != null) {
      bool enabled = _localStream!.getVideoTracks()[0].enabled;
      _localStream!.getVideoTracks()[0].enabled = !enabled;
      return !enabled;
    }
  }

  /// Make call to user using his [peerId].
  void invite(String peerId) async {
    String sessionId = selfId + '-' + peerId;
    Session session =
        await _createSession(null, peerId: peerId, sessionId: sessionId);
    _sessions[sessionId] = session;
    _createOffer(session);
    onCallStateChange?.call(session, CallState.CallStateNew);
  }

  /// End call with user closing their session [sessionId].
  bye(String sessionId) {
    _send('bye', {
      'session_id': sessionId,
      'from': selfId,
    });
    Session? sess = _sessions[sessionId];
    if (sess != null) {
      _closeSession(sess);
    }
  }

  /// Method process [message] received from websocket.
  void onMessage(message) async {
    Map<String, dynamic> mapData = message;
    Map data = mapData['data'];
    print(data);
    switch (mapData['type']) {
      case 'new':
        {
          if (onPeersUpdate != null) {
            onPeersUpdate?.call(data);
          }
        }
        break;
      case 'offer':
        {
          String peerId = data['from'];
          Map description = data['description'];
          String sessionId = data['session_id'];
          Session? session = _sessions[sessionId];
          Session newSession = await _createSession(session,
              peerId: peerId, sessionId: sessionId);
          _sessions[sessionId] = newSession;
          await newSession.pc?.setRemoteDescription(
              RTCSessionDescription(description['sdp'], description['type']));
          await _createAnswer(newSession);
          if (newSession.remoteCandidates.length > 0) {
            newSession.remoteCandidates.forEach((candidate) async {
              await newSession.pc?.addCandidate(candidate);
            });
            newSession.remoteCandidates.clear();
          }
          onCallStateChange?.call(newSession, CallState.CallStateNew);
        }
        break;
      case 'answer':
        {
          Map description = data['description'];
          String sessionId = data['session_id'];
          Session? session = _sessions[sessionId];
          session?.pc?.setRemoteDescription(
              RTCSessionDescription(description['sdp'], description['type']));
        }
        break;
      case 'candidate':
        {
          String peerId = data['from'];
          Map candidateMap = data['candidate'];
          String sessionId = data['session_id'];
          Session? session = _sessions[sessionId];
          RTCIceCandidate candidate = RTCIceCandidate(candidateMap['candidate'],
              candidateMap['sdpMid'], candidateMap['sdpMLineIndex']);

          if (session != null) {
            if (session.pc != null) {
              await session.pc?.addCandidate(candidate);
            } else {
              session.remoteCandidates.add(candidate);
            }
          } else {
            _sessions[sessionId] = Session(pid: peerId, sid: sessionId)
              ..remoteCandidates.add(candidate);
          }
        }
        break;
      case 'leave':
        {
          String peerId = data as String;
          _closeSessionByPeerId(peerId);
        }
        break;
      case 'bye':
        {
          String sessionId = data['session_id'];
          print('bye: ' + sessionId);
          Session? session = _sessions.remove(sessionId);
          onCallStateChange?.call(session!, CallState.CallStateBye);
          _closeSession(session!);
        }
        break;
      case 'keepalive':
        {
          print('keepalive response!');
        }
        break;
      default:
        break;
    }
  }

  /// Method create connection to websocket.
  Future<void> connect() async {
    _socket = SimpleWebSocket();
    _socket?.onOpen = () {
      print('onOpen');
      onSignalingStateChange?.call(SignalingState.ConnectionOpen);
      _send('new', {
        'id': selfId,
      });
    };

    _socket?.onMessage = (message) {
      print('Received data: ' + message);
      onMessage(_decoder.convert(message));
    };

    _socket?.onClose = (int? code, String? reason) {
      print('Closed by server [$code => $reason]!');
      onSignalingStateChange?.call(SignalingState.ConnectionClosed);
    };
    _localStream = await createStream();
    await _socket?.connect();
  }

  /// Used to start getting media data from local user phone.
  Future<MediaStream> createStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth': '640',
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    onLocalStream?.call(stream);
    return stream;
  }

  /// Method create session between two users.
  ///
  /// [session] - session name.
  /// [peerId] - user id which will be connected with us.
  Future<Session> _createSession(Session? session,
      {required String peerId, required String sessionId}) async {
    Session newSession = session ?? Session(sid: sessionId, pid: peerId);
    RTCPeerConnection pc = await createPeerConnection({
      ..._iceServers,
      ...{'sdpSemantics': 'unified-plan'}
    }, _config);
    pc.onTrack = (event) {
      if (event.track.kind == 'video') {
        onAddRemoteStream?.call(newSession, event.streams[0]);
      }
    };
    _localStream!.getTracks().forEach((track) {
      pc.addTrack(track, _localStream!);
    });
    pc.onIceCandidate = (candidate) async {
      await Future.delayed(
          const Duration(seconds: 1),
          () => _send('candidate', {
                'to': peerId,
                'from': selfId,
                'candidate': {
                  'sdpMLineIndex': candidate.sdpMlineIndex,
                  'sdpMid': candidate.sdpMid,
                  'candidate': candidate.candidate,
                },
                'session_id': sessionId,
              }));
    };

    pc.onIceConnectionState = (state) {};

    pc.onRemoveStream = (stream) {
      onRemoveRemoteStream?.call(newSession, stream);
      _remoteStreams.removeWhere((it) {
        return (it.id == stream.id);
      });
    };

    pc.onDataChannel = (channel) {
      _addDataChannel(newSession, channel);
    };

    newSession.pc = pc;
    return newSession;
  }

  /// Method create RTCDataChannel in session.
  void _addDataChannel(Session session, RTCDataChannel channel) {
    channel.onDataChannelState = (e) {};
    channel.onMessage = (RTCDataChannelMessage data) {
      onDataChannelMessage?.call(session, channel, data);
    };
    session.dc = channel;
    onDataChannel?.call(session, channel);
  }

  /// this method make offer to user to make p2p call.
  Future<void> _createOffer(Session session) async {
    try {
      RTCSessionDescription s = await session.pc!.createOffer({});
      await session.pc!.setLocalDescription(s);
      _send('offer', {
        'to': session.pid,
        'from': selfId,
        'description': {'sdp': s.sdp, 'type': s.type},
        'session_id': session.sid,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  /// This method answers to user about making p2p call.
  Future<void> _createAnswer(Session session) async {
    try {
      RTCSessionDescription s = await session.pc!.createAnswer({});
      await session.pc!.setLocalDescription(s);
      _send('answer', {
        'to': session.pid,
        'from': selfId,
        'description': {'sdp': s.sdp, 'type': s.type},
        'session_id': session.sid,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  /// This method send data to websocket.
  ///
  /// Where [event] - event type.
  /// And [data] - message text.
  _send(event, data) {
    Map request = Map();
    request["type"] = event;
    request["data"] = data;
    _socket?.send(_encoder.convert(request));
  }

  /// This method clean all sessions.
  Future<void> _cleanSessions() async {
    _sessions.forEach((key, sess) async {
      await sess.pc?.close();
      await sess.dc?.close();
    });
    _sessions.clear();
  }

  /// This method calls when user leave from call and close session with this user.
  void _closeSessionByPeerId(String peerId) {
    Session session = Session(pid: '', sid: '');
    _sessions.removeWhere((String key, Session sess) {
      var ids = key.split('-');
      session = sess;
      return peerId == ids[0] || peerId == ids[1];
    });
    _closeSession(session);
    onCallStateChange?.call(session, CallState.CallStateBye);
  }

  /// This method close custom session.
  Future<void> _closeSession(Session session) async {
    await session.pc?.close();
    await session.dc?.close();
  }
}
