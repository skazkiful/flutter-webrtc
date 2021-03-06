import 'dart:io';

/// This class used to make, close and calls to our websocket.
class SimpleWebSocket {
  /// Current websocket connection.
  // ignore: close_sinks
  WebSocket? _socket;

  /// Calls when connection to websocket was called.
  Function()? onOpen;

  /// Calls when was received new message from websocket.
  Function(dynamic msg)? onMessage;

  /// Calls when was called close to websocket.
  Function(int? code, String? reason)? onClose;

  /// This method used to make connect to our websocket.
  ///
  /// Which located on [wss://flutter-sandbox-skazkiful.herokuapp.com].
  Future<void> connect() async {
    try {
      _socket = await WebSocket.connect(
          'wss://flutter-sandbox-skazkiful.herokuapp.com');
      onOpen?.call();
      _socket!.listen((data) {
        onMessage?.call(data);
      }, onDone: () {
        onClose!.call(_socket!.closeCode, "{$_socket.closeReason}");
      });
    } catch (e) {
      onClose?.call(500, e.toString());
    }
  }

  /// This method send [data] to websocket.
  void send(data) {
    if (_socket != null) {
      _socket!.add(data);
    }
  }

  /// This method close connection to websocket.
  Future<void> close() async {
    if (_socket != null) _socket!.close();
  }
}
