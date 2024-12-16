import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:socket_io_client/socket_io_client.dart' as IO;

abstract class BaseChatManager {
  final String? receiverId;
  final IO.Socket socket;
  final String currentUserId;
  final void Function(List<types.Message>) onMessagesUpdated;

  BaseChatManager({
    this.receiverId,
    required this.onMessagesUpdated,
    required this.socket,
    required this.currentUserId,
  }) {
    setup();
  }

  @protected
  void setup();

  @protected
  void joinRoom();

  void sendMessage(String content);

  @protected
  List<types.Message> convertMessages(dynamic messages) {
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
