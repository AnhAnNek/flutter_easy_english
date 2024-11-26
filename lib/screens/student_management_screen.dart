import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StudentManagementScreen extends HookWidget {
  final String courseId;

  StudentManagementScreen({required this.courseId});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final students = useState<List<Map<String, dynamic>>>([
      {
        'username': 'john_doe',
        'fullName': 'John Doe',
        'avatarPath': 'http://10.147.20.214:9000/easy-english/image/course2.jpg',
        'status': 'ACTIVE',
      },
      {
        'username': 'jane_smith',
        'fullName': 'Jane Smith',
        'avatarPath': 'http://10.147.20.214:9000/easy-english/image/course2.jpg',
        'status': 'CANCELLED',
      },
      {
        'username': 'alice_wong',
        'fullName': 'Alice Wong',
        'avatarPath': 'http://10.147.20.214:9000/easy-english/image/course2.jpg',
        'status': 'ACTIVE',
      },
    ]);

    final searchText = useState<String>('');

    // Filter students based on search text
    final filteredStudents = students.value
        .where((student) =>
    student['fullName']
        .toLowerCase()
        .contains(searchText.value.toLowerCase()) ||
        student['username']
            .toLowerCase()
            .contains(searchText.value.toLowerCase()))
        .toList();

    // Mock user data to add
    final allUsers = [
      {
        'username': 'emma_brown',
        'fullName': 'Emma Brown',
        'avatarPath': 'http://10.147.20.214:9000/easy-english/image/course2.jpg',
      },
      {
        'username': 'david_jones',
        'fullName': 'David Jones',
        'avatarPath': 'http://10.147.20.214:9000/easy-english/image/course2.jpg',
      },
      {
        'username': 'sophia_miller',
        'fullName': 'Sophia Miller',
        'avatarPath': 'http://10.147.20.214:9000/easy-english/image/course2.jpg',
      },
    ];

    void showAddUserDialog() {
      final selectedUsers = <String>{};
      String searchDialogText = '';

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              final filteredUsers = allUsers
                  .where((user) =>
              user['fullName']!
                  .toLowerCase()
                  .contains(searchDialogText.toLowerCase()) ||
                  user['username']!
                      .toLowerCase()
                      .contains(searchDialogText.toLowerCase()))
                  .toList();

              return AlertDialog(
                title: Text('Add Students'),
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by name or username',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchDialogText = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            final isSelected =
                            selectedUsers.contains(user['username']);

                            return CheckboxListTile(
                              value: isSelected,
                              title: Text(user['fullName']!),
                              subtitle: Text('@${user['username']}'),
                              secondary: CircleAvatar(
                                backgroundImage:
                                NetworkImage(user['avatarPath']!),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    selectedUsers.add(user['username']!);
                                  } else {
                                    selectedUsers.remove(user['username']);
                                  }
                                });
                              },
                            );
                          },
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
                  ElevatedButton(
                    onPressed: () {
                      final selectedUserDetails = allUsers
                          .where((user) =>
                          selectedUsers.contains(user['username']))
                          .map((user) => {
                        'username': user['username'],
                        'fullName': user['fullName'],
                        'avatarPath': user['avatarPath'],
                        'status': 'ACTIVE',
                      })
                          .toList();

                      students.value = [
                        ...students.value,
                        ...selectedUserDetails,
                      ];

                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Student Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or username',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                searchText.value = value;
              },
            ),
            const SizedBox(height: 16.0),
            // Student List
            Expanded(
              child: ListView.builder(
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = filteredStudents[index];
                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(student['avatarPath']),
                      ),
                      title: Text(student['fullName']),
                      subtitle: Text('@${student['username']}'),
                      trailing: DropdownButton<String>(
                        value: student['status'],
                        items: ['ACTIVE', 'CANCELLED']
                            .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                            .toList(),
                        onChanged: (newStatus) async {
                          if (newStatus != null) {
                            final shouldChange = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Confirm Change'),
                                content: Text(
                                    'Are you sure you want to change status to $newStatus?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text('Confirm'),
                                  ),
                                ],
                              ),
                            ) ??
                                false;

                            if (shouldChange) {
                              students.value = List<Map<String, dynamic>>.from(
                                students.value.map((s) {
                                  if (s['username'] == student['username']) {
                                    return {...s, 'status': newStatus};
                                  }
                                  return s;
                                }),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Status changed to $newStatus successfully!'),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddUserDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
