import 'package:flutter/material.dart';
import 'package:sptm/core/validators.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> showPasswordDialog() async {
      final newController = TextEditingController();
      final confirmController = TextEditingController();
      final formKey = GlobalKey<FormState>();

      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Change Password'),
          content: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: newController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New password',
                    errorMaxLines: 3,
                  ),
                  validator: Validators.validatePasswd,
                ),
                TextFormField(
                  controller: confirmController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm new password',
                    errorMaxLines: 3,
                  ),
                  validator: (value) {
                    //final baseError = Validators.validatePasswd(value);
                    //if (baseError != null) return baseError;
                    if (value != newController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                // TODO: Validate and call password update API.
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password updated')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      );
    }

    Future<void> showNameDialog() async {
      final emailController = TextEditingController();

      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Change Name'),
          content: TextField(
            controller: emailController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: 'New Name',
              hintText: 'Your Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Validate and call email update API.
                Navigator.of(context).pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Name updated')));
              },
              child: const Text('Save'),
            ),
          ],
        ),
      );
    }

    Future<void> showProfilePictureSheet() async {
      await showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () {
                  // TODO: Open camera picker.
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Camera not implemented')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  // TODO: Open gallery picker.
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gallery not implemented')),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    final actions = <_SettingAction>[
      _SettingAction('Change Password', Icons.lock_reset, showPasswordDialog),
      _SettingAction('Change Name', Icons.text_format, showNameDialog),
      _SettingAction(
        'Change Profile Picture',
        Icons.camera_alt_outlined,
        showProfilePictureSheet,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: actions
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(item.icon),
                            label: Text(item.label),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            onPressed: item.onPressed,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingAction {
  final String label;
  final IconData icon;
  final Future<void> Function() onPressed;

  const _SettingAction(this.label, this.icon, this.onPressed);
}
