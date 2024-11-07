import 'package:flutter/material.dart';
import 'package:flutter_easy_english/models/reset_pass_with_otp_req.dart';
import 'package:flutter_easy_english/screens/login_screen.dart';
import 'package:flutter_easy_english/services/i_auth_service.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isOtpSent = false;

  // Method to generate OTP using AuthService
  Future<void> generateOtpToResetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showMessage("Please enter your email");
      return;
    }

    try {
      IAuthService authService = Provider.of<IAuthService>(context, listen: false);
      final message = await authService.generateOtpToResetPassword(email);
      _showMessage(message);
      setState(() {
        isOtpSent = true; // Enable OTP input and new password fields
      });
    } catch (e) {
      _showMessage("Error generating OTP: ${e.toString()}");
    }
  }

  // Method to reset password with OTP using AuthService
  Future<void> resetPasswordWithOtp() async {
    final otp = _otpController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (otp.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showMessage("Please fill in all fields");
      return;
    }
    if (newPassword != confirmPassword) {
      _showMessage("Passwords do not match");
      return;
    }

    final req = ResetPassWithOtpReq(
      email: _emailController.text.trim(),
      otp: otp,
      newPassword: newPassword,
    );

    try {
      IAuthService authService = Provider.of<IAuthService>(context, listen: false);
      await authService.resetPasswordWithOtp(req);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      _showMessage("Error resetting password: ${e.toString()}");
    }
  }

  // Helper method to show messages
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: generateOtpToResetPassword,
              child: Text("Generate OTP"),
            ),
            if (isOtpSent) ...[
              SizedBox(height: 20),
              TextField(
                controller: _otpController,
                decoration: InputDecoration(labelText: "OTP"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: "New Password"),
                obscureText: true,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: "Confirm Password"),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: resetPasswordWithOtp,
                child: Text("Reset Password"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
