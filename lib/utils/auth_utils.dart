import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/login_response.dart';

const String LOGIN_RESPONSE_KEY = 'loginResponseData';

class AuthUtils {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Check if the user is logged in
  static Future<bool> isLoggedIn() async {
    String? data = await _storage.read(key: LOGIN_RESPONSE_KEY);
    return data != null;
  }

  // Save the login response (securely)
  static Future<void> saveLoginResponse(LoginResponse loginResponse) async {
    String encodedResponse = json.encode(loginResponse.toJson());
    await _storage.write(key: LOGIN_RESPONSE_KEY, value: encodedResponse);
  }

  // Remove the login response (securely)
  static Future<void> removeLoginResponse() async {
    await _storage.delete(key: LOGIN_RESPONSE_KEY);
  }

  // Get the authentication token
  static Future<String?> getToken() async {
    if (!await isLoggedIn()) {
      return null;
    }

    String? data = await _storage.read(key: LOGIN_RESPONSE_KEY);

    if (data != null) {
      final decodedData = json.decode(data);
      return decodedData['tokenStr'];
    }

    return null;
  }

  // Get the username
  static Future<String?> getUsername() async {
    if (!await isLoggedIn()) {
      return null;
    }

    String? data = await _storage.read(key: LOGIN_RESPONSE_KEY);

    if (data != null) {
      final decodedData = json.decode(data);
      return decodedData['user'] != null ? decodedData['user']['username'] : null;
    }

    return null;
  }
}
