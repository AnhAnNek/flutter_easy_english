import 'package:flutter/material.dart';
import 'package:flutter_easy_english/screens/user_detail_screen.dart';

class UserTabScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserTabScreen> {
  // Dữ liệu giả cho danh sách người dùng
  List<Map<String, dynamic>> users = [
    {
      'avatarPath': 'http://10.147.20.214:9000/easy-english/image/course2.jpg',
      'fullName': 'John Doe',
      'email': 'johndoe@example.com',
      'role': 'Teacher',
    },
    {
      'avatarPath': 'http://10.147.20.214:9000/easy-english/image/course2.jpg',
      'fullName': 'Jane Smith',
      'email': 'janesmith@example.com',
      'role': 'Student',
    },
    {
      'avatarPath': 'http://10.147.20.214:9000/easy-english/image/course2.jpg',
      'fullName': 'Alice Johnson',
      'email': 'alicejohnson@example.com',
      'role': 'Teacher',
    },
    {
      'avatarPath': 'http://10.147.20.214:9000/easy-english/image/course2.jpg',
      'fullName': 'Bob Williams',
      'email': 'bobwilliams@example.com',
      'role': 'Student',
    },
  ];

  // Biến để lưu trữ tìm kiếm
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách người dùng theo từ khóa tìm kiếm
    List<Map<String, dynamic>> filteredUsers = users
        .where((user) =>
    user['fullName'].toLowerCase().contains(searchQuery.toLowerCase()) ||
        user['email'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(

      body: Column(
        children: [
          // Thanh tìm kiếm
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
                  searchQuery = value; // Cập nhật từ khóa tìm kiếm
                });
              },
            ),
          ),
          // Danh sách người dùng
          Expanded(
            child: filteredUsers.isEmpty
                ? const Center(
              child: Text(
                'No users found!',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      backgroundImage: NetworkImage(user['avatarPath']),
                      radius: 25,
                    ),
                    title: Text(
                      user['fullName'],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'Email: ${user['email']}\nRole: ${user['role']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          users.remove(user); // Xóa người dùng khỏi danh sách
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${user['fullName']} removed!'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      // Điều hướng đến màn hình chi tiết
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