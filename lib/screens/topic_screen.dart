import 'package:flutter/material.dart';
import 'package:flutter_easy_english/services/i_topic_service.dart';
import 'package:flutter_easy_english/utils/toast_utils.dart';
import 'package:provider/provider.dart';

class TopicScreen extends StatefulWidget {
  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  List<Map<String, dynamic>> topics = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  Future<void> _fetchTopics() async {
    setState(() => isLoading = true);

    try {
      final ITopicService topicService =
      Provider.of<ITopicService>(context, listen: false);

      final fetchedTopics = await topicService.fetchAllTopics();
      setState(() {
        topics = List<Map<String, dynamic>>.from(fetchedTopics);
      });
    } catch (error) {
      ToastUtils.showError('Failed to fetch topics: $error');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteTopic(int id, String name) async {
    try {
      final ITopicService topicService =
      Provider.of<ITopicService>(context, listen: false);

      await topicService.deleteTopic(id);
      setState(() {
        topics.removeWhere((topic) => topic['id'] == id);
      });

      ToastUtils.showSuccess('Topic "$name" deleted successfully!');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete topic: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addOrUpdateTopic({
    Map<String, dynamic>? topic,
    required String name,
  }) async {
    try {
      final ITopicService topicService =
      Provider.of<ITopicService>(context, listen: false);

      if (topic == null) {
        // Add new topic
        final newTopic = await topicService.createTopic({'name': name});
        setState(() {
          topics.add(newTopic);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Topic "$name" added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Update existing topic
        await topicService.updateTopic(topic['id'], {'name': name});
        setState(() {
          topic['name'] = name;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Topic "$name" updated successfully!'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save topic: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteConfirmationDialog(int id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTopic(id, name);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddEditDialog({Map<String, dynamic>? topic}) {
    final TextEditingController nameController =
    TextEditingController(text: topic != null ? topic['name'] : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(topic == null ? 'Add Topic' : 'Edit Topic'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Topic Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  Navigator.pop(context);
                  _addOrUpdateTopic(topic: topic, name: name);
                }
              },
              child: Text(topic == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter topics based on the search query
    final filteredTopics = topics.where((topic) {
      return topic['name']
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Topics'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchTopics, // Refresh the topic list
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Topics',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          // Topic list
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredTopics.isEmpty
                ? const Center(
              child: Text(
                'No topics found!',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
                : ListView.builder(
              itemCount: filteredTopics.length,
              itemBuilder: (context, index) {
                final topic = filteredTopics[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  elevation: 2.0,
                  child: ListTile(
                    title: Text(topic['name']),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Edit') {
                          _showAddEditDialog(topic: topic);
                        } else if (value == 'Delete') {
                          _showDeleteConfirmationDialog(
                              topic['id'], topic['name']);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'Edit',
                          child: Text('Edit'),
                        ),
                        PopupMenuItem(
                          value: 'Delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}