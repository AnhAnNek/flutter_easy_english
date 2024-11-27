import 'package:flutter/material.dart';
import 'package:flutter_easy_english/services/i_category_service.dart';
import 'package:flutter_easy_english/utils/toast_utils.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, dynamic>> categories = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() => isLoading = true);

    try {
      final ICategoryService categoryService =
      Provider.of<ICategoryService>(context, listen: false);

      final fetchedCategories = await categoryService.fetchAllCategories();
      setState(() {
        categories = List<Map<String, dynamic>>.from(fetchedCategories);
      });
    } catch (error) {
      ToastUtils.showError('Failed to fetch categories: $error');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteCategory(int id, String name) async {
    try {
      final ICategoryService categoryService =
      Provider.of<ICategoryService>(context, listen: false);

      await categoryService.deleteCategory(id);
      setState(() {
        categories.removeWhere((category) => category['id'] == id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category "$name" deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete category: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addOrUpdateCategory({
    Map<String, dynamic>? category,
    required String name,
  }) async {
    try {
      final ICategoryService categoryService =
      Provider.of<ICategoryService>(context, listen: false);

      if (category == null) {
        // Add new category
        final newCategory = await categoryService.createCategory({'name': name});
        setState(() {
          categories.add(newCategory);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category "$name" added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Update existing category
        await categoryService.updateCategory(category['id'], {'name': name});
        setState(() {
          category['name'] = name;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category "$name" updated successfully!'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save category: $error'),
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
              _deleteCategory(id, name);
            },
            child: Text('Delete'),
          ),
        ],
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
                  Navigator.pop(context);
                  _addOrUpdateCategory(category: category, name: name);
                }
              },
              child: Text(category == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter categories based on the search query
    final filteredCategories = categories.where((category) {
      return category['name']
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchCategories, // Refresh the category list
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
                labelText: 'Search Categories',
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
          // Category list
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredCategories.isEmpty
                ? const Center(
              child: Text(
                'No categories found!',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
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
}