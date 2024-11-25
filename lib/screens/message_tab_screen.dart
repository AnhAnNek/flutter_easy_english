import 'package:flutter/material.dart';
import 'package:flutter_easy_english/screens/message_detail_screen.dart';

class MessageTabScreen extends StatefulWidget {
  @override
  _MessageTabScreenState createState() => _MessageTabScreenState();
}

class _MessageTabScreenState extends State<MessageTabScreen> {
  final List<Conversation> conversations = [
    Conversation(
      name: "John Doe",
      message: "Hey, how's it going?",
      avatarUrl: "http://10.147.20.214:9000/easy-english/image/course2.jpg",
      timestamp: "10:30 AM",
    ),
    Conversation(
      name: "Alice Smith",
      message: "Are you coming to the meeting?",
      avatarUrl: "http://10.147.20.214:9000/easy-english/image/course2.jpg",
      timestamp: "09:15 AM",
    ),
    Conversation(
      name: "Charlie Brown",
      message: "Let's catch up soon!",
      avatarUrl: "http://10.147.20.214:9000/easy-english/image/course2.jpg",
      timestamp: "Yesterday",
    ),
    Conversation(
      name: "Emily Davis",
      message: "Got your email, thanks!",
      avatarUrl: "http://10.147.20.214:9000/easy-english/image/course2.jpg",
      timestamp: "2 days ago",
    ),
  ];

  List<Conversation> filteredConversations = [];

  @override
  void initState() {
    super.initState();
    // Ban đầu, danh sách lọc giống danh sách gốc
    filteredConversations = conversations;
  }

  void _filterConversations(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredConversations = conversations;
      } else {
        filteredConversations = conversations
            .where((conversation) =>
        conversation.name.toLowerCase().contains(query.toLowerCase()) ||
            conversation.message.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ConversationSearchDelegate(conversations),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredConversations.length,
        itemBuilder: (context, index) {
          final conversation = filteredConversations[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(conversation.avatarUrl),
            ),
            title: Text(
              conversation.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              conversation.message,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              conversation.timestamp,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onTap: () {
              // Điều hướng đến màn hình chi tiết
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageDetailScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ConversationSearchDelegate extends SearchDelegate {
  final List<Conversation> conversations;

  ConversationSearchDelegate(this.conversations);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = conversations
        .where((conversation) =>
    conversation.name.toLowerCase().contains(query.toLowerCase()) ||
        conversation.message.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final conversation = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(conversation.avatarUrl),
          ),
          title: Text(
            conversation.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            conversation.message,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            conversation.timestamp,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MessageDetailScreen(),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = conversations
        .where((conversation) =>
    conversation.name.toLowerCase().contains(query.toLowerCase()) ||
        conversation.message.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final conversation = suggestions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(conversation.avatarUrl),
          ),
          title: Text(
            conversation.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            conversation.message,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            conversation.timestamp,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MessageDetailScreen(),
              ),
            );
          },
        );
      },
    );
  }
}

class Conversation {
  final String name;
  final String message;
  final String avatarUrl;
  final String timestamp;

  Conversation({
    required this.name,
    required this.message,
    required this.avatarUrl,
    required this.timestamp,
  });
}