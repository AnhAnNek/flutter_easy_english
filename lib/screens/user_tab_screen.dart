import 'package:flutter/material.dart';
import 'package:flutter_easy_english/screens/user_detail_screen.dart';
import 'package:flutter_easy_english/services/i_user_service.dart';
import 'package:provider/provider.dart';

class UserTabScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserTabScreen> {
  List<Map<String, dynamic>> users = [];
  String searchQuery = '';
  String? selectedRole;
  String? selectedStatus;
  bool isLoading = true;

  final List<String> roles = ['TEACHER', 'STUDENT'];
  final List<String> statuses = ['ACTIVE', 'INACTIVE'];

  @override
  void initState() {
    super.initState();
    fetchUsers();
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
          content: Text('$error'),
        ),
      );
    }
  }

  Future<void> addUser(Map<String, dynamic> newUser) async {
    try {
      final IUserService userService =
      Provider.of<IUserService>(context, listen: false);
      final addedUser = await userService.addUserForAdmin(newUser);
      setState(() {
        users.add(addedUser);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User ${newUser['username']} added successfully!'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding user: $error'),
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

  void showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) {
        // Fields for the new user
        String username = '';
        String password = '';
        String fullName = '';
        String email = '';
        String phoneNumber = '';
        String bio = '';
        String gender = 'MALE'; // Default gender
        DateTime? dob; // Date of birth
        String role = roles.first; // Default role
        String status = statuses.first; // Default status

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Add New User'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Username'),
                      onChanged: (value) => username = value,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onChanged: (value) => password = value,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Full Name'),
                      onChanged: (value) => fullName = value,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => email = value,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) => phoneNumber = value,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Bio'),
                      maxLines: 3,
                      onChanged: (value) => bio = value,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Gender'),
                      value: gender,
                      items: ['MALE', 'FEMALE', 'OTHER']
                          .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => gender = value);
                        }
                      },
                    ),
                    GestureDetector(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() => dob = pickedDate);
                        }
                      },
                      child: InputDecorator(
                        decoration:
                        const InputDecoration(labelText: 'Date of Birth'),
                        child: Text(
                          dob != null
                              ? '${dob!.day}/${dob!.month}/${dob!.year}'
                              : 'Select Date',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Role'),
                      value: role,
                      items: roles
                          .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => role = value);
                        }
                      },
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Status'),
                      value: status,
                      items: statuses
                          .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => status = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (username.isEmpty ||
                        password.isEmpty ||
                        fullName.isEmpty ||
                        email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill out all required fields'),
                        ),
                      );
                      return;
                    }

                    // Create the new user object
                    final newUser = {
                      'username': username,
                      'password': password,
                      'fullName': fullName,
                      'email': email,
                      'phoneNumber': phoneNumber,
                      'bio': bio,
                      'gender': gender,
                      'dob': dob?.toIso8601String() ?? '',
                      'role': role,
                      'status': status,
                    };

                    // Add the new user
                    addUser(newUser);
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  searchQuery = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
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
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
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
                      backgroundImage: user['avatarPath'] != null &&
                          user['avatarPath'].isNotEmpty
                          ? NetworkImage(user['avatarPath'])
                          : NetworkImage(
                        'https://api.dicebear.com/6.x/initials/png?seed=${user['username']}',
                      ),
                      radius: 25,
                    ),
                    title: Text(
                      '${user['fullName']}', // Example with a Unicode emoji
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                        'Email: ${user['email']}\nRole: ${user['role']}\nStatus: ${user['status']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete,
                          color: Colors.red),
                      onPressed: () =>
                          deleteUser(user['username']),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserDetailScreen(user: user),
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
      floatingActionButton: FloatingActionButton(
        onPressed: showAddUserDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}