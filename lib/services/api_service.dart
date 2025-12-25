import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sptm/core/constants.dart';

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class ApiService {
  final http.Client _client = http.Client();

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Uri _getUri(String endpoint) {
    return Uri.parse('${AppStrings.apiBaseURL}$endpoint');
  }

  Future<dynamic> get(String endpoint) async {
    final response = await _client.get(
      _getUri(endpoint),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, {dynamic body}) async {
    final response = await _client.post(
      _getUri(endpoint),
      headers: await _getHeaders(),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(String endpoint, {dynamic body}) async {
    final response = await _client.put(
      _getUri(endpoint),
      headers: await _getHeaders(),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final response = await _client.delete(
      _getUri(endpoint),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return response.body; // Return raw string if not JSON
      }
    } else if (response.statusCode == 401) {
       // TODO: Handle token expiration/logout
      throw ApiException("Unauthorized", 401);
    } else {
      String message = "Unknown Error";
      try {
        final body = jsonDecode(response.body);
        message = body['message'] ?? body['error'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw ApiException(message, response.statusCode);
    }
  }
}
