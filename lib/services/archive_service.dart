import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sptm/models/task_item.dart';
import 'package:sptm/core/constants.dart';

class ArchiveService {
  final http.Client _client;

  ArchiveService({http.Client? client}) : _client = client ?? http.Client();

  /// Kullanıcının archived task'lerini getirir
  Future<List<TaskItem>> getArchivedTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');

    if (token == null || userId == null) {
      throw const ArchiveException("User not authenticated.");
    }

    final uri =
    Uri.parse("${AppStrings.apiBaseURL}/tasks/user/$userId");

    final response = await _client.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);

      // 🔹 sadece archived olanlar
      return body
          .map((e) => TaskItem.fromJson(e))
          .where((task) => task.isArchived)
          .toList();
    }

    final message = response.body.isNotEmpty
        ? response.body
        : "Failed to fetch archived tasks (${response.statusCode})";
    throw ArchiveException(message);
  }

  /// Task'i archive eder
  Future<void> archiveTask(int taskId) async {
    await _archiveToggle(taskId, true);
  }

  /// Task'i archive'den çıkarır
  Future<void> unarchiveTask(int taskId) async {
    await _archiveToggle(taskId, false);
  }

  Future<void> _archiveToggle(int taskId, bool archive) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw const ArchiveException("User not authenticated.");
    }

    final uri = Uri.parse(
      "${AppStrings.apiBaseURL}/tasks/$taskId/archive",
    );

    final response = await _client.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"archived": archive}),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }

    final message = response.body.isNotEmpty
        ? response.body
        : "Archive operation failed (${response.statusCode})";
    throw ArchiveException(message);
  }
}

class ArchiveException implements Exception {
  final String message;
  const ArchiveException(this.message);

  @override
  String toString() => message;
}
