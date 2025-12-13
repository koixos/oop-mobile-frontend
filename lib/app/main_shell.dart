import 'package:flutter/material.dart';
import 'package:sptm/views/dashboard/dashboard_page.dart';
import 'package:sptm/views/notifications/notifications_page.dart';
import 'package:sptm/views/profile/profile_page.dart';
import 'package:sptm/views/tasks/create_tasks_page.dart';
import 'package:sptm/views/tasks/tasks_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  Widget navItem(BuildContext context, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white54),
          const SizedBox(height: 2),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF04150C),
      body: DashboardPage(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF06D66E),
        elevation: 8,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateTaskPage(),
            ),
          );
        },
        child: const Icon(Icons.add, size: 32, color: Colors.black),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomAppBar(
          color: const Color(0xFF04150C),
          shape: const CircularNotchedRectangle(),
          notchMargin: 6,
          elevation: 10,
          child: SizedBox(
              height: 52,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  navItem(
                    context,
                    Icons.home,
                    () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MainShell())
                      );
                    }
                  ),
                  navItem(
                    context,
                    Icons.list,
                    () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TasksPage())
                      );
                    }
                  ),
                  const SizedBox(width: 40),
                  navItem(
                    context,
                    Icons.notifications,
                        () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NotificationsPage())
                      );
                    }
                  ),
                  navItem(
                    context,
                    Icons.person,
                    () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfilePage())
                      );
                    }
                  ),
                ],
              )
          ),
        ),
      )
    );
  }
}
