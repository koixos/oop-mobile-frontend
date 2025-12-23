import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sptm/views/dashboard/widgets/task_card.dart';
import 'package:sptm/views/notifications/notifications_page.dart';
import 'package:sptm/views/settings/settings_page.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  static const String _inboxKey = "quick_capture_inbox_tasks";
  String greeting = "";
  String firstName = "";
  String? profileImagePath;
  final TextEditingController _quickTaskController = TextEditingController();
  final FocusNode _quickTaskFocusNode = FocusNode();
  final stt.SpeechToText _speech = stt.SpeechToText();
  late final AnimationController _listeningPulseController;
  late final Animation<double> _listeningPulse;
  bool _isListening = false;
  bool _isQuickCaptureOpen = false;
  final List<String> _quickCaptureMissions = const [
    "Health",
    "Career",
    "Learning",
    "Relationships",
    "Finance",
  ];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _listeningPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _listeningPulse = CurvedAnimation(
      parent: _listeningPulseController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _quickTaskController.dispose();
    _quickTaskFocusNode.dispose();
    _listeningPulseController.dispose();
    _speech.stop();
    super.dispose();
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
      firstName = fullName.isNotEmpty ? fullName.split(" ").first : "";

      profileImagePath = img;
      greeting = _getGreetingBasedOnTime();
    });
  }

  Future<void> _toggleListening(StateSetter setModalState) async {
    if (_isListening) {
      await _speech.stop();
      if (!mounted) return;
      setState(() => _isListening = false);
      setModalState(() => _isListening = false);
      _listeningPulseController.stop();
      _listeningPulseController.value = 0;
      return;
    }

    final available = await _speech.initialize(
      onStatus: (status) {
        if (!mounted) return;
        if (status == "done" || status == "notListening") {
          setState(() => _isListening = false);
          if (_isQuickCaptureOpen) {
            setModalState(() => _isListening = false);
          }
        }
      },
      onError: (error) {
        if (!mounted) return;
        setState(() => _isListening = false);
        if (_isQuickCaptureOpen) {
          setModalState(() => _isListening = false);
        }
      },
    );

    if (!available) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Speech recognition unavailable.")),
      );
      return;
    }

    setState(() => _isListening = true);
    setModalState(() => _isListening = true);
    _quickTaskFocusNode.requestFocus();
    _listeningPulseController.repeat(reverse: true);
    await _speech.listen(
      onResult: (result) {
        if (!mounted) return;
        _quickTaskController.text = result.recognizedWords;
        _quickTaskController.selection = TextSelection.fromPosition(
          TextPosition(offset: _quickTaskController.text.length),
        );
        setModalState(() {});
      },
    );
  }

  Future<void> _openQuickCaptureSheet() async {
    _quickTaskController.clear();
    String? selectedMission;
    _isQuickCaptureOpen = true;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0C1F15),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Quick Capture",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _quickTaskController,
                    focusNode: _quickTaskFocusNode,
                    showCursor: true,
                    cursorColor: _isListening
                        ? const Color(0xFF06D66E)
                        : Colors.white70,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      hintText: "Task name",
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color(0xFF0B2518),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(
                        Icons.keyboard,
                        color: Colors.white54,
                      ),
                      suffixIcon: SizedBox(
                        width: 64,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isListening)
                              FadeTransition(
                                opacity: _listeningPulse,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF06D66E),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            IconButton(
                              icon: Icon(
                                _isListening ? Icons.mic : Icons.mic_none,
                                color: _isListening
                                    ? const Color(0xFF06D66E)
                                    : Colors.white54,
                              ),
                              onPressed: () => _toggleListening(setModalState),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Type or use the mic to capture quickly.",
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedMission,
                    hint: const Text(
                      "Optional mission",
                      style: TextStyle(color: Colors.white54),
                    ),
                    dropdownColor: const Color(0xFF0C1F15),
                    iconEnabledColor: Colors.white70,
                    style: const TextStyle(color: Colors.white),
                    items: _quickCaptureMissions
                        .map(
                          (mission) => DropdownMenuItem(
                            value: mission,
                            child: Text(mission),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setModalState(() {
                        selectedMission = value;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF0B2518),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF06D66E),
                        foregroundColor: const Color(0xFF07160F),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (_quickTaskController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Task name is required."),
                            ),
                          );
                          return;
                        }
                        await _saveQuickCaptureTask(
                          _quickTaskController.text.trim(),
                          selectedMission,
                        );
                        if (_isListening) {
                          await _speech.stop();
                          if (!mounted) return;
                          setState(() => _isListening = false);
                          _listeningPulseController.stop();
                          _listeningPulseController.value = 0;
                        }
                        Navigator.pop(context);
                      },
                      child: const Text("Add Task"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    if (_isListening) {
      await _speech.stop();
      if (mounted) {
        setState(() => _isListening = false);
      }
      _listeningPulseController.stop();
      _listeningPulseController.value = 0;
    }
    _isQuickCaptureOpen = false;
  }

  Future<void> _saveQuickCaptureTask(String title, String? mission) async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList(_inboxKey) ?? [];
    final payload = jsonEncode({
      "title": title,
      "mission": mission,
      "createdAt": DateTime.now().toIso8601String(),
    });
    items.add(payload);
    await prefs.setStringList(_inboxKey, items);
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFF07160F),
      elevation: 0,
      leadingWidth: 56,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: CircleAvatar(
          backgroundColor: const Color(0xFF0B3B26),
          backgroundImage: profileImagePath != null
              ? FileImage(File(profileImagePath!))
              : null,
          child: profileImagePath == null
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NotificationsPage(),
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
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
        IconButton(
          icon: const Icon(Icons.inbox_outlined, color: Colors.white),
          onPressed: _openQuickCaptureSheet,
          tooltip: "Quick capture",
        ),
      ],
    );
  }

  // Widget _buildActiveGoals() {
  //   return SizedBox(
  //     height: 170,
  //     child: ListView(
  //       scrollDirection: Axis.horizontal,
  //       children: const [
  //         GoalCard(title: 'Run a 5k Marathon', imgUrl: '', progress: 0.75),
  //         SizedBox(width: 12),
  //         GoalCard(title: 'Run a 5k Marathon', imgUrl: '', progress: 0.4),
  //         SizedBox(width: 12),
  //         GoalCard(title: 'Run a 5k Marathon', imgUrl: '', progress: 0.6),
  //       ],
  //     ),
  //   );
  // }

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
              Text(
                'Priority Matrix',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Urgent & important tasks',
                style: TextStyle(fontSize: 18, color: Color(0xFF37BF6C)),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: const [
                  Text(
                    '3',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF06D66E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Do', style: TextStyle(color: Color(0xFF37BF6C))),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                children: const [
                  Text(
                    '5',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF06D66E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Schedule', style: TextStyle(color: Color(0xFF37BF6C))),
                ],
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: const [
        Text(
          'Today',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 18),
        Text(
          'This Week',
          style: TextStyle(fontSize: 16, color: Color(0xFF37BF6C)),
        ),
        SizedBox(width: 18),
        Text(
          'Upcoming',
          style: TextStyle(fontSize: 16, color: Color(0xFF37BF6C)),
        ),
      ],
    );
  }

  Widget _buildTaskList(String urgency_importance) {
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
        'title': "Finalize project proposal1",
        'subtitle': "Launch Side Project",
        'color': Colors.orange,
      },
      {
        'title': "Finalize project proposal2",
        'subtitle': "Launch Side Project",
        'color': Colors.orange,
      },
      {
        'title': "Finalize project proposal3",
        'subtitle': "Launch Side Project",
        'color': Colors.orange,
      },
      {
        'title': "Finalize project proposal4",
        'subtitle': "Launch Side Project",
        'color': Colors.orange,
      },
    ];

    // return ListView.builder(
    //   shrinkWrap: true,
    //   physics: const NeverScrollableScrollPhysics(),
    //   itemCount: tasks.length,
    //   itemBuilder: (context, index) {
    //     final t = tasks[index];
    //     return TaskCard(
    //       title: t['title'] as String,
    //       subtitle: t['subtitle'] as String,
    //       color: (t['color'] as Color),
    //       done: (t['Done'] as bool?) ?? false,
    //     );
    //   },
    // );

    return Container(
      height: 300,
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
                  urgency_importance,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    // TODO: add action
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white24),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final t = tasks[index];
                return TaskCard(
                  title: t['title'] as String,
                  subtitle: t['subtitle'] as String,
                  color: (t['color'] as Color),
                  done: (t['done'] as bool?) ?? false,
                );
              },
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
      appBar: _buildAppBar(),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: const Color(0xFF06D66E),
          backgroundColor: const Color(0xFF04150C),
          onRefresh: _loadUserInfo,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  // const SizedBox(height: 16),
                  // _buildActiveGoals(),
                  // const SizedBox(height: 16),
                  // _buildPriorityMatrix(context),
                  // const SizedBox(height: 18),
                  // _buildTabs(),
                  const SizedBox(height: 16),
                  _buildTaskList("Urgent, Important"),
                  const SizedBox(height: 16),
                  _buildTaskList("Urgent, Not Important"),
                  const SizedBox(height: 16),
                  _buildTaskList("Not Urgent, Important"),
                  const SizedBox(height: 16),
                  _buildTaskList("Not Urgent, Not Important"),
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
