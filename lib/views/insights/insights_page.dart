import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sptm/models/weekly_stats.dart';
import 'package:sptm/services/analytics_service.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  int selectedPeriod = 0; // 0=Weekly,1=Monthly,2=Yearly

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1117),
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildPeriodSelector(),
              const SizedBox(height: 24),
              _buildStatsCards(),
              const SizedBox(height: 24),
              _buildActivityChart(),
              const SizedBox(height: 32),
              _buildMissionProgress(),
              const SizedBox(height: 32),
              _buildMonthlyGoals(),
            ],
          ),
        ),
      ),
    );
  }

  // HEADER
  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundColor: Color(0xFFFFD6C9),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Insights",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              "Track your progress",
              style: TextStyle(color: Colors.white54),
            )
          ],
        ),
        const Spacer(),
        Icon(Icons.notifications_none, color: Colors.white),
        const SizedBox(width: 16),
        Icon(Icons.settings_outlined, color: Colors.white),
      ],
    );
  }

  // PERIOD SELECTOR
  Widget _buildPeriodSelector() {
    final labels = ["Weekly", "Monthly", "Yearly"];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = i == selectedPeriod;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedPeriod = i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF6C5CE7) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: selected ? Colors.white : Colors.white54,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  bool _isLoading = true;
  WeeklyStats? _stats;
  final AnalyticsService _analyticsService = AnalyticsService();

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) return;

    try {
      final stats = await _analyticsService.getWeeklyStats(userId);
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading stats: $e");
      setState(() => _isLoading = false);
    }
  }

  // STATS
  Widget _buildStatsCards() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    final completed = _stats?.completedTasks ?? 0;
    final rate = _stats?.completionRate ?? 0;
    
    return Row(
      children: [
        _statCard(
            title: "Tasks Completed",
            value: "$completed",
            delta: "", // Delta not available in API yet
            icon: Icons.check_circle,
            color: Colors.green),
        const SizedBox(width: 16),
        _statCard(
            title: "Completion Rate",
            value: "${rate.toStringAsFixed(1)}%",
            delta: "", 
            icon: Icons.psychology,
            color: Colors.purple),
      ],
    );
  }

  Widget _statCard(
      {required String title,
        required String value,
        required String delta,
        required IconData icon,
        required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: color),
                ),
                const Spacer(),
                Text(delta, style: TextStyle(color: color)),
              ],
            ),
            const SizedBox(height: 20),
            Text(value,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    );
  }

  // ACTIVITY CHART
  Widget _buildActivityChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text("Activity",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Spacer(),
              Text("View Report",
                  style: TextStyle(color: Color(0xFF6C5CE7))),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"];
                        return Text(days[value.toInt()],
                            style: const TextStyle(color: Colors.white54));
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(1, 5),
                      FlSpot(2, 2),
                      FlSpot(3, 7),
                      FlSpot(4, 5),
                      FlSpot(5, 4),
                      FlSpot(6, 6),
                    ],
                    isCurved: true,
                    color: const Color(0xFF6C5CE7),
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF6C5CE7).withOpacity(0.2)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // MISSION PROGRESS
  Widget _buildMissionProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Mission Progress",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _progressItem("Graduate University", 0.75, Colors.red),
        _progressItem("Find a Job", 0.30, Colors.orange),
        _progressItem("Improve Coding Skills", 0.60, Colors.blue),
      ],
    );
  }

  Widget _progressItem(String title, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(color: Colors.white)),
              const Spacer(),
              Text("${(value * 100).toInt()}%",
                  style: const TextStyle(color: Colors.white54)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation(color),
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      ),
    );
  }

  // MONTHLY GOALS
  Widget _buildMonthlyGoals() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFF8E44AD)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Monthly Goals",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("12 / 15 Goals",
                  style: TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
          const Spacer(),
          const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              value: 0.8,
              strokeWidth: 6,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          )
        ],
      ),
    );
  }

  // BOTTOM NAV
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0E1117),
      selectedItemColor: const Color(0xFF6C5CE7),
      unselectedItemColor: Colors.white38,
      currentIndex: 3,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.insights), label: ""),
      ],
    );
  }
}
