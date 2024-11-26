import 'package:flutter/material.dart';
import 'package:flutter_easy_english/services/i_level_service.dart';
import 'package:flutter_easy_english/services/i_topic_service.dart';
import 'package:provider/provider.dart';

class LevelScreen extends StatefulWidget {
  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  List<Map<String, dynamic>> topics =
      []; // List for topics fetched from the API
  List<Map<String, dynamic>> levels =
      []; // List for levels fetched from the API

  String searchQuery = ''; // Search query for filtering levels
  int? selectedTopicId; // ID of the selected topic

  @override
  void initState() {
    super.initState();
    _fetchInitialData(); // Fetch initial data for topics and levels
  }

  // Fetch initial data for both topics and levels
  void _fetchInitialData() async {
    try {
      final ILevelService levelService =
          Provider.of<ILevelService>(context, listen: false);
      final ITopicService topicService =
          Provider.of<ITopicService>(context, listen: false);

      // Fetch all topics and levels
      final topicData = await topicService.fetchAllTopic();
      final levelData = await levelService.fetchAllLevels();

      setState(() {
        topics = List<Map<String, dynamic>>.from(topicData);
        levels = List<Map<String, dynamic>>.from(levelData);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $error')),
      );
    }
  }

  // Fetch levels filtered by topic
  void _fetchLevelsByTopic(int? topicId) async {
    try {
      final ILevelService levelService =
          Provider.of<ILevelService>(context, listen: false);

      final levelData = topicId == null
          ? await levelService.fetchAllLevels()
          : await levelService.fetchAllLevelByTopic(topicId);

      setState(() {
        levels = List<Map<String, dynamic>>.from(levelData);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load levels: $error')),
      );
    }
  }

  // Add a new level via the API
  void _addLevel(
      String name, int topicId, String fromLevel, String toLevel) async {
    try {
      final ILevelService levelService =
          Provider.of<ILevelService>(context, listen: false);

      final newLevel = await levelService.createLevel({
        'name': name,
        'topicId': topicId,
        'fromLevel': fromLevel,
        'toLevel': toLevel,
      });

      setState(() {
        levels.add(newLevel);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Level "$name" added successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add level: $error')),
      );
    }
  }

  // Update a level via the API
  void _updateLevel(int id, String name, int topicId, String fromLevel,
      String toLevel) async {
    try {
      final ILevelService levelService =
          Provider.of<ILevelService>(context, listen: false);

      final updatedLevel = await levelService.updateLevel(id, {
        'name': name,
        'topicId': topicId,
        'fromLevel': fromLevel,
        'toLevel': toLevel,
      });

      setState(() {
        final index = levels.indexWhere((level) => level['id'] == id);
        if (index >= 0) {
          levels[index] = updatedLevel;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Level "$name" updated successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update level: $error')),
      );
    }
  }

  // Delete a level via the API
  void _deleteLevel(int id, String name) async {
    try {
      final ILevelService levelService =
          Provider.of<ILevelService>(context, listen: false);

      await levelService.deleteLevel(id);

      setState(() {
        levels.removeWhere((level) => level['id'] == id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Level "$name" deleted successfully!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete level: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter levels based on search query and selected topic
    List<Map<String, dynamic>> filteredLevels = levels.where((level) {
      final matchesSearch =
          level['name'].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesTopic =
          selectedTopicId == null || level['topicId'] == selectedTopicId;
      return matchesSearch && matchesTopic;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Levels'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Refresh the data
              _fetchInitialData();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Dropdown to select a topic
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<int>(
              value: selectedTopicId,
              hint: const Text('Select Topic'),
              isExpanded: true,
              items: [
                DropdownMenuItem<int>(
                  value: null,
                  child: Text('All Topics'),
                ),
                ...topics.map((topic) {
                  return DropdownMenuItem<int>(
                    value: topic['id'],
                    child: Text(topic['name']),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                setState(() {
                  selectedTopicId = value;
                  _fetchLevelsByTopic(value);
                });
              },
            ),
          ),
          // Search bar to filter levels
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Levels',
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
          // List of levels
          Expanded(
            child: filteredLevels.isEmpty
                ? const Center(
                    child: Text(
                      'No levels found!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredLevels.length,
                    itemBuilder: (context, index) {
                      final level = filteredLevels[index];

                      // Use `orElse` to avoid "Bad state: No element" error
                      final topicName = level['topic']['name'];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        elevation: 2.0,
                        child: ListTile(
                          title: Text(level['name']),
                          subtitle: Text(
                              'Topic: $topicName\nFrom: ${level['fromLevel']}\nTo: ${level['toLevel']}'),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'Edit') {
                                _showAddEditDialog(level: level);
                              } else if (value == 'Delete') {
                                _showDeleteConfirmationDialog(
                                    level['id'], level['name']);
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

  // Show a dialog for adding or editing a level
  void _showAddEditDialog({Map<String, dynamic>? level}) {
    final TextEditingController nameController =
        TextEditingController(text: level != null ? level['name'] : '');
    final TextEditingController fromLevelController =
        TextEditingController(text: level != null ? level['fromLevel'] : '');
    final TextEditingController toLevelController =
        TextEditingController(text: level != null ? level['toLevel'] : '');
    int? selectedTopic = level != null ? level['topicId'] : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(level == null ? 'Add Level' : 'Edit Level'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Level Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: fromLevelController,
                  decoration: InputDecoration(
                    labelText: 'From Level',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: toLevelController,
                  decoration: InputDecoration(
                    labelText: 'To Level',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<int>(
                  value: selectedTopic,
                  hint: Text('Select Topic'),
                  isExpanded: true,
                  items: topics.map((topic) {
                    return DropdownMenuItem<int>(
                      value: topic['id'],
                      child: Text(topic['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedTopic = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
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
                final fromLevel = fromLevelController.text.trim();
                final toLevel = toLevelController.text.trim();
                if (name.isNotEmpty &&
                    selectedTopic != null &&
                    fromLevel.isNotEmpty &&
                    toLevel.isNotEmpty) {
                  if (level == null) {
                    _addLevel(name, selectedTopic!, fromLevel, toLevel);
                  } else {
                    _updateLevel(
                        level['id'], name, selectedTopic!, fromLevel, toLevel);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(level == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  // Show a confirmation dialog for deleting a level
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
              _deleteLevel(id, name);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
