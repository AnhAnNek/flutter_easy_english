import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_utils.dart';
import 'environment.dart';

class HttpRequest {
  static Future<dynamic> getReturnDynamic(String path,
      {Map<String, String>? headers}) async {
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

  static Future<dynamic> putReturnDynamic(String path, Map<String, dynamic>? data, {Map<String, String>? headers}) async {
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
      if (response.statusCode == 204) {
        return null;
      }
      // Successful response
      return jsonDecode(response.body);
    } else {
      final Map<String, dynamic> errorJson = jsonDecode(response.body);
      throw Exception('Error: ${errorJson['message']}');
    }
  }
}
