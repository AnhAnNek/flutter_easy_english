import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/i_auth_service.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  // Load environment variables
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide an instance of AuthService as an implementation of IAuthService
        Provider<IAuthService>(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Android Programming | Easy English',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
      ),
    );
  }
}
