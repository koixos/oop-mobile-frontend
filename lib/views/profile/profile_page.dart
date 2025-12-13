import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/pages/login_page.dart';
import '../settings/settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({ super.key });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color bg = const Color(0xFF04150C);
  final Color cardColor = const Color(0xFF0C1F15);
  final Color green = const Color(0xFF06D66E);
  final ImagePicker picker = ImagePicker();
  final FocusNode nameFocus = FocusNode();
  late TextEditingController nameCtrl;
  String fullName = "";
  String email = "";
  String? profileImagePath;
  bool editingName = false;
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: fullName);
    nameFocus.addListener(() {
      if (!nameFocus.hasFocus && editingName) {
        _saveName();
      }
    });

    _loadFromPrefs();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    nameFocus.dispose();
    super.dispose();
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context, _hasChanged),
      ),
      title: const Text(
        "Profile",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true
    );
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString("name") ?? fullName;
      email = prefs.getString("email") ?? email;
      profileImagePath = prefs.getString("img");
      nameCtrl.text = fullName;
    });
  }

  Future<void> changePhoto() async {
    final source = await _selectImageSource();
    if (source == null) return;

    final XFile? picked = await picker.pickImage(source: source);

    if (picked != null) {
      setState(() => profileImagePath = picked.path);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("img", picked.path);
    }
  }

  Future<ImageSource?> _selectImageSource() async {
    return showDialog<ImageSource>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cardColor,
        title: const Text("Change Photo", style: TextStyle(color: Colors.white)),
        content: const Text("Choose a source",
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text("Camera"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text("Gallery"),
          ),
        ],
      ),
    );
  }

  Future<void> _saveName() async {
    final newName = nameCtrl.text.trim();
    if (newName.isEmpty) {
      setState(() {
        editingName = false;
        nameCtrl.text = fullName;
      });
      return;
    }

    setState(() {
      fullName = newName;
      editingName = false;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", fullName);

    _hasChanged = true;
  }

  Future<void> editName() async {
    TextEditingController ctrl = TextEditingController(text: fullName);

    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cardColor,
        title: const Text("Edit Name", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: ctrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Enter your name",
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ctrl.text),
            child: const Text("Save"),
          ),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      setState(() => fullName = result.trim());
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("fullName", fullName);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("loggedIn", false);

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cardColor,
        title: const Text("Delete Account", style: TextStyle(color: Colors.red)),
        content: const Text(
          "Are you sure? This action cannot be undone.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")
          ),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete")
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

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProfileImage(),
          const SizedBox(height: 16),
          _buildNameAndSubtitle(),
          const SizedBox(height: 20),
          _buildStatsRow(),
          const SizedBox(height: 28),
          _buildSectionHeader("PERSONAL INFORMATION"),
          const SizedBox(height: 8),
          _buildNameEditableRow(),
          const SizedBox(height: 14),
          _buildEmailStaticRow(),
          const SizedBox(height: 30),
          _buildSectionHeader("PREFERENCES"),
          const SizedBox(height: 12),
          _buildMenuTile(Icons.track_changes, "Goal Alignment", () {}),
          _buildMenuTile(Icons.settings, "Settings", () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
          }),
          const SizedBox(height: 12),
          _buildLogoutBtn(),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: profileImagePath != null
                  ? FileImage(File(profileImagePath!))
                  : const NetworkImage(
                      "https://images.unsplash.com/photo-1603415526960-f7e0328f6dd7?w=400",
                  ) as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        GestureDetector(
          onTap: changePhoto,
          child: Container(
            width: 40,
            height: 40,
            decoration:
            BoxDecoration(color: green, shape: BoxShape.circle),
            child: const Icon(Icons.camera_alt, color: Colors.black),
          ),
        )
      ],
    );
  }

  Widget _buildNameAndSubtitle() {
    return Column(
      children: [
        Text(
          fullName,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Building a legacy of creativity.",
          style: TextStyle(color: Colors.white54, fontSize: 14),
        )
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatCard("Lvl 5", "MASTERY"),
        const SizedBox(width: 16),
        _buildStatCard("12 Days", "STREAK"),
      ],
    );
  }

  Widget _buildStatCard(String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF0D241D),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
              value,
              style: const TextStyle(
                  color: Color(0xFF06D66E),
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              )
          ),
          const SizedBox(height: 4),
          Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
                letterSpacing: 1,
              )
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
          text,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 14,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          )
      ),
    );
  }

  Widget _buildNameEditableRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Full Name", style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: editingName ? TextField(
            controller: nameCtrl,
            focusNode: nameFocus,
            autofocus: true,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            minLines: 1,
            maxLines: 1,
            decoration: const InputDecoration(border: InputBorder.none,),
            textInputAction: TextInputAction.done,
            onEditingComplete: () { nameFocus.unfocus(); },
          ) : InkWell(
            onTap: () {
              setState(() {
                editingName = true;
                nameCtrl.text = fullName;
              });
              Future.delayed(const Duration(milliseconds: 50), () {
                nameFocus.requestFocus();
                nameCtrl.selection = TextSelection.collapsed(offset: nameCtrl.text.length);
              });
            },
            child: SizedBox(
              height: 44,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      fullName,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const Icon(Icons.edit, color: Colors.white54, size: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailStaticRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Email Address", style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  email,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const Icon(
                  Icons.email_outlined,
                  color: Colors.white54,
                  size: 18
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: green.withOpacity(0.2)
              ),
              child: Icon(icon, color: green),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white38)
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutBtn() {
    return GestureDetector(
      onTap: logout,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white24),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.white),
            SizedBox(width: 8),
            Text("Log Out", style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: _buildAppBar(),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: _buildBody(),
      ),
    );
  }
}