import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get apiUrl => dotenv.env['API_BASE_URL']!;
  static String get authUrl => '$apiUrl/v1/auth';
}