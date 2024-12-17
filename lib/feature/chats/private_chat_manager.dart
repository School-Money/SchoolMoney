import 'package:school_money/feature/chats/base_chat_manager.dart';

class PrivateChatManager extends BaseChatManager {
  PrivateChatManager({
    required super.receiverId,
    required super.onMessagesUpdated,
    required super.socket,
    required super.currentUserId,
  });

  @override
  void setup() {
    socket.on('receiveMessage', (messages) {
      final convertedMessages = super.convertMessages(messages);
      onMessagesUpdated(convertedMessages);
    });

    joinRoom();
  }

  @override
  void joinRoom() {
    socket.emit('joinRoomPrivate', {'receiverId': receiverId});
  }

  @override
  void sendMessage(String content) {
    try {
      socket.emit('sendMessagePrivate', {
        'receiverId': receiverId,
        'content': content,
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
