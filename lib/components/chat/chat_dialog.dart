import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:school_money/feature/chats/chat_manager.dart';
import 'package:school_money/feature/chats/socket_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatDialog extends StatefulWidget {
  final String classId;
  final String userEmail;

  const ChatDialog({
    super.key,
    required this.classId,
    required this.userEmail,
  });

  @override
  _ChatDialogState createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  List<types.Message> _messages = [];
  late ChatManager _chatManager;

  @override
  void initState() {
    super.initState();
    _chatManager = ChatManager(
      classId: widget.classId,
      socket: SocketService.instance.socket,
      onMessagesUpdated: (messages) {
        if (!mounted) return;
        setState(() {
          _messages = messages;
        });
      },
      currentUserId: widget.userEmail,
    );
  }

  void _handleSendPressed(types.PartialText message) {
    _chatManager.sendMessage(message.text);
  }

  @override
  void dispose() {
    _chatManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Chat(
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: types.User(id: widget.userEmail),
        ),
      ),
    );
  }
}
