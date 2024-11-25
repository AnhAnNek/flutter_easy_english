import 'package:flutter/material.dart';

class TopicScreen extends StatefulWidget {
  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  // Dữ liệu giả cho danh sách topic
  List<Map<String, dynamic>> topics = [
    {'id': 1, 'name': 'Mathematics'},
    {'id': 2, 'name': 'Physics'},
    {'id': 3, 'name': 'Chemistry'},
    {'id': 4, 'name': 'Biology'},
  ];

  int _idCounter = 5; // Biến đếm để tạo ID duy nhất (khởi tạo lớn hơn ID cuối cùng)

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách topic dựa trên từ khóa tìm kiếm
    List<Map<String, dynamic>> filteredTopics = topics.where((topic) {
      return topic['name']
          .toLowerCase()
          .contains(searchQuery.toLowerCase()); // Lọc theo tên
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Topics'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddEditDialog(), // Thêm mới topic
          ),
        ],
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
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
                  searchQuery = value; // Cập nhật từ khóa tìm kiếm
                });
              },
            ),
          ),
          // Danh sách Topic
          Expanded(
            child: filteredTopics.isEmpty
                ? const Center(
              child: Text(
                'No topics found!',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  void _deleteTopic(int id, String name) {
    setState(() {
      topics.removeWhere((topic) => topic['id'] == id);
    });

    // Hiển thị Snackbar thông báo thành công
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Topic "$name" deleted successfully!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
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
                  setState(() {
                    if (topic == null) {
                      // Thêm mới topic với ID duy nhất từ _idCounter
                      topics.add({
                        'id': _idCounter++,
                        'name': name,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Topic "$name" added successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      // Cập nhật topic
                      topic['name'] = name;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Topic "$name" updated successfully!'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(topic == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }
}
