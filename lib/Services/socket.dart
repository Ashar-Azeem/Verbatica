// socket_service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;

  void connect(String userId) {
    socket = IO.io(
      'http://192.168.100.81:4000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    socket!.onConnect((_) {
      socket!.emit('join_user', userId);
    });

    socket!.onDisconnect((_) {});
  }

  void disconnect(String userId) {
    if (socket != null && socket!.connected) {
      socket!.emit('leave_user', userId);
      socket!.disconnect();
    }
  }

  void onNewMessage(Function(dynamic) callback) {
    socket?.on('new_message', callback);
  }

  void offNewMessage(Function(dynamic) callback) {
    socket?.off('new_message', callback);
  }

  void onSeenAck(Function(dynamic) callback) {
    socket?.on('seen_ack', callback);
  }

  void offSeenAck(Function(dynamic) callback) {
    socket?.off('seen_ack', callback);
  }

  void onUpdateAck(Function(dynamic) callback) {
    socket?.on('update_message', callback);
  }

  void offUpdateAck(Function(dynamic) callback) {
    socket?.off('update_message', callback);
  }

  void onOnlineStatus(Function(dynamic) callback) {
    socket?.on('online_users', callback);
  }

  void offOnlineStatus(Function(dynamic) callback) {
    socket?.off('online_users', callback);
  }
}
