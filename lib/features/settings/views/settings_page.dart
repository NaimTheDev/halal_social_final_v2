import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mentor_app/features/auth/models/app_user.dart';
import 'package:mentor_app/models/calendly_token.dart';
import 'package:mentor_app/providers/firestore_providers.dart';
import '../../auth/controllers/auth_controller.dart';

final calendlyTokenDocProvider =
    Provider.family<DocumentReference<CalendlyToken>, String>((ref, userId) {
      final firestore = ref.watch(firestoreProvider);
      return firestore
          .collection('calendly_tokens')
          .doc(userId)
          .withConverter<CalendlyToken>(
            fromFirestore:
                (snapshot, _) => CalendlyToken.fromJson(snapshot.data()!),
            toFirestore: (token, _) => token.toJson(),
          );
    });

final calendlyTokenProvider = StreamProvider.family<CalendlyToken?, String>((
  ref,
  userId,
) {
  final doc = ref.watch(calendlyTokenDocProvider(userId));
  return doc.snapshots().map((snap) => snap.data());
});

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
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('No user data available.')),
          );
        }

        final isExpert = user.role.name == 'mentor';
        final calendlyTokenAsync = ref.watch(calendlyTokenProvider(user.uid));

        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildUserProfile(user),
              const SizedBox(height: 24),
              _buildSectionTitle("Account"),
              _buildListItem("General"),

              const Divider(height: 40),
              _buildSectionTitle("Preferences"),
              _buildToggleItem("Push Notifications", pushNotificationsEnabled, (
                value,
              ) {
                setState(() {
                  pushNotificationsEnabled = value;
                });
              }),

              TextButton(
                onPressed: () async {
                  final authService = ref.read(authServiceProvider);
                  await authService.signOut();
                  Navigator.of(context).pushReplacementNamed('/auth');
                },
                child: const Text(
                  "Log Out",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserProfile(AppUser user) {
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
              child: Text('Image', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.email ?? 'No email available',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(user.email),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  );

  Widget _buildListItem(String title) => ListTile(
    title: Text(title),
    trailing: const Icon(Icons.chevron_right),
    onTap: () {},
  );

  Widget _buildToggleItem(
    String title,
    bool value,
    void Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
