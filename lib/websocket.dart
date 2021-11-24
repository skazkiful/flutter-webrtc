import 'dart:io';

class SimpleWebSocket {
  var _socket;
  Function()? onOpen;
  Function(dynamic msg)? onMessage;
  Function(int code, String reaso)? onClose;

  connect() async {
    try {
      _socket = await WebSocket.connect('wss://flutter-sandbox-skazkiful.herokuapp.com');
      onOpen?.call();
      _socket.listen((data) {
        onMessage?.call(data);
      }, onDone: () {
        onClose?.call(_socket.closeCode, _socket.closeReason);
      });
    } catch (e) {
      onClose?.call(500, e.toString());
    }
  }

  send(data) {
    if (_socket != null) {
      _socket.add(data);
    }
  }

  close() {
    if (_socket != null) _socket.close();
  }
}