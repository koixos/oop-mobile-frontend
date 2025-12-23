import 'package:flutter/material.dart';

// TODO Implement mission detail funcstionalities:
//  must lead to task page of that submission

class MissionSubmission {
  final String title;
  final String subtitle;

  const MissionSubmission({required this.title, required this.subtitle});
}

class MissionDetailPage extends StatelessWidget {
  final String missionTitle;
  final List<MissionSubmission> submissions;

  const MissionDetailPage({
    super.key,
    required this.missionTitle,
    required this.submissions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07160F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D241D),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(missionTitle, style: const TextStyle(color: Colors.white)),
      ),
      body: submissions.isEmpty
          ? const Center(
              child: Text(
                'No sub-missions yet.',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: submissions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final submission = submissions[index];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D241D),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      submission.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      submission.subtitle,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white70,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
