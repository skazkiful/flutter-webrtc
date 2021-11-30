import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'call_buttons.dart';
import 'signaling.dart';
import 'dart:async';

/// This class used to make p2p calls.
class CallPage extends StatefulWidget {
  const CallPage({Key? key}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  _CallPageState();

  /// Opacity of part Widgets.
  double opacityLevel = 1.0;

  /// Working microphone indicator.
  ///
  /// Used for toggling microphone on CallPage class.
  bool mic = true;

  /// Working camera indicator.
  ///
  /// Used for toggling camera on CallPage class.
  bool cam = true;

  /// String with local users id.
  String? _selfId;

  /// Current session.
  Session? _session;

  /// Local users media data stream.
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();

  /// Remote users media data stream.
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  /// Variable used to interact with [Signaling] class.
  Signaling? _signaling;

  /// Timer variable, used to ping websocket every 10 seconds
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initRenderers();
    _connect();
  }

  @override
  deactivate() {
    super.deactivate();
    if (timer != null) {
      timer!.cancel();
    }
    _signaling?.close();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  /// Initialize RTCVideoRender.
  void initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  /// Initialize timer
  void startTimer() {
    const tenSec = const Duration(seconds: 10);
    timer = new Timer.periodic(
      tenSec,
      (Timer timer) {
        _signaling!.ping();
      },
    );
  }

  /// Initialize remote RTCVideoRender.
  void rtcInitialize() async {
    setState(() {
      _remoteRenderer = RTCVideoRenderer();
    });
    await _remoteRenderer.initialize();
  }

  /// This method used when need to connect to websocket using [Signaling] class and [connect] method.
  void _connect() async {
    _signaling ??= Signaling()..connect();
    _signaling?.onSignalingStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.ConnectionClosed:
        case SignalingState.ConnectionError:
        case SignalingState.ConnectionOpen:
          if (timer == null) {
            startTimer();
          }
          break;
      }
    };

    _signaling?.onCallStateChange = (Session session, CallState state) {
      switch (state) {
        case CallState.CallStateNew:
          setState(() {
            _session = session;
          });
          break;
        case CallState.CallStateBye:
          setState(() {
            rtcInitialize();
            _session = null;
          });
          break;
      }
    };

    _signaling?.onLocalStream = ((stream) {
      setState(() {
        _localRenderer.srcObject = stream;
      });
    });

    _signaling?.onAddRemoteStream = ((_, stream) {
      setState(() {
        _remoteRenderer.srcObject = stream;
      });
    });

    _signaling?.onPeersUpdate = ((event) {
      print(event);
      _invitePeer(context, event['id']);
    });
    setState(() {
      _selfId = _signaling!.selfId;
    });
  }

  /// Invite peer to p2p call.
  void _invitePeer(BuildContext context, String peerId) async {
    if (_signaling != null && peerId != _selfId) {
      _signaling?.invite(peerId);
    }
  }

  /// Ending p2p call.
  Future _hangUp() async {
    if (_session != null) {
      _signaling?.bye(_session!.sid);
    }
    setState(() {
      _localRenderer.srcObject = null;
      _remoteRenderer.srcObject = null;
      _session = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            await _hangUp();
            return false;
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: InkWell(
              key: Key('backInkWell'),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  if (opacityLevel == 1.0) {
                    opacityLevel = 0.0;
                  } else {
                    opacityLevel = 1.0;
                  }
                });
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SafeArea(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: RTCVideoView(
                        _remoteRenderer,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      ),
                    ),
                  ),
                  Positioned(
                    child: SafeArea(
                      child: AnimatedOpacity(
                        key: Key('animatedOpacity'),
                        duration: Duration(milliseconds: 250),
                        opacity: opacityLevel,
                        child: Container(
                          alignment: Alignment.center,
                          height: 132,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  tileMode: TileMode.clamp,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                Colors.black.withOpacity(0.86),
                                Colors.black.withOpacity(0.21),
                                Colors.black.withOpacity(0)
                              ])),
                          child: Container(
                            child: Text(
                              "Ferris",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  (cam)
                      ? Positioned(
                          top: 20,
                          right: 14,
                          child: SafeArea(
                              child: Container(
                            width: 119.0,
                            height: 159.0,
                            child: RTCVideoView(
                              _localRenderer,
                              mirror: true,
                              objectFit: RTCVideoViewObjectFit
                                  .RTCVideoViewObjectFitCover,
                            ),
                            decoration: BoxDecoration(color: Colors.black54),
                          )),
                        )
                      : Container(),
                  Positioned(
                    bottom: 0,
                    child: SafeArea(
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 250),
                        opacity: opacityLevel,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  tileMode: TileMode.clamp,
                                  end: Alignment.topCenter,
                                  colors: <Color>[
                                Colors.black.withOpacity(0.86),
                                Colors.black.withOpacity(0.21),
                                Colors.black.withOpacity(0)
                              ])),
                          width: MediaQuery.of(context).size.width,
                          padding:
                              EdgeInsets.only(bottom: 48, right: 88, left: 88),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ToggleCallButtons(
                                key: Key('videotoggle'),
                                icon: (cam)
                                    ? 'assets/video-off.svg'
                                    : 'assets/video-on.svg',
                                onClick: () {
                                  setState(() {
                                    cam = _signaling!.toggleCamera();
                                  });
                                },
                                color: (cam)
                                    ? Color(0xFFD9D9D9)
                                    : Color(0xFF6C6C6C),
                              ),
                              ToggleCallButtons(
                                key: Key('mictoggle'),
                                icon: (mic)
                                    ? 'assets/mic-off.svg'
                                    : 'assets/mic-on.svg',
                                onClick: () {
                                  setState(() {
                                    mic = _signaling!.toggleMic();
                                  });
                                },
                                color: (mic)
                                    ? Color(0xFFD9D9D9)
                                    : Color(0xFF6C6C6C),
                              ),
                              ToggleCallButtons(
                                key: Key('endcall'),
                                icon: 'assets/end-call.svg',
                                onClick: () async {
                                  Navigator.pop(context);
                                  await _hangUp();
                                },
                                color: Color(0xFF990000),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
