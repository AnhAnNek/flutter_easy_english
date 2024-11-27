import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easy_english/services/i_message_service.dart';
import 'package:flutter_easy_english/services/webSocket_service.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

class MessageDetailScreen extends StatefulWidget {
  final String senderUsername;
  final String recipientUsername;

  const MessageDetailScreen({
    Key? key,
    required this.senderUsername,
    required this.recipientUsername,
  }) : super(key: key);

  @override
  _MessageDetailScreenState createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  late final Logger _logger;
  late final IMessageService _messageService;
  late final WebSocketService _webSocketService; // Add WebSocketService
  final List<dynamic> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _logger = Logger();
    
    _messageService = Provider.of<IMessageService>(context, listen: false);

    _webSocketService = WebSocketService();
    // Connect WebSocket
    _webSocketService.connect(() {
      // Subscribe to a topic when WebSocket is connected
      _webSocketService.subscribe('/topic/messages/${widget.recipientUsername}', (message) {
        _handleIncomingMessage(message);
      });
    });

    _fetchMessages();
  }

  @override
  void dispose() {
    // Unsubscribe and disconnect WebSocket
    _webSocketService.unsubscribe('/topic/messages/${widget.recipientUsername}');
    _webSocketService.disconnect();
    super.dispose();
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await _messageService.getAllMessages(
        widget.senderUsername,
        widget.recipientUsername,
        0, // Page number
        1000, // Page size
      );
      setState(() {
        _messages.addAll(response['content']);
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      _logger.e('Error fetching messages: $error');
    }
  }

  void _handleIncomingMessage(dynamic message) {
    setState(() {
      _messages.add(message); // Add the incoming message to the list
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _sendMessage(String content) {
    final newMessage = {
      'senderUsername': widget.senderUsername,
      'recipientUsername': widget.recipientUsername,
      'content': content,
      'sendingTime': DateTime.now().toString(),
    };

    // Send the message via WebSocket
    _webSocketService.send('/app/messages/${widget.recipientUsername}', newMessage);

    // Add the message to the local list
    setState(() {
      _messages.add(newMessage);
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                _messages.isNotEmpty && _messages[0]['recipient']['avatarPath'] != null
                    ? _messages[0]['recipient']['avatarPath']
                    : 'https://via.placeholder.com/150',
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _messages.isNotEmpty
                  ? _messages[0]['recipient']['fullName']
                  : 'Loading...',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isSender = message['senderUsername'] == widget.senderUsername;

        return Align(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSender ? Colors.blue[100] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message['content'] ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  message['sendingTime'] ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    final TextEditingController _controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              final message = _controller.text.trim();
              if (message.isNotEmpty) {
                _sendMessage(message); // Send the message via WebSocket
                _controller.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(14),
            ),
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
