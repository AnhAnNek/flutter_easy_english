import 'package:flutter/material.dart';
import 'package:flutter_easy_english/screens/user_detail_screen.dart';
import 'package:flutter_easy_english/services/i_user_service.dart';
import 'package:provider/provider.dart';

class UserTabScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserTabScreen> {
  List<Map<String, dynamic>> users = []; // List to hold user data
  String searchQuery = ''; // Search keyword
  String? selectedRole; // Selected role filter
  String? selectedStatus; // Selected status filter
  bool isLoading = true; // Loading state

  final List<String> roles = ['ADMIN', 'TEACHER', 'STUDENT']; // Role options
  final List<String> statuses = ['ACTIVE', 'INACTIVE', 'DELETED']; // Status options

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Fetch users on widget initialization
  }

  Future<void> fetchUsers() async {
    try {
      final IUserService userService =
      Provider.of<IUserService>(context, listen: false);

      final response = await userService.getUsersWithoutAdmin({
        'page': 0,
        'size': 1000,
      });
      setState(() {
        users = response['content']?.cast<Map<String, dynamic>>() ?? [];
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching users: $error'),
        ),
      );
    }
  }

  Future<void> deleteUser(String username) async {
    try {
      final IUserService userService =
      Provider.of<IUserService>(context, listen: false);

      await userService.deleteUserForAdmin(username);
      setState(() {
        users.removeWhere((user) => user['username'] == username);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$username removed successfully!'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting user: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter user list based on search query, role, and status
    List<Map<String, dynamic>> filteredUsers = users.where((user) {
      final matchesSearch = searchQuery.isEmpty ||
          user['fullName']
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          user['email'].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesRole = selectedRole == null ||
          user['role'].toUpperCase() == selectedRole;
      final matchesStatus = selectedStatus == null ||
          user['status'].toUpperCase() == selectedStatus;

      return matchesSearch && matchesRole && matchesStatus;
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Users',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Update search query
                });
              },
            ),
          ),
          // Filter dropdowns
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Role filter
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Filter by Role',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    value: selectedRole,
                    items: [null, ...roles]
                        .map((role) => DropdownMenuItem<String>(
                      value: role,
                      child: Text(role ?? 'All Roles'),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                // Status filter
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Filter by Status',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    value: selectedStatus,
                    items: [null, ...statuses]
                        .map((status) => DropdownMenuItem<String>(
                      value: status,
                      child: Text(status ?? 'All Statuses'),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // User list
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(), // Show loader
            )
                : filteredUsers.isEmpty
                ? const Center(
              child: Text(
                'No users found!',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
                : ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  elevation: 2.0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user['avatarPath'] != null
                          ? NetworkImage(user['avatarPath'])
                          : NetworkImage(
                            'https://api.dicebear.com/6.x/initials/png?seed=${user['username']}',
                          ),
                      radius: 25,
                    ),
                    title: Text(
                      user['fullName'],
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'Email: ${user['email']}\nRole: ${user['role']}\nStatus: ${user['status']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete,
                          color: Colors.red),
                      onPressed: () => deleteUser(user['username']),
                    ),
                    onTap: () {
                      // Navigate to user detail screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailScreen(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}