import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sptm/views/dashboard/widgets/goal_card.dart';
import 'package:sptm/views/dashboard/widgets/task_card.dart';
import 'package:sptm/views/notifications/notifications_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({ super.key });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String greeting = "";
  String firstName = "";
  String? profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  String _getGreetingBasedOnTime() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return "Good Morning";
    if (hour >= 12 && hour < 17) return "Good Afternoon";
    if (hour >= 17 && hour < 22) return "Good Evening";
    return "Good Night";
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final fullName = prefs.getString("name") ?? "";
    final img = prefs.getString("img");

    setState(() {
      firstName = fullName.isNotEmpty
          ? fullName.split(" ").first
          : "";

      profileImagePath = img;
      greeting = _getGreetingBasedOnTime();
    });
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFF0B3B26),
                backgroundImage: profileImagePath != null
                    ? FileImage(File(profileImagePath!))
                    : null,
                child: profileImagePath == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  '$greeting, $firstName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActiveGoals() {
    return SizedBox(
      height: 170,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          GoalCard(title: 'Run a 5k Marathon', imgUrl: '', progress: 0.75),
          SizedBox(width: 12),
          GoalCard(title: 'Run a 5k Marathon', imgUrl: '', progress: 0.4),
          SizedBox(width: 12),
          GoalCard(title: 'Run a 5k Marathon', imgUrl: '', progress: 0.6),
        ],
      ),
    );
  }

  Widget _buildPriorityMatrix(BuildContext context) {
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
              Text('Priority Matrix', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text('Urgent & important tasks', style: TextStyle(fontSize: 18, color: Color(0xFF37BF6C))),
            ],
          ),
          Row(
            children: [
              Column(
                children: const [
                  Text('3', style: TextStyle(fontSize: 20, color: Color(0xFF06D66E), fontWeight: FontWeight.bold)),
                  Text('Do', style: TextStyle(color: Color(0xFF37BF6C)))
                ],
              ),
              const SizedBox(width: 12),
              Column(
                children: const [
                  Text('5', style: TextStyle(fontSize: 20, color: Color(0xFF06D66E), fontWeight: FontWeight.bold)),
                  Text('Schedule', style: TextStyle(color: Color(0xFF37BF6C)))
                ],
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.white),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: const [
        Text('Today', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(width: 18),
        Text('This Week', style: TextStyle(fontSize: 16, color: Color(0xFF37BF6C))),
        SizedBox(width: 18),
        Text('Upcoming', style: TextStyle(fontSize: 16, color: Color(0xFF37BF6C))),
      ],
    );
  }

  Widget _buildTaskList() {
    final tasks = [
      {
        'title': "Finalize project proposal",
        'subtitle': "Launch Side Project",
        'color': Colors.red,
      },
      {
        'title': "Finalize project proposal",
        'subtitle': "Launch Side Project",
        'done': true,
        'color': Colors.orange,
      },
      {
        'title': "Finalize project proposal",
        'subtitle': "Launch Side Project",
        'color': Colors.blue,
      },
      {
        'title': "Finalize project proposal",
        'subtitle': "Launch Side Project",
        'color': Colors.orange,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final t = tasks[index];
        return TaskCard(
            title: t['title'] as String,
            subtitle: t['subtitle'] as String,
            color: (t['color'] as Color),
            done: (t['Done'] as bool?) ?? false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07160F),
      body: RefreshIndicator(
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
                _buildHeader(),
                const SizedBox(height: 16),
                _buildActiveGoals(),
                const SizedBox(height: 16),
                _buildPriorityMatrix(context),
                const SizedBox(height: 18),
                _buildTabs(),
                const SizedBox(height: 12),
                _buildTaskList(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}