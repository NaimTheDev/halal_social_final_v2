import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mentor_app/features/mentors/views/browse_mentors_page.dart';
import '../../auth/controllers/auth_state_controller.dart';
import '../../auth/models/app_user.dart';
// import 'mentor_home_page.dart';
// import 'mentee_home_page.dart';

class HomeSelectorPage extends ConsumerWidget {
  const HomeSelectorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Center(child: Text('User not found'));
    }

    switch (user.role) {
      case UserRole.mentor:
        return MentorHomePage(ref: ref);
      case UserRole.mentee:
        return MenteeHomePage(ref: ref);
    }
  }
}

class MentorHomePage extends ConsumerWidget {
  final WidgetRef ref;
  const MentorHomePage({super.key, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mentor Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                final authService = ref.read(authServiceProvider);
                await authService.signOut();
                // The AppWrapper will automatically handle navigation when auth state changes
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
          ),
        ],
      ),
      body: const Center(child: Text("Welcome, Mentor!")),
    );
  }
}

class MenteeHomePage extends ConsumerWidget {
  final WidgetRef ref;
  const MenteeHomePage({super.key, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mentee Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                final authService = ref.read(authServiceProvider);
                await authService.signOut();
                // The AppWrapper will automatically handle navigation when auth state changes
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
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Browse Mentors"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BrowseMentorsPage()),
            );
          },
        ),
      ),
    );
  }
}
