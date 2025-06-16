import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../auth/controllers/auth_controller.dart';

class SettingsPage extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const SettingsPage({super.key, required this.ref});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool pushNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    
    final ref = this.ref;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildUserProfile(),
          const SizedBox(height: 24),
          _buildSectionTitle("Account"),
          _buildListItem("General"),
          _buildListItem("Transactions"),
          _buildListItem("Two-Factor Authentication"),
          _buildListItem("Become an expert"),
          const Divider(height: 40),
          _buildSectionTitle("Preferences"),
          _buildToggleItem("Push Notifications", pushNotificationsEnabled, (value) {
            setState(() {
              pushNotificationsEnabled = value;
            });
          }),
          const Divider(height: 40),
          _buildSectionTitle("Support"),
          _buildListItem("Contact us"),
          const Divider(height: 40),
          _buildSectionTitle("Legal"),
          _buildListItem("Terms & Conditions"),
          _buildListItem("Privacy Policy"),
          const Divider(height: 40),
          TextButton(
            onPressed: () async {
              final authService = ref.read(authServiceProvider);

              await authService.signOut();
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Image',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Randome Guy", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text("randomemail@email.com"),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
  }

  Widget _buildListItem(String title) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Implement navigation
      },
    );
  }

  Widget _buildToggleItem(String title, bool value, void Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}