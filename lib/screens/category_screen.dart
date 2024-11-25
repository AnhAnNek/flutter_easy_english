import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // Dữ liệu giả cho danh sách category
  List<Map<String, dynamic>> categories = [
    {'id': 1, 'name': 'Science'},
    {'id': 2, 'name': 'Technology'},
    {'id': 3, 'name': 'Engineering'},
    {'id': 4, 'name': 'Mathematics'},
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách category dựa trên từ khóa tìm kiếm
    List<Map<String, dynamic>> filteredCategories = categories.where((category) {
      return category['name']
          .toLowerCase()
          .contains(searchQuery.toLowerCase()); // Lọc theo tên
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddEditDialog(), // Thêm mới category
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
                labelText: 'Search Categories',
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
          // Danh sách Category
          Expanded(
            child: filteredCategories.isEmpty
                ? const Center(
              child: Text(
                'No categories found!',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
                : ListView.builder(
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  elevation: 2.0,
                  child: ListTile(
                    title: Text(category['name']),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Edit') {
                          _showAddEditDialog(category: category);
                        } else if (value == 'Delete') {
                          _showDeleteConfirmationDialog(
                              category['id'], category['name']);
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
              _deleteCategory(id, name);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(int id, String name) {
    setState(() {
      categories.removeWhere((category) => category['id'] == id);
    });

    // Hiển thị Snackbar thông báo thành công
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Category "$name" deleted successfully!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAddEditDialog({Map<String, dynamic>? category}) {
    final TextEditingController nameController =
    TextEditingController(text: category != null ? category['name'] : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(category == null ? 'Add Category' : 'Edit Category'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Category Name',
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
                    if (category == null) {
                      // Thêm mới category
                      categories.add({
                        'id': categories.length + 1,
                        'name': name,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Category "$name" added successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      // Cập nhật category
                      category['name'] = name;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Category "$name" updated successfully!'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(category == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }
}
