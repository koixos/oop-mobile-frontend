import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sptm/core/validators.dart';

import '../auth/pages/login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _changePwdFormKey = GlobalKey<FormState>();
  bool _hideOld = true;
  bool _hideNew = true;
  bool goalReminders = true;
  bool smartNudges = true;
  bool syncCloud = true;
  bool localOnly = false;
  bool biometricLock = false;
  bool shareUsage = true;

  String dailyBriefingTime = "08:00 AM";
  String reviewFrequency = "Weekly";
  String checkInDay = "Sunday";

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      goalReminders = prefs.getBool("goalReminders") ?? true;
      smartNudges = prefs.getBool("smartNudges") ?? true;
      syncCloud = prefs.getBool("syncCloud") ?? true;
      localOnly = prefs.getBool("localOnly") ?? false;
      biometricLock = prefs.getBool("biometricLock") ?? false;
      shareUsage = prefs.getBool("shareUsage") ?? true;
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<void> changePassword() async {
    final Color cardColor = const Color(0xFF0C1F15);
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();

    final prefs = await SharedPreferences.getInstance();
    final savedPassword = prefs.getString("passwd");
    debugPrint(savedPassword);
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return AlertDialog(
            backgroundColor: cardColor,
            title: const Text(
              "Change Password",
              style: TextStyle(color: Colors.white),
            ),
            content: Form(
              key: _changePwdFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _passwordField(
                    label: "Old Password",
                    controller: oldCtrl,
                    obscure: _hideOld,
                    toggle: () => setModalState(() => _hideOld = !_hideOld),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Old password required";
                      }
                      if (savedPassword != v) {
                        return "Old password is incorrect";
                      }
                      return null;
                    },
                  ),
                  _passwordField(
                    label: "New Password",
                    controller: newCtrl,
                    obscure: _hideNew,
                    toggle: () => setModalState(() => _hideNew = !_hideNew),
                    validator: Validators.validatePasswd,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  final oldPwd = oldCtrl.text.trim();
                  final newPwd = newCtrl.text.trim();

                  if (savedPassword == null || savedPassword != oldPwd) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Old password is incorrect"),
                      ),
                    );
                    return;
                  }

                  if (!_changePwdFormKey.currentState!.validate()) return;

                  await prefs.setString("passwd", newPwd);

                  Navigator.pop(ctx);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password changed successfully"),
                    ),
                  );
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF0C1F15),
        title: const Text(
          "Delete Account",
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
          "This action cannot be undone.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07160F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section("GENERAL"),
          _navTile(Icons.flag, "Mission Statement", () {}),
          _navTile(Icons.lock_outline, "Change Password", changePassword),

          const SizedBox(height: 24),
          _section("REVIEW CADENCE"),
          _valueTile(Icons.refresh, "Frequency", reviewFrequency),
          _valueTile(Icons.calendar_today, "Check-in Day", checkInDay),

          const SizedBox(height: 24),
          _section("NOTIFICATIONS"),
          _timeTile(Icons.wb_sunny, "Daily Briefing", dailyBriefingTime),
          _switchTile(
            Icons.notifications_active,
            "Goal Reminders",
            goalReminders,
            (v) {
              setState(() => goalReminders = v);
              _saveBool("goalReminders", v);
            },
          ),
          _switchTile(
            Icons.lightbulb_outline,
            "Smart Nudges",
            smartNudges,
            (v) {
              setState(() => smartNudges = v);
              _saveBool("smartNudges", v);
            },
            subtitle: "AI-driven productivity tips",
          ),

          const SizedBox(height: 24),
          _section("SYNCHRONIZATION & DATA"),
          _switchTile(Icons.cloud_sync, "Sync to Cloud", syncCloud, (v) {
            setState(() => syncCloud = v);
            _saveBool("syncCloud", v);
          }),
          _switchTile(
            Icons.storage,
            "Local-only Storage",
            localOnly,
            (v) {
              setState(() => localOnly = v);
              _saveBool("localOnly", v);
            },
            subtitle: "Disable cloud backup",
          ),
          _navTile(Icons.download, "Export Data (CSV)", () {}),
          const SizedBox(height: 24),
          _dangerTile(Icons.delete, "Delete Account", _deleteAccount),
          const SizedBox(height: 32),
          const Center(
            child: Column(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF06D66E)),
                SizedBox(height: 8),
                Text(
                  "Smart Task Manager",
                  style: TextStyle(color: Colors.white54),
                ),
                Text(
                  "Version 1.0.0 (Build 2023.10)",
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback toggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.white54,
          ),
          onPressed: toggle,
        ),
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white54,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _navTile(IconData icon, String title, VoidCallback onTap) {
    return _baseTile(
      icon,
      title,
      trailing: const Icon(Icons.chevron_right, color: Colors.white38),
      onTap: onTap,
    );
  }

  Widget _valueTile(IconData icon, String title, String value) {
    return _baseTile(
      icon,
      title,
      trailing: Text(value, style: const TextStyle(color: Colors.white54)),
    );
  }

  Widget _timeTile(IconData icon, String title, String value) {
    return _baseTile(
      icon,
      title,
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF07160F),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(value, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _switchTile(
    IconData icon,
    String title,
    bool value,
    ValueChanged<bool> onChanged, {
    String? subtitle,
  }) {
    return _baseTile(
      icon,
      title,
      subtitle: subtitle,
      trailing: Switch(
        value: value,
        activeThumbColor: const Color(0xFF06D66E),
        onChanged: onChanged,
      ),
    );
  }

  Widget _dangerTile(IconData icon, String title, VoidCallback onTap) {
    return _baseTile(
      icon,
      title,
      onTap: onTap,
      iconColor: Colors.red,
      textColor: Colors.red,
    );
  }

  Widget _baseTile(
    IconData icon,
    String title, {
    Widget? trailing,
    VoidCallback? onTap,
    String? subtitle,
    Color iconColor = const Color(0xFF06D66E),
    Color textColor = Colors.white,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1F15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              )
            : null,
        trailing: trailing,
      ),
    );
  }
}
