import 'package:flutter/material.dart';
import 'package:flutter_easy_english/models/login_request.dart';
import 'package:flutter_easy_english/models/login_response.dart';
import 'package:flutter_easy_english/screens/forgot_password_screen.dart';
import 'package:flutter_easy_english/screens/index_screen.dart';
import 'package:flutter_easy_english/screens/register_screen.dart';
import 'package:flutter_easy_english/services/i_auth_service.dart';
import 'package:flutter_easy_english/utils/auth_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
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

  @override
  void initState() {
    super.initState();
    _checkLoggedInStatus();
  }

  void _checkLoggedInStatus() async {
    bool isLoggedIn = await AuthUtils.isLoggedIn();
    if (isLoggedIn) {
      // If already logged in, navigate to HomeScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => IndexScreen()),
      );
    }
  }

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

        // Show a success toast
        Fluttertoast.showToast(
          msg: "Login successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        // Navigate to the HomeScreen on successful login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => IndexScreen()),
        );
      } catch (e) {
        logger.e('Login failed with error: $e');

        // Show an error toast
        Fluttertoast.showToast(
          msg: "Login failed. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }

      setState(() {
        _isLoading = false;
      });
    } else {
      logger.w('Login form validation failed');

      // Show a toast for validation failure
      Fluttertoast.showToast(
        msg: "Please fill in all required fields.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
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
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text('Register?'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                    );
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
