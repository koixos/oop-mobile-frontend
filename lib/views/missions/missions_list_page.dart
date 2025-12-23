import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sptm/views/missions/mission_detail_page.dart';

class MissionsListPage extends StatefulWidget {
  const MissionsListPage({super.key});

  @override
  State<MissionsListPage> createState() => _MissionsListPageState();
}

class _MissionsListPageState extends State<MissionsListPage> {
  final List<Map<String, Object>> _missions = [
    {
      'title': "Graduate University",
      'color': Colors.red,
      'submissions': [
        MissionSubmission(
          title: "Capstone proposal",
          subtitle: "Submitted Mar 12, 2024",
        ),
        MissionSubmission(
          title: "Pass Algo class",
          subtitle: "Submitted Apr 02, 2024",
        ),
      ],
    },
    {
      'title': "Find a Job",
      'color': Colors.orange,
      'submissions': [
        MissionSubmission(
          title: "Apply to jobs",
          subtitle: "Submitted Feb 21, 2024",
        ),
      ],
    },
    {
      'title': "Improve Coding Skills",
      'color': Colors.blue,
      'submissions': [
        MissionSubmission(
          title: "Practice Algorithms",
          subtitle: "Submitted Mar 29, 2024",
        ),
        MissionSubmission(
          title: "Learn Flutter and Dart",
          subtitle: "Submitted Apr 06, 2024",
        ),
      ],
    },
    {
      'title': "Improve Health",
      'color': Colors.purple,
      'submissions': [
        MissionSubmission(
          title: "Meal prep log",
          subtitle: "Submitted Mar 18, 2024",
        ),
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final fullName = prefs.getString("name") ?? "";
    final img = prefs.getString("img");

    setState(() {});
  }

  Future<void> _showAddMissionDialog() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Mission'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(hintText: 'Mission title'),
            onSubmitted: (_) => Navigator.of(context).pop(controller.text),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    final title = result?.trim();
    if (title == null || title.isEmpty) {
      return;
    }

    setState(() {
      _missions.add({
        'title': title,
        'color': Colors.teal,
        'submissions': <MissionSubmission>[],
      });
    });
  }

  Widget _buildValueHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF0D241D),
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'My Values:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\"Be a good person\"',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMissionsList() {
    return Container(
      height: 550,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 35, 78, 56),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  'My Missions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    _showAddMissionDialog();
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white24),
          Expanded(
            child: Scrollbar(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _missions.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final t = _missions[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MissionDetailPage(
                              missionTitle: t['title'] as String,
                              submissions:
                                  t['submissions'] as List<MissionSubmission>,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: t['color'] as Color,
                            radius: 6,
                          ),
                          title: Text(
                            t['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07160F),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: const Color(0xFF06D66E),
          backgroundColor: const Color(0xFF04150C),
          onRefresh: _loadUserInfo,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildValueHeader(),
                  const SizedBox(height: 12),
                  _buildMissionsList(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
