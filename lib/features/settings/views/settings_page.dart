import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mentor_app/features/auth/models/app_user.dart';
import 'package:mentor_app/models/calendly_token.dart';
import 'package:mentor_app/providers/firestore_providers.dart';
import '../../auth/controllers/auth_state_controller.dart';

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
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user data available.')),
      );
    }

    // final isExpert = user.role.name == 'mentor';
    // final calendlyTokenAsync = ref.watch(calendlyTokenProvider(user.uid));

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
              // The AppWrapper will automatically handle navigation when auth state changes
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
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

            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: user.imageUrl ?? '',
                  fit: BoxFit.cover,
                  errorWidget:
                      (context, url, error) => const Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.white,
                      ),
                  placeholder:
                      (context, url) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.email,
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
