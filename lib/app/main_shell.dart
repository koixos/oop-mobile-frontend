import 'package:flutter/material.dart';
import 'package:sptm/views/archive/archive_page.dart';
import 'package:sptm/views/calendar/calendar_page.dart';
import 'package:sptm/views/dashboard/dashboard_page.dart';
import 'package:sptm/views/insights/insights_page.dart';
import 'package:sptm/views/missions/missions_list_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  final pages = const [
    DashboardPage(),
    MissionsListPage(),
    CalendarPage(),
    InsightsPage(),
    ArchivePage(),
  ];

  Widget _navItem({required IconData icon, required int itemIndex}) {
    final isActive = index == itemIndex;

    return InkWell(
      onTap: () => setState(() => index = itemIndex),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? const Color(0x3306D66E) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isActive ? Colors.white : Colors.white54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF04150C),
      body: IndexedStack(index: index, children: pages),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: const Color(0xFF06D66E),
      //   elevation: 8,
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (_) => const CreateTaskPage()),
      //     );
      //   },
      //   child: const Icon(Icons.add, size: 32, color: Colors.black),
      // ),
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
                _navItem(icon: Icons.home, itemIndex: 0), // dashboard
                _navItem(icon: Icons.flag, itemIndex: 1), // missions
                _navItem(icon: Icons.calendar_month, itemIndex: 2), // calendar
                _navItem(icon: Icons.insights, itemIndex: 3), // insights
                _navItem(icon: Icons.archive, itemIndex: 4), // archive
              ],
            ),
          ),
        ),
      ),
    );
  }
}
