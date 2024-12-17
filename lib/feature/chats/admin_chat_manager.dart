import 'package:school_money/feature/chats/base_chat_manager.dart';

class AdminChatManager extends BaseChatManager {
  AdminChatManager({
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
    socket.emit('joinRoomHelpdesk');
  }

  @override
  void sendMessage(String content) {
    try {
      socket.emit('sendMessageHelpdesk', {
        'content': content,
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
