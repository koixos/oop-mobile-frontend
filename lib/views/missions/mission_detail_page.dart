import 'package:flutter/material.dart';
import 'package:sptm/core/constants.dart';

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
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(
        backgroundColor: const Color(AppColors.surface),
        iconTheme: const IconThemeData(color: Color(AppColors.textMain)),
        title: Text(
          missionTitle,
          style: const TextStyle(color: Color(AppColors.textMain)),
        ),
      ),
      body: submissions.isEmpty
          ? const Center(
              child: Text(
                'No sub-missions yet.',
                style: TextStyle(color: Color(AppColors.textMuted)),
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
                    color: const Color(AppColors.surface),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      submission.title,
                      style: const TextStyle(
                        color: Color(AppColors.textMain),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      submission.subtitle,
                      style: const TextStyle(color: Color(AppColors.textMuted)),
                    ),
                    trailing: const Icon(
                      Icons.keyboard_arrow_right,
                      color: Color(AppColors.textMuted),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
