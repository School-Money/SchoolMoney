import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:school_money/feature/chats/chat_manager.dart';
import 'package:school_money/feature/chats/socket_service.dart';
import 'package:http/http.dart' as http;

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
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['BASE_URL']}/auth/user-details'),
        headers: {
          'Authorization': SocketService.instance.accessToken,
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          _userId =
              userData['id']; // adjust according to your response structure
          _initializeChatManager();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load user details';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user details: $e');
      setState(() {
        _error = 'Error loading user details';
        _isLoading = false;
      });
    }
  }

  void _initializeChatManager() {
    if (_userId == null) return;

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
                _fetchUserDetails();
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
