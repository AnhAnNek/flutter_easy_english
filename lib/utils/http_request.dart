import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'auth_utils.dart'; // Import your auth utils for getting the token

class HttpRequest {
  static final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  // Function to handle GET requests
  static Future<Map<String, dynamic>> get(String path, {Map<String, String>? headers}) async {
    final url = Uri.parse('$_baseUrl$path');

    try {
      final token = await AuthUtils.getToken();
      final headersWithToken = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        ...?headers,
      };

      final response = await http.get(url, headers: headersWithToken);

      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Function to handle POST requests
  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data, {Map<String, String>? headers}) async {
    final url = Uri.parse('$_baseUrl$path');

    try {
      final token = await AuthUtils.getToken();
      final headersWithToken = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        ...?headers,
      };

      final response = await http.post(url, headers: headersWithToken, body: jsonEncode(data));

      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Function to handle PUT requests
  static Future<Map<String, dynamic>> put(String path, Map<String, dynamic> data, {Map<String, String>? headers}) async {
    final url = Uri.parse('$_baseUrl$path');

    try {
      final token = await AuthUtils.getToken();
      final headersWithToken = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        ...?headers,
      };

      final response = await http.put(url, headers: headersWithToken, body: jsonEncode(data));

      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Function to handle DELETE requests
  static Future<Map<String, dynamic>> delete(String path, {Map<String, String>? headers}) async {
    final url = Uri.parse('$_baseUrl$path');

    try {
      final token = await AuthUtils.getToken();
      final headersWithToken = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        ...?headers,
      };

      final response = await http.delete(url, headers: headersWithToken);

      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Handle the response based on the status code
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = jsonDecode(response.body);

    if (statusCode >= 200 && statusCode < 300) {
      return responseBody;
    } else {
      if (statusCode == 401) {
        print('Unauthorized access - possibly due to an invalid token.');
      } else if (statusCode == 403) {
        print('Forbidden - you do not have permission to access this resource.');
      } else if (statusCode == 500) {
        print('Server error - something went wrong on the server.');
      }
      throw Exception(responseBody['message'] ?? 'An unknown error occurred');
    }
  }
}
