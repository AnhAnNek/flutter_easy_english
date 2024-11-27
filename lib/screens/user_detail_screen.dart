import 'package:flutter/material.dart';
import 'package:flutter_easy_english/services/i_user_service.dart';
import 'package:provider/provider.dart';

class UserDetailScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  UserDetailScreen({required this.user});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late String? _username;

  // Dữ liệu giả cho user
  late Map<String, dynamic> user = {
    'avatarPath': 'http://10.147.20.214:9000/easy-english/image/course2.jpg',
    'username': 'john_doe',
    'password': 'password123',
    'fullName': 'John Doe',
    'email': 'johndoe@example.com',
    'phoneNumber': '+123456789',
    'bio': 'Passionate software engineer and tech enthusiast.',
    'gender': 'MALE',
    'dob': DateTime(1990, 1, 1),
    'role': 'ADMIN',
    'status': 'ACTIVE', // Added status field
  };

  final List<String> genders = ['MALE', 'FEMALE', 'OTHER'];
  final List<String> roles = ['TEACHER', 'STUDENT'];
  final List<String> statuses = ['ACTIVE', 'INACTIVE', 'SUSPENDED']; // Status options

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = user['dob'] is String
        ? DateTime.parse(user['dob'])
        : user['dob'];

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        user['dob'] = picked;
      });
    }
  }

  void _saveUserDetails() async {
    final username = _username;
    final userForAdminReq = user;

    final IUserService userService =
    Provider.of<IUserService>(context, listen: false);

    try {
      await userService.updateUserForAdmin(username, userForAdminReq);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User updated successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
        ),
      );
    }
  }

  OutlineInputBorder _buildRoundedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.grey),
    );
  }

  @override
  void initState() {
    super.initState();
    user = widget.user;
    _username = widget.user['username'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: user['avatarPath'] != null &&
                    user['avatarPath'].isNotEmpty
                    ? NetworkImage(user['avatarPath'])
                    : NetworkImage(
                  'https://api.dicebear.com/6.x/initials/png?seed=${user['username']}',
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user['username'],
              decoration: InputDecoration(
                labelText: 'Username',
                border: _buildRoundedBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  user['username'] = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user['password'],
              decoration: InputDecoration(
                labelText: 'Password',
                border: _buildRoundedBorder(),
              ),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  user['password'] = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user['fullName'],
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: _buildRoundedBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  user['fullName'] = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user['email'],
              decoration: InputDecoration(
                labelText: 'Email',
                border: _buildRoundedBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Enter a valid email';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  user['email'] = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user['phoneNumber'],
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: _buildRoundedBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  user['phoneNumber'] = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user['bio'],
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Bio',
                border: _buildRoundedBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  user['bio'] = value;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: user['gender'],
              decoration: InputDecoration(
                labelText: 'Gender',
                border: _buildRoundedBorder(),
              ),
              items: genders
                  .map((gender) => DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  user['gender'] = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  border: _buildRoundedBorder(),
                ),
                child: Text(
                  user['dob'] is String
                      ? '${DateTime.parse(user['dob']).day}/${DateTime.parse(user['dob']).month}/${DateTime.parse(user['dob']).year}'
                      : '${user['dob'].day}/${user['dob'].month}/${user['dob'].year}',
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: user['role'],
              decoration: InputDecoration(
                labelText: 'Role',
                border: _buildRoundedBorder(),
              ),
              items: roles
                  .map((role) => DropdownMenuItem<String>(
                value: role,
                child: Text(role),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  user['role'] = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: user['status'], // Added status field
              decoration: InputDecoration(
                labelText: 'Status',
                border: _buildRoundedBorder(),
              ),
              items: statuses
                  .map((status) => DropdownMenuItem<String>(
                value: status,
                child: Text(status),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  user['status'] = value!;
                });
              },
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _saveUserDetails,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}