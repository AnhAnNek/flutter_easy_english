import 'package:flutter/material.dart';
import 'package:flutter_easy_english/services/i_auth_service.dart';
import 'package:provider/provider.dart';
import '../models/register_request.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  void _register() async {
    final authService = Provider.of<IAuthService>(context, listen: false);
    try {
      final registerRequest = RegisterRequest(
        username: _emailController.text,
        password: _passwordController.text,
        fullName: _nameController.text,
        email: _emailController.text,
        phoneNumber: '', // Add a field or handle phone number if necessary
        gender: 'MALE',  // Adjust according to actual gender selection
        dob: DateTime.now(), // Handle date of birth as needed
      );
      await authService.register(registerRequest);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration successful")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}