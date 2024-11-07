import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_utils.dart';
import 'environment.dart';

class HttpRequest {
  // Function to handle GET requests
  static Future<Map<String, dynamic>> get(String path, {Map<String, String>? headers}) async {
    final String baseUrl = Environment.apiUrl;
    final url = Uri.parse('$baseUrl$path');

    try {
      final token = await AuthUtils.getToken();
      final headersWithToken = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        ...?headers,
      };

      final response = await http.get(url, headers: headersWithToken);

      return _handleDynamicResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> getReturnDynamic(String path, {Map<String, String>? headers}) async {
    final String baseUrl = Environment.apiUrl;
    final url = Uri.parse('$baseUrl$path');

    try {
      final token = await AuthUtils.getToken();
      final headersWithToken = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        ...?headers,
      };

      final response = await http.get(url, headers: headersWithToken);
      return _handleDynamicResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Function to handle POST requests
  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data, {Map<String, String>? headers}) async {
    final String baseUrl = Environment.apiUrl;
    final url = Uri.parse('$baseUrl$path');

    try {
      final token = await AuthUtils.getToken();
      final headersWithToken = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        ...?headers,
      };

      final response = await http.post(url, headers: headersWithToken, body: jsonEncode(data));

      return _handleDynamicResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Function to handle POST requests
  static Future<dynamic> postReturnDynamic(String path, Map<String, dynamic> data, {Map<String, String>? headers}) async {
    final String baseUrl = Environment.apiUrl;
    final url = Uri.parse('$baseUrl$path');

    try {
      final token = await AuthUtils.getToken();
      final headersWithToken = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        ...?headers,
      };

      final response = await http.post(url, headers: headersWithToken, body: jsonEncode(data));
      return _handleDynamicResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Function to handle PUT requests
  static Future<Map<String, dynamic>> put(String path, Map<String, dynamic> data, {Map<String, String>? headers}) async {
    final String baseUrl = Environment.apiUrl;
    final url = Uri.parse('$baseUrl$path');

    try {
      final token = await AuthUtils.getToken();
      final headersWithToken = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        ...?headers,
      };

      final response = await http.put(url, headers: headersWithToken, body: jsonEncode(data));
      return _handleDynamicResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> putReturnDynamic(String path, Map<String, dynamic> data, {Map<String, String>? headers}) async {
    final String baseUrl = Environment.apiUrl;
    final url = Uri.parse('$baseUrl$path');

    try {
      final token = await AuthUtils.getToken();
      final headersWithToken = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        ...?headers,
      };

      final response = await http.put(url, headers: headersWithToken, body: jsonEncode(data));
      return _handleDynamicResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Function to handle DELETE requests
  static Future<Map<String, dynamic>> delete(String path, {Map<String, String>? headers}) async {
    final String baseUrl = Environment.apiUrl;
    final url = Uri.parse('$baseUrl$path');

    try {
      final token = await AuthUtils.getToken();
      final headersWithToken = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        ...?headers,
      };

      final response = await http.delete(url, headers: headersWithToken);

      return _handleDynamicResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> deleteReturnDynamic(String path, {Map<String, String>? headers}) async {
    final String baseUrl = Environment.apiUrl;
    final url = Uri.parse('$baseUrl$path');

    try {
      final token = await AuthUtils.getToken();
      final headersWithToken = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        ...?headers,
      };

      final response = await http.delete(url, headers: headersWithToken);
      return _handleDynamicResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  static dynamic _handleDynamicResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        // Attempt to parse JSON response and return the parsed response
        return jsonDecode(response.body);  // Return the parsed JSON object dynamically
      } catch (e) {
        // If JSON parsing fails, return the raw response body
        return response.body;
      }
    } else {
      // If the status code is not successful, throw an error
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}
