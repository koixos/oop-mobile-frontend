import 'package:flutter/material.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController notesCtrl = TextEditingController();

  int priority = 2; // 0=Low,1=Med,2=High
  double effortMinutes = 45;

  final Color bg = const Color(0xFF07160F);
  final Color card = const Color(0xFF0C1F15);
  final Color green = const Color(0xFF06D66E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _taskInput(),
            const SizedBox(height: 24),

            _section("MISSION ALIGNMENT"),
            _missionCard(),

            const SizedBox(height: 16),
            _dueDateCard(),

            const SizedBox(height: 16),
            _priorityCard(),

            const SizedBox(height: 16),
            _effortCard(),

            const SizedBox(height: 24),
            _contextSection(),

            const SizedBox(height: 16),
            _extraOptions(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("Cancel",
            style: TextStyle(color: Colors.white54)),
      ),
      centerTitle: true,
      title: const Text(
        "Create Task",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          onPressed: _saveTask,
          child: const Text(
            "Save",
            style: TextStyle(color: Color(0xFF06D66E), fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _taskInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: titleCtrl,
          style: const TextStyle(
              color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            hintText: "What needs to be done?",
            hintStyle: TextStyle(color: Colors.white38),
            border: InputBorder.none,
          ),
        ),
        TextField(
          controller: notesCtrl,
          style: const TextStyle(color: Colors.white70),
          decoration: const InputDecoration(
            hintText: "Add notes, details, or subtasks...",
            hintStyle: TextStyle(color: Colors.white38),
            border: InputBorder.none,
          ),
        ),
      ],
    );
  }

  Widget _section(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white54,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _missionCard() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.rocket_launch,
                    color: Color(0xFF06D66E)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Become a Senior Dev",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Q3 Goal: Master System Design",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white38),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.75,
              minHeight: 6,
              color: green,
              backgroundColor: Colors.white12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dueDateCard() {
    return _simpleCard(
      icon: Icons.calendar_today,
      title: "Due Date",
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text("Today, 4:00 PM",
            style: TextStyle(color: Color(0xFF06D66E))),
      ),
    );
  }

  Widget _priorityCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Priority",
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: List.generate(3, (i) {
              final labels = ["Low", "Med", "High"];
              final selected = priority == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => priority = i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? green : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        labels[i],
                        style: TextStyle(
                          color: selected
                              ? Colors.black
                              : Colors.white54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _effortCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("Effort",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("${effortMinutes.toInt()}m",
                    style:
                    const TextStyle(color: Color(0xFF06D66E))),
              ),
            ],
          ),
          Slider(
            value: effortMinutes,
            min: 5,
            max: 180,
            divisions: 35,
            activeColor: green,
            inactiveColor: Colors.white12,
            onChanged: (v) => setState(() => effortMinutes = v),
          )
        ],
      ),
    );
  }

  Widget _contextSection() {
    return Row(
      children: [
        const Text("CONTEXTS & TAGS",
            style:
            TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child:
          const Text("Edit", style: TextStyle(color: Color(0xFF06D66E))),
        ),
      ],
    );
  }

  Widget _extraOptions() {
    return Column(
      children: [
        _simpleCard(
            icon: Icons.location_on,
            title: "Add location",
            trailing:
            const Icon(Icons.chevron_right, color: Colors.white38)),
        const SizedBox(height: 12),
        _simpleCard(
            icon: Icons.subdirectory_arrow_right,
            title: "Add parent task",
            trailing:
            const Icon(Icons.chevron_right, color: Colors.white38)),
      ],
    );
  }

  Widget _simpleCard(
      {required IconData icon,
        required String title,
        required Widget trailing}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ),
          trailing,
        ],
      ),
    );
  }

  void _saveTask() {
    if (titleCtrl.text.trim().isEmpty) return;
    Navigator.pop(context);
  }
}
