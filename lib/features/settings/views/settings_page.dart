import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mentor_app/features/auth/models/app_user.dart';
import 'package:mentor_app/models/calendly_token.dart';
import 'package:mentor_app/providers/firestore_providers.dart';
import 'package:mentor_app/services/calendly_services.dart';
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
        final isExpert = user!.role.name == 'mentor';
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
              _buildListItem("Transactions"),
              _buildListItem("Two-Factor Authentication"),
              _buildListItem("Become an expert"),
              if (isExpert)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: calendlyTokenAsync.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) => Text('Error checking Calendly: $e'),
                    data: (token) {
                      final isConnected = token != null;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isConnected
                                ? "Calendly Connected ✅"
                                : "Calendly Not Connected ❌",
                            style: TextStyle(
                              color: isConnected ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          ElevatedButton(
                            onPressed:
                                isConnected
                                    ? null
                                    : () async {
                                      await initiateCalendlyAuth();
                                    },
                            child: const Text('Connect Calendly'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              const Divider(height: 40),
              _buildSectionTitle("Preferences"),
              _buildToggleItem("Push Notifications", pushNotificationsEnabled, (
                value,
              ) {
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
              user.email ?? "No Name",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(user.email ?? "No Email"),
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
    onTap: () {
      // TODO: Implement navigation
    },
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
