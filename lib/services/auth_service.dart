import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sptm/core/constants.dart';

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);
}

class AuthService {
  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  Future<void> register(String name, String email, String passwd) async {
    final uri = Uri.parse("${AppStrings.apiBaseURL}/auth/register");
    final response = await _client.post(
      uri,
      headers: const {"Content-Type": "application/json"},
      body: jsonEncode({"username": name, "email": email, "password": passwd}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    if (response.statusCode == 403) {
      throw const AuthException("Registration forbidden.");
    }

    final message = response.body.isNotEmpty
        ? response.body
        : "Registration failed. (${response.statusCode})";
    throw AuthException(message);
  }

  Future<void> login(String emailOrPhone, String passwd) async {
    final uri = Uri.parse('${AppStrings.apiBaseURL}/auth/login');
    final loginValue = emailOrPhone.trim();
    final payload = <String, String>{"password": passwd};

    if (loginValue.contains("@")) {
      payload["email"] = loginValue;
    } else if (RegExp(r"^\+?\d+$").hasMatch(loginValue)) {
    } else {
      payload["username"] = loginValue;
    }

    final response = await _client.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final token = body['token'] as String?;
      if (token == null) {
        throw const AuthException('Invalid response from server.');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setBool('loggedIn', true);
      if (body['id'] is int) await prefs.setInt('user_id', body['id'] as int);
      if (body['username'] is String) {
        await prefs.setString('username', body['username'] as String);
      }
      if (body['email'] is String) {
        await prefs.setString('email', body['email'] as String);
      }
      return;
    }

    if (response.statusCode == 403) {
      throw const AuthException('Invalid credentials.');
    }

    final message = response.body.isNotEmpty
        ? response.body
        : "Login failed. (${response.statusCode})";
    throw AuthException(message);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> requestPasswdReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return true;
  }

  Future<bool> resetPasswdWithCode(
    String email,
    String code,
    String newPasswd,
  ) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (code == '123456') return true;
    return false;
  }
}
