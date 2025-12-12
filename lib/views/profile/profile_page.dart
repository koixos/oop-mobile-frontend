import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sptm/views/profile/settings_page.dart';

// TODO:
// Implement Task pages and connect to My Tasks section buttons
// (Optional) create a Container widget for styles boxes

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<String> _contexts = ['@home', '@work', '@school'];
  static const List<String> _quickLists = ['Inbox', 'Today', 'Upcoming'];
  final ScrollController _contextScrollController = ScrollController();

  @override
  void dispose() {
    _contextScrollController.dispose();
    super.dispose();
  }

  Future<void> _showAddContextDialog() async {
    final controller = TextEditingController();
    final newContext = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a context'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: '@gym'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (newContext == null || newContext.isEmpty) return;
    final normalized = newContext.startsWith('@')
        ? newContext
        : '@${newContext.replaceAll(' ', '_')}';
    setState(() => _contexts.add(normalized));
  }

  @override
  Widget build(BuildContext context) {
    const name = "Name";
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(name),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Tasks",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              Container(
                height: 230,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _quickLists.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, i) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 1,
                      horizontal: 5,
                    ),
                    title: Text(
                      _quickLists[i],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "My Contexts",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              Container(
                height: 300,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Scrollbar(
                  controller: _contextScrollController,
                  thumbVisibility: false,
                  trackVisibility: true,
                  scrollbarOrientation: ScrollbarOrientation.right,
                  child: ListView.separated(
                    controller: _contextScrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _contexts.length + 1,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, i) {
                      final isAddRow = i == _contexts.length;
                      if (isAddRow) {
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 10,
                          ),
                          leading: Icon(
                            Icons.add_circle_outline,
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                          title: Text(
                            'Add an item',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onTap: _showAddContextDialog,
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        child: Text(
                          _contexts[i],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
