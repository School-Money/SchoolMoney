import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:school_money/feature/chats/socket_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatManager {
  final String classId;
  final void Function(List<types.Message>) onMessagesUpdated;
  final IO.Socket socket;
  final String currentUserId; // Add this to identify the current user
  List<types.Message> _currentMessages = [];

  ChatManager({
    required this.classId,
    required this.onMessagesUpdated,
    required this.socket,
    required this.currentUserId,
  }) {
    _setup();
    fetchInitialMessages();
  }

  void _setup() {
    socket.on('receiveMessage', (messages) {
      final convertedMessages = _convertMessages(messages);
      onMessagesUpdated(convertedMessages);
    });

    _joinRoom();
  }

  void _joinRoom() {
    socket.emit('joinRoomClass', {'classId': classId});
  }

  void sendMessage(String content) {
    try {
      socket.emit('sendMessageClass', {
        'classId': classId,
        'content': content,
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<void> fetchInitialMessages() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['BASE_URL']}/chat/class?classId=$classId'),
        headers: {
          'Authorization': SocketService.instance.accessToken,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final convertedMessages = _convertMessages(data['messages'] ??
            []); // Adjust the path based on your response structure
        _currentMessages = convertedMessages;
        onMessagesUpdated(_currentMessages);
      } else {
        print('Error fetching messages: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error fetching initial messages: $e');
    }
  }

  List<types.Message> _convertMessages(dynamic messages) {
    if (messages == null) return [];

    try {
      final List messagesList = messages is List ? messages : [messages];

      return messagesList.map((message) {
        return types.TextMessage(
          author: types.User(
            id: message['sender'] ?? '',
            firstName: 'User', // Add a default name or get from your backend
          ),
          id: message['_id'] ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          text: message['content'] ?? '',
          createdAt:
              DateTime.parse(message['createdAt']).millisecondsSinceEpoch,
        );
      }).toList();
    } catch (e, stackTrace) {
      print('Error converting messages: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  void dispose() {
    socket.off('receiveMessage');
  }
}
