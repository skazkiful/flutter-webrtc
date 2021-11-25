import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'signaling.dart';

/// This class used to make p2p calls
class CallPage extends StatefulWidget {
  const CallPage({Key? key}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  _CallPageState();
  Signaling? _signaling;
  /// Working microphone indicator
  ///
  /// Used for toggling microphone on CallPage class
  bool mic = true;
  /// Working camera indicator
  ///
  /// Used for toggling camera on CallPage class
  bool cam = true;
  String? _selfId;
  bool showUi = true;
  double opacityLevel = 1.0;
  Session? _session;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    initRenderers();
    _connect();
  }

  @override
  deactivate() {
    super.deactivate();
    _signaling?.close();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  /// Initialize RTCVideoRender
  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  /// Initialize remote RTCVideoRender
  rtcInitialize() async{
    setState(() {
      _remoteRenderer = RTCVideoRenderer();
    });
    await _remoteRenderer.initialize();
  }

  /// This method used when need to connect to websocket using [Signaling] class and [connect] method
  void _connect() async {
    _signaling ??= Signaling()..connect();
    _signaling?.onSignalingStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.ConnectionClosed:
        case SignalingState.ConnectionError:
        case SignalingState.ConnectionOpen:
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
        case CallState.CallStateInvite:
        case CallState.CallStateConnected:
        case CallState.CallStateRinging:
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

  /// Invite peer to p2p call
  _invitePeer(BuildContext context, String peerId) async {
    if (_signaling != null && peerId != _selfId) {
      _signaling?.invite(peerId);
    }
  }

  /// Ending p2p call
  _hangUp() {
    if (_session != null) {
      _signaling?.bye(_session!.sid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          onWillPop: () async {
            await _hangUp();
            Navigator.pop(context);
            return false;
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: (){
                setState(() {
                  if(showUi){
                    opacityLevel = 0;
                    showUi = false;
                  }else{
                    opacityLevel = 1.0;
                    showUi = true;
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
                      child: RTCVideoView(_remoteRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,),
                    ),
                  ),
                  Positioned(
                    child: SafeArea(
                      child: AnimatedOpacity(
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
                                  colors: <Color>[Colors.black.withOpacity(0.86), Colors.black.withOpacity(0.21),Colors.black.withOpacity(0)]
                              )
                          ),
                          child: Container(
                            child: Text("Ferris",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),),
                          ),
                        ),
                      ),
                    ),
                  ),
                  (cam)?Positioned(
                    top: 20,
                    right: 14,
                    child: SafeArea(
                        child: Container(
                          width: 119.0,
                          height: 159.0,
                          child: RTCVideoView(_localRenderer, mirror: true, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,),
                          decoration: BoxDecoration(color: Colors.black54),
                        )),
                  ):Container(),
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
                                  colors: <Color>[Colors.black.withOpacity(0.86), Colors.black.withOpacity(0.21),Colors.black.withOpacity(0)]
                              )
                          ),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(bottom: 48, right: 88, left: 88),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Material(
                                borderRadius: BorderRadius.circular(100),
                                color: (cam)?Color(0xFFD9D9D9):Color(0xFF6C6C6C),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: (){
                                    setState(() {
                                      cam = _signaling?.toggleCamera();
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 55,
                                    width: 55,
                                    child: Container(
                                      child: (cam)?SvgPicture.asset('assets/video-off.svg'):SvgPicture.asset('assets/video-on.svg'),
                                      width: 28,
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                borderRadius: BorderRadius.circular(100),
                                color: (mic)?Color(0xFFD9D9D9):Color(0xFF6C6C6C),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () async{
                                    setState(() {
                                      mic = _signaling?.toggleMic();
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 55,
                                    width: 55,
                                    child: Container(
                                      child: (mic)?SvgPicture.asset('assets/mic-off.svg'):SvgPicture.asset('assets/mic-on.svg'),
                                      width: 28,
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                borderRadius: BorderRadius.circular(100),
                                color: Color(0xFF990000),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () async{
                                    await _hangUp();
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 55,
                                    width: 55,
                                    child: Container(
                                      child: SvgPicture.asset('assets/end-call.svg'),
                                      width: 28,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}