import 'package:flutter/material.dart';
import 'package:flutter_easy_english/models/active_account_response.dart';
import 'package:flutter_easy_english/models/otp_request.dart';
import 'package:flutter_easy_english/services/auth_service.dart';

import 'login_screen.dart';

class OtpScreen extends StatefulWidget {
  final String username;

  OtpScreen({required this.username});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  void _activateAccount() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      OtpRequest otpRequest = OtpRequest(
        username: widget.username,
        otp: _otpController.text,
      );

      try {
        ActiveAccountResponse a = await AuthService().activateAccount(otpRequest);
        print(a);
        // Hiển thị thông báo thành công và chuyển về trang đăng nhập
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account activated successfully!')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } catch (e) {
        // Xử lý lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error activating account: $e')),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _otpController,
                decoration: InputDecoration(labelText: 'OTP'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the OTP';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _activateAccount,
                child: Text('Activate Account'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await AuthService().resendOtpToActiveAccount(widget.username);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('OTP resent successfully!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error resending OTP: $e')),
                    );
                  }
                },
                child: Text('Resend OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
