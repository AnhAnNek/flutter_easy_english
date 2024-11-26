import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easy_english/screens/message_detail_screen.dart';
import 'package:flutter_easy_english/services/i_message_service.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

class MessageTabScreen extends StatefulWidget {
  @override
  _MessageTabScreenState createState() => _MessageTabScreenState();
}

class _MessageTabScreenState extends State<MessageTabScreen> {
  late final _logger;
  late final IMessageService _messageService;
  late Future<List<dynamic>> recentChatsFuture;

  @override
  void initState() {
    super.initState();

    _logger = Logger();

    // Initialize _messageService using Provider
    _messageService = Provider.of<IMessageService>(context, listen: false);

    // Fetch recent chats on initialization
    recentChatsFuture = _fetchRecentChats();
  }

  Future<List<dynamic>> _fetchRecentChats() async {
    try {
      final response = await _messageService.getRecentChats(0, 100); // Fetch the first 100 chats
      _logger.i('_fetchRecentChats: ${response}');

      // Ensure 'content' is a list and handle type mismatches
      if (response['content'] is List) {
        return response['content'];
      } else {
        return [];
      }
    } catch (error) {
      _logger.e("Error fetching recent chats: $error");
      return [];
    }
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
                delegate: ConversationSearchDelegate(_logger, _messageService),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: recentChatsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No recent chats available."));
          } else {
            final recentChats = snapshot.data!;
            return ListView.builder(
              itemCount: recentChats.length,
              itemBuilder: (context, index) {
                final chat = recentChats[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(chat['avatarPath']),
                  ),
                  title: Text(
                    chat['fullName'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    chat['bio'], // Example: Using bio as the subtitle
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    chat['createdAt']?.split('T')[0] ?? 'Unknown Date', // Display only the date
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
        },
      ),
    );
  }
}

class ConversationSearchDelegate extends SearchDelegate {
  final IMessageService _messageService;
  final Logger _logger;

  ConversationSearchDelegate(this._logger, this._messageService);

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
    // Fetch filtered results based on the query
    return FutureBuilder<List<dynamic>>(
      future: _fetchFilteredChats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No results found."));
        } else {
          final results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final chat = results[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(chat['avatarPath']),
                ),
                title: Text(
                  chat['fullName'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  chat['bio'],
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  chat['createdAt']?.split('T')[0] ?? 'Unknown Date',
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
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggest results while typing
    return FutureBuilder<List<dynamic>>(
      future: _fetchFilteredChats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No suggestions available."));
        } else {
          final suggestions = snapshot.data!;
          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final chat = suggestions[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(chat['avatarPath']),
                ),
                title: Text(
                  chat['fullName'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  chat['bio'],
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  chat['createdAt']?.split('T')[0] ?? 'Unknown Date',
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
      },
    );
  }

  Future<List<dynamic>> _fetchFilteredChats() async {
    try {
      // Fetch recent chats from the service
      final response = await _messageService.getRecentChats(0, 100);
      _logger.i('_fetchFilteredChats: ${response}');
      // Filter chats based on the query
      return response['content']
          .where((chat) {
        final fullName = chat['fullName']?.toString().toLowerCase() ?? '';
        final bio = chat['bio']?.toString().toLowerCase() ?? '';
        return fullName.contains(query.toLowerCase()) ||
            bio.contains(query.toLowerCase());
      })
          .toList();
    } catch (error) {
      throw Exception("Failed to fetch filtered chats: $error");
    }
  }
}