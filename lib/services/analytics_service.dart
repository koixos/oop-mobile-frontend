import 'package:sptm/models/weekly_stats.dart';
import 'package:sptm/services/api_service.dart';

class AnalyticsService {
  final ApiService _api = ApiService();

  Future<WeeklyStats> getWeeklyStats(int userId) async {
    final response = await _api.get('/analytics/weekly/$userId');
    // Assuming backend returns the DTO directly
    if (response != null && response is Map<String, dynamic>) {
        return WeeklyStats.fromJson(response);
    }
    // Return empty/zero stats if failed or null
    return WeeklyStats(totalTasks: 0, completedTasks: 0, completionRate: 0.0);
  }
}
