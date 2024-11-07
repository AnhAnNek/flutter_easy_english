import 'package:flutter/material.dart';
import 'package:flutter_easy_english/models/login_request.dart';
import 'package:flutter_easy_english/models/login_response.dart';
import 'package:logger/logger.dart';
import 'package:flutter_easy_english/services/i_auth_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final logger = Logger();

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      logger.d('Login attempt: ${_usernameController.text}');
      LoginRequest loginRequest = LoginRequest(
        usernameOrEmail: _usernameController.text,
        password: _passwordController.text,
      );

      try {
        IAuthService authService = Provider.of<IAuthService>(context, listen: false);

        logger.i('Sending login request for ${loginRequest.usernameOrEmail}');
        LoginResponse response = await authService.login(loginRequest);
        logger.i('Login successful: ${response.toString()}');
      } catch (e) {
        logger.e('Login failed with error: $e');
      }

      setState(() {
        _isLoading = false;
      });
    } else {
      logger.w('Login form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username or Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username or email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgot-password');
                  },
                  child: Text('Forgot your password?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}