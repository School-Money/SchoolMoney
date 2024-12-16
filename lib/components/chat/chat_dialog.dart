import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:school_money/auth/auth_service.dart';
import 'package:school_money/feature/chats/admin_chat_manager.dart';
import 'package:school_money/feature/chats/base_chat_manager.dart';
import 'package:school_money/feature/chats/class_chat_manager.dart';
import 'package:school_money/feature/chats/private_chat_manager.dart';
import 'package:school_money/feature/chats/socket_service.dart';

class ChatDialog extends StatefulWidget {
  final String? receiver;
  final bool isClass;

  const ChatDialog({
    super.key,
    this.receiver,
    this.isClass = false,
  });

  @override
  _ChatDialogState createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  List<types.Message> _messages = [];
  late BaseChatManager chatManager;
  String? _userId;
  String? _error;
  bool _isLoading = true;

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

    if (widget.receiver == null) {
      chatManager = AdminChatManager(
        socket: SocketService.instance.socket,
        currentUserId: _userId!,
        onMessagesUpdated: (messages) {
          if (!mounted) return;
          setState(() {
            _messages = List.from(messages);
          });
        },
      );
    } else {
      chatManager = widget.isClass
          ? ClassChatManager(
              receiverId: widget.receiver,
              socket: SocketService.instance.socket,
              currentUserId: _userId!,
              onMessagesUpdated: (messages) {
                if (!mounted) return;
                setState(() {
                  _messages = List.from(messages);
                });
              },
            )
          : PrivateChatManager(
              receiverId: widget.receiver,
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
  }

  void _handleSendPressed(types.PartialText message) {
    chatManager.sendMessage(message.text);
  }

  @override
  void dispose() {
    if (_userId != null) {
      chatManager.dispose();
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
      showUserAvatars: true,
      showUserNames: true,
      user: types.User(
        id: _userId!,
      ),
      theme: DefaultChatTheme(
        backgroundColor: Colors.white,
      ),
    );
  }
}
