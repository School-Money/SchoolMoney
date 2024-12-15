// lib/services/socket_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static SocketService? _instance;
  late IO.Socket socket;
  late String headers;

  // Singleton pattern
  static SocketService get instance {
    _instance ??= SocketService._internal();
    return _instance!;
  }

  SocketService._internal();

  void initializeSocket(String token) {
    socket = IO.io(
        '${dotenv.env['BASE_URL']}/chat',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setExtraHeaders({'authorization': 'Bearer $token'})
            .setAuth({'token': 'Bearer $token'})
            .enableAutoConnect()
            .build());
    headers = 'Bearer $token';

    socket.connect();

    socket.onConnect((_) {
      print('Socket connected');
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket.onError((error) {
      print('Socket error: $error');
    });
  }

  void disconnect() {
    socket.disconnect();
  }

  void emit(String event, dynamic data) {
    // Ensure headers are included with every emit
    final Map<String, dynamic> payload = {
      ...data,
      'headers': headers,
    };
    socket.emit(event, payload);
  }
}
