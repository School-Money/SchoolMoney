import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:school_money/auth/auth_service.dart';
import 'package:school_money/feature/chats/chat_manager.dart';
import 'package:school_money/feature/chats/socket_service.dart';

class ChatDialog extends StatefulWidget {
  final String classId;

  const ChatDialog({
    super.key,
    required this.classId,
  });

  @override
  _ChatDialogState createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  List<types.Message> _messages = [];
  late ChatManager _chatManager;
  String? _userId;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeChatManager();
  }

  void _initializeChatManager() async {
    var userDetails = await AuthService().getUserDetails();
    if (userDetails!.id.isNotEmpty) {
      _userId = userDetails.id;
    }
    if (_userId == null) {
      print('UserId is null');
      return;
    }
    setState(() {
      _isLoading = false;
    });

    _chatManager = ChatManager(
      classId: widget.classId,
      socket: SocketService.instance.socket,
      currentUserId: _userId!,
      onMessagesUpdated: (messages) {
        if (!mounted) return;
        setState(() {
          _messages = List.from(messages);
        });
      },
    );
  }

  void _handleSendPressed(types.PartialText message) {
    _chatManager.sendMessage(message.text);
  }

  @override
  void dispose() {
    if (_userId != null) {
      _chatManager.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_userId == null) {
      return const Center(
        child: Text('Unable to initialize chat'),
      );
    }

    return Chat(
      messages: _messages,
      onSendPressed: _handleSendPressed,
      user: types.User(
        id: _userId!,
        firstName: 'Current User', // Add appropriate user name
      ),
      theme: DefaultChatTheme(
        backgroundColor: Colors.white,
      ),
    );
  }
}
