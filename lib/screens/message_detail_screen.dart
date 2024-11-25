import 'package:flutter/material.dart';

class MessageDetailScreen extends StatelessWidget {
  final String chatPartnerName = "John Doe";
  final String chatPartnerAvatar = "https://via.placeholder.com/150";

  final List<Message> messages = [
    Message(
      text: "Hey, how are you?",
      isSender: false,
      timestamp: "10:30 AM",
    ),
    Message(
      text: "I'm good, thanks! What about you?",
      isSender: true,
      timestamp: "10:32 AM",
    ),
    Message(
      text: "I'm doing well. Are you free for a call later?",
      isSender: false,
      timestamp: "10:35 AM",
    ),
    Message(
      text: "Sure, just let me know when!",
      isSender: true,
      timestamp: "10:36 AM",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(chatPartnerAvatar),
            ),
            const SizedBox(width: 10),
            Text(chatPartnerName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message.isSender
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isSender
                          ? Colors.blue[100]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          message.timestamp,
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
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
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
              // Xử lý gửi tin nhắn
              print("Message sent!");
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

class Message {
  final String text;
  final bool isSender;
  final String timestamp;

  Message({
    required this.text,
    required this.isSender,
    required this.timestamp,
  });
}
