import 'package:flutter/material.dart';
import 'package:flutter_easy_english/screens/category_screen.dart';
import 'package:flutter_easy_english/screens/course_detail_screen.dart';
import 'package:flutter_easy_english/screens/course_screen.dart';
import 'package:flutter_easy_english/screens/index_screen.dart';
import 'package:flutter_easy_english/screens/level_screen.dart';
import 'package:flutter_easy_english/screens/topic_screen.dart';
import 'package:flutter_easy_english/screens/user_detail_screen.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/i_auth_service.dart';
import 'screens/login_screen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<IAuthService>(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Android Programming | Easy English',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: IndexScreen(),
      ),
    );
  }
}
