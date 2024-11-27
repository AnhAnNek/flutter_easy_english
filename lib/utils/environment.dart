class Environment {
  static String get wsUrl => 'wss://192.168.31.2:8001/ws';
  static String get apiUrl => 'http://192.168.31.2:8001/api';
  static String get authUrl => '$apiUrl/v1/auth';
  static String get courseUrl => '$apiUrl/v1/course';
}