import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../controllers/mentor_controller.dart';
import '../models/mentor.dart';
import 'mentor_profile_page.dart';
import 'widgets/mentor_card.dart';

class BrowseMentorsPage extends ConsumerWidget {
  const BrowseMentorsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mentorsAsync = ref.watch(mentorsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Browse Mentors')),
      body: mentorsAsync.when(
        data: (mentors) {
          if (mentors.isEmpty) {
            return const Center(child: Text("No mentors available."));
          }

          return ListView.builder(
            itemCount: mentors.length,
            itemBuilder: (context, index) {
              final mentor = mentors[index];
              return MentorCard(
                mentor: mentor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MentorProfilePage(mentor: mentor),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}