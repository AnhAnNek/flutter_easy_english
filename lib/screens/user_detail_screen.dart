import 'package:flutter/material.dart';

class UserDetailScreen extends StatefulWidget {
  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  // Dữ liệu giả cho user
  Map<String, dynamic> user = {
    'avatarPath': 'http://10.147.20.214:9000/easy-english/image/course2.jpg',
    'username': 'john_doe',
    'password': 'password123',
    'fullName': 'John Doe',
    'email': 'johndoe@example.com',
    'phoneNumber': '+123456789',
    'bio': 'Passionate software engineer and tech enthusiast.',
    'gender': 'Male',
    'dob': DateTime(1990, 1, 1),
    'role': 'Admin',
  };

  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> roles = ['Admin', 'User', 'Guest'];

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: user['dob'],
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != user['dob']) {
      setState(() {
        user['dob'] = picked;
      });
    }
  }

  void _saveUserDetails() {
    print('User details saved: $user');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User details saved successfully!'),
      ),
    );
  }

  OutlineInputBorder _buildRoundedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.grey),
    );
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
                backgroundImage: NetworkImage(user['avatarPath']),
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
                  '${user['dob'].day}/${user['dob'].month}/${user['dob'].year}',
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
