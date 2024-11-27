import 'package:flutter/material.dart';
import 'package:flutter_easy_english/screens/index_screen.dart';
import 'package:flutter_easy_english/services/category_service.dart';
import 'package:flutter_easy_english/services/course_service.dart';
import 'package:flutter_easy_english/services/i_category_service.dart';
import 'package:flutter_easy_english/services/i_course_service.dart';
import 'package:flutter_easy_english/services/i_level_service.dart';
import 'package:flutter_easy_english/services/i_message_service.dart';
import 'package:flutter_easy_english/services/i_order_service.dart';
import 'package:flutter_easy_english/services/i_topic_service.dart';
import 'package:flutter_easy_english/services/i_user_service.dart';
import 'package:flutter_easy_english/services/level_service.dart';
import 'package:flutter_easy_english/services/message_service.dart';
import 'package:flutter_easy_english/services/order_service.dart';
import 'package:flutter_easy_english/services/topic_service.dart';
import 'package:flutter_easy_english/services/user_service.dart';
import 'package:flutter_easy_english/utils/auth_utils.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/i_auth_service.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<IAuthService>(create: (_) => AuthService()),
        Provider<ICourseService>(create: (_) => CourseService()),
        Provider<ICategoryService>(create: (_) => CategoryService()),
        Provider<ILevelService>(create: (_) => LevelService()),
        Provider<ITopicService>(create: (_) => TopicService()),
        Provider<IUserService>(create: (_) => UserService()),
        Provider<IMessageService>(create: (_) => MessageService()),
        Provider<IOrderService>(create: (_) => OrderService()),
      ],
      child: MaterialApp(
        title: 'Android Programming | Easy English',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthUtils.isLoggedIn(), // Check login status
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading screen while checking the login status
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.data == false) {
          // If the user is not logged in, show the LoginScreen
          return LoginScreen();
        }

        // If the user is logged in, show the IndexScreen
        return IndexScreen();
      },
    );
  }
}
