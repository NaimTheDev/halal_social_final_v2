import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentor_app/features/auth/models/app_user.dart';
import 'package:mentor_app/models/calendly_token.dart';
import 'package:mentor_app/core/providers/app_providers.dart' as app_providers;
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
  final TextEditingController _calendlyUrlController = TextEditingController();
  bool _isUpdatingImage = false;
  bool _isUpdatingCalendly = false;

  @override
  void dispose() {
    _calendlyUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user data available.')),
      );
    }

    final isExpert = user.role.name == 'mentor';

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildUserProfile(user),
          const SizedBox(height: 24),
          _buildSectionTitle("Account"),
          const SizedBox(height: 16),

          // Profile Picture Section
          _buildProfilePictureSection(user),
          const SizedBox(height: 16),

          // Calendly URL Section (only for mentors)
          if (isExpert) ...[
            _buildCalendlySection(user),
            const SizedBox(height: 16),
          ],

          const Divider(height: 40),

          TextButton(
            onPressed: () async {
              try {
                final authService = ref.read(authServiceProvider);
                await authService.signOut();
                // The AppWrapper will automatically handle navigation when auth state changes

                // Show success message
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Successfully logged out'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (e) {
                // Show error message
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error logging out: ${e.toString()}'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
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
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 64,
                height: 64,
                child: CachedNetworkImage(
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
                        child: Icon(Icons.person, size: 32, color: Colors.grey),
                      ),
                ),
              ),
            ),
            if (_isUpdatingImage)
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.email,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(user.email),
              Text(
                'Role: ${user.role.name}',
                style: TextStyle(
                  color:
                      user.role.name == 'mentor' ? Colors.blue : Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePictureSection(AppUser user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Picture',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Update your profile picture',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed:
                      _isUpdatingImage
                          ? null
                          : () => _updateProfileImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed:
                      _isUpdatingImage
                          ? null
                          : () => _updateProfileImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendlySection(AppUser user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calendly Integration',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your Calendly URL to allow mentees to book sessions',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _calendlyUrlController,
              decoration: const InputDecoration(
                labelText: 'Calendly URL',
                hintText: 'https://calendly.com/your-username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUpdatingCalendly ? null : _updateCalendlyUrl,
                child:
                    _isUpdatingCalendly
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text('Update Calendly URL'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfileImage(ImageSource source) async {
    try {
      setState(() => _isUpdatingImage = true);

      final storageService = ref.read(app_providers.storageServiceProvider);
      final authService = ref.read(authServiceProvider);
      final user = ref.read(currentUserProvider);

      if (user == null) return;

      final imageFile = await storageService.pickImage(source: source);
      if (imageFile == null) return;

      final imageUrl = await storageService.uploadProfileImage(
        user.uid,
        imageFile,
      );
      await authService.updateProfileImage(imageUrl);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile picture: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdatingImage = false);
      }
    }
  }

  Future<void> _updateCalendlyUrl() async {
    final url = _calendlyUrlController.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a Calendly URL')),
      );
      return;
    }

    if (!url.startsWith('https://calendly.com/')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid Calendly URL')),
      );
      return;
    }

    try {
      setState(() => _isUpdatingCalendly = true);

      final authService = ref.read(authServiceProvider);
      await authService.updateMentorCalendlyInfo(calendlyUrl: url);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Calendly URL updated successfully!')),
        );
        _calendlyUrlController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating Calendly URL: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdatingCalendly = false);
      }
    }
  }

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  );
}
