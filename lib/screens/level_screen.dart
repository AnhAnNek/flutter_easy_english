import 'package:flutter/material.dart';

class LevelScreen extends StatefulWidget {
  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  // Dữ liệu giả cho danh sách topic
  final List<Map<String, dynamic>> topics = [
    {'id': 1, 'name': 'Mathematics'},
    {'id': 2, 'name': 'Physics'},
    {'id': 3, 'name': 'Chemistry'},
  ];

  // Dữ liệu giả cho danh sách level
  List<Map<String, dynamic>> levels = [
    {'id': 1, 'name': 'Basic Algebra', 'topicId': 1},
    {'id': 2, 'name': 'Calculus', 'topicId': 1},
    {'id': 3, 'name': 'Mechanics', 'topicId': 2},
    {'id': 4, 'name': 'Thermodynamics', 'topicId': 2},
    {'id': 5, 'name': 'Organic Chemistry', 'topicId': 3},
    {'id': 6, 'name': 'Inorganic Chemistry', 'topicId': 3},
  ];

  String searchQuery = '';
  int? selectedTopicId; // ID topic được chọn
  int _idCounter = 7; // Biến đếm để tạo ID duy nhất cho level

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách level dựa trên từ khóa tìm kiếm và topic được chọn
    List<Map<String, dynamic>> filteredLevels = levels.where((level) {
      final matchesSearch = level['name']
          .toLowerCase()
          .contains(searchQuery.toLowerCase()); // Lọc theo tên
      final matchesTopic = selectedTopicId == null ||
          level['topicId'] == selectedTopicId; // Lọc theo topic
      return matchesSearch && matchesTopic;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Levels'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddEditDialog(), // Thêm mới level
          ),
        ],
      ),
      body: Column(
        children: [
          // Dropdown chọn Topic
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<int>(
              value: selectedTopicId,
              hint: const Text('Select Topic'),
              isExpanded: true,
              items: [
                const DropdownMenuItem<int>(
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
                  selectedTopicId = value; // Cập nhật topic được chọn
                });
              },
            ),
          ),
          // Thanh tìm kiếm
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
                  searchQuery = value; // Cập nhật từ khóa tìm kiếm
                });
              },
            ),
          ),
          // Danh sách Level
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
                final topicName = topics
                    .firstWhere(
                        (topic) => topic['id'] == level['topicId'])['name']
                    .toString();
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  elevation: 2.0,
                  child: ListTile(
                    title: Text(level['name']),
                    subtitle: Text('Topic: $topicName'),
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

  void _deleteLevel(int id, String name) {
    setState(() {
      levels.removeWhere((level) => level['id'] == id);
    });

    // Hiển thị Snackbar thông báo thành công
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Level "$name" deleted successfully!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAddEditDialog({Map<String, dynamic>? level}) {
    final TextEditingController nameController =
    TextEditingController(text: level != null ? level['name'] : '');
    int? selectedTopic = level != null ? level['topicId'] : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(level == null ? 'Add Level' : 'Edit Level'),
          content: Column(
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty && selectedTopic != null) {
                  setState(() {
                    if (level == null) {
                      // Thêm mới level
                      levels.add({
                        'id': _idCounter++,
                        'name': name,
                        'topicId': selectedTopic,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Level "$name" added successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      // Cập nhật level
                      level['name'] = name;
                      level['topicId'] = selectedTopic;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Level "$name" updated successfully!'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    }
                  });
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
}
