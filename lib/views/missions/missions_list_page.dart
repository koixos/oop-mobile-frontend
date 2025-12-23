import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sptm/core/constants.dart';
import 'package:sptm/views/missions/mission_detail_page.dart';

class MissionsListPage extends StatefulWidget {
  const MissionsListPage({super.key});

  @override
  State<MissionsListPage> createState() => _MissionsListPageState();
}

class _MissionsListPageState extends State<MissionsListPage> {
  String _missionTitle = "Graduate University";
  final List<MissionSubmission> _submissions = [
    MissionSubmission(
      title: "Capstone proposal",
      subtitle: "Submitted Mar 12, 2024",
    ),
    MissionSubmission(
      title: "Pass Algo class",
      subtitle: "Submitted Apr 02, 2024",
    ),
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

  String _formatSubmissionDate(DateTime value) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    final month = months[value.month - 1];
    return "$month ${value.day.toString().padLeft(2, "0")}, ${value.year}";
  }

  Future<void> _showEditMissionDialog() async {
    final controller = TextEditingController(text: _missionTitle);

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(AppColors.surface),
          title: const Text(
            'Set Mission',
            style: TextStyle(color: Color(AppColors.textMain)),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            style: const TextStyle(color: Color(AppColors.textMain)),
            decoration: const InputDecoration(
              hintText: 'Write your mission',
              hintStyle: TextStyle(color: Color(AppColors.textMuted)),
            ),
            onSubmitted: (_) => Navigator.of(context).pop(controller.text),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Save'),
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
      _missionTitle = title;
    });
  }

  Future<void> _showAddSubmissionDialog() async {
    if (_missionTitle.trim().isEmpty) {
      await _showEditMissionDialog();
      if (_missionTitle.trim().isEmpty) {
        return;
      }
    }

    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(AppColors.surface),
          title: const Text(
            'Add Sub-mission',
            style: TextStyle(color: Color(AppColors.textMain)),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            style: const TextStyle(color: Color(AppColors.textMain)),
            decoration: const InputDecoration(
              hintText: 'Sub-mission title',
              hintStyle: TextStyle(color: Color(AppColors.textMuted)),
            ),
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
      _submissions.insert(
        0,
        MissionSubmission(
          title: title,
          subtitle: "Submitted ${_formatSubmissionDate(DateTime.now())}",
        ),
      );
    });
  }

  Widget _buildMissionHeader() {
    final hasMission = _missionTitle.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Mission',
                  style: TextStyle(
                    color: Color(AppColors.textMain),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  hasMission ? _missionTitle : 'Tap to set your mission',
                  style: TextStyle(
                    fontSize: 18,
                    color: hasMission
                        ? const Color(AppColors.textMain)
                        : const Color(AppColors.textMuted),
                    fontStyle: hasMission ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Color(AppColors.textMain)),
            onPressed: _showEditMissionDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionsList() {
    return Container(
      height: 550,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.2),
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
                  'Sub-missions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(AppColors.textMain),
                    fontSize: 25,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add, color: Color(AppColors.textMain)),
                  onPressed: () {
                    _showAddSubmissionDialog();
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(AppColors.surfaceBase)),
          Expanded(
            child: Scrollbar(
              child: _submissions.isEmpty
                  ? const Center(
                      child: Text(
                        'No submissions yet.',
                        style: TextStyle(color: Color(AppColors.textMuted)),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _submissions.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final submission = _submissions[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(AppColors.surfaceBase),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const CircleAvatar(
                              backgroundColor: Color(AppColors.tagCyan),
                              radius: 6,
                            ),
                            title: Text(
                              submission.title,
                              style: const TextStyle(
                                color: Color(AppColors.textMain),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              submission.subtitle,
                              style: const TextStyle(
                                color: Color(AppColors.textMuted),
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
      backgroundColor: const Color(AppColors.background),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: const Color(AppColors.primary),
          backgroundColor: const Color(AppColors.background),
          onRefresh: _loadUserInfo,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildMissionHeader(),
                  const SizedBox(height: 12),
                  _buildSubmissionsList(),
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
