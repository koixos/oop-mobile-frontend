import 'package:sptm/models/mission.dart';
import 'package:sptm/services/api_service.dart';

class MissionService {
  final ApiService _api = ApiService();

  Future<List<Mission>> getMissions(int userId) async {
    final response = await _api.get('/missions/user/$userId');
    if (response == null) return [];

    if (response is List) {
      return response.map((json) => Mission.fromJson(json)).toList();
    } else {
      throw ApiException("Unexpected response format", 500);
    }
  }

  Future<Mission> createMission(String content, int userId) async {
    final body = {
      'content': content,
      'user': {'id': userId},
      'subMissions': [] // Start empty
    };

    final response = await _api.post('/missions', body: body);
    return Mission.fromJson(response);
  }

  Future<void> deleteMission(int missionId) async {
    await _api.delete('/missions/$missionId');
  }

  Future<void> addSubMission(int missionId, String title, String description) async {
    // Assuming endpoint: POST /api/missions/{missionId}/submissions
    final body = {
      'title': title,
      'description': description,
    };
    await _api.post('/missions/$missionId/submissions', body: body);
  }

  Future<void> deleteSubMission(int subMissionId) async {
      // Assuming endpoint: DELETE /api/missions/submissions/{subMissionId}
      await _api.delete('/missions/submissions/$subMissionId');
  }
}
