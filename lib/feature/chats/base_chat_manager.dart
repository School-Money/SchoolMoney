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
        final senderName = message['senderName'] as String? ?? '';
        final nameParts = senderName.split(' ');
        final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
        final lastName = nameParts.length > 1 ? nameParts[1] : '';

        return types.TextMessage(
          author: types.User(
            id: message['sender'] ?? '',
            firstName: firstName,
            lastName: lastName,
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
