import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../mentors/controllers/mentor_state_controller.dart';
import '../../mentors/views/mentor_profile_page.dart';
import '../../mentors/views/browse_mentors_page.dart';
import '../../auth/controllers/auth_state_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildGreeting(context, ref)),
            SliverToBoxAdapter(child: _buildCategoryChips()),
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                'Featured Mentors',
                onSeeAllPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BrowseMentorsPage(),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(child: _buildHorizontalMentorCards(ref)),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    String greeting = 'Assalamualaykum';
    if (user != null && user.name != null && user.name!.isNotEmpty) {
      greeting = 'Assalamualaykum ${user.name}';
    } else if (user != null &&
        user.firstName != null &&
        user.firstName!.isNotEmpty) {
      greeting = 'Assalamualaykum ${user.firstName}';
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.waving_hand,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  greeting,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = [
      'Fitness & Nutrition',
      'Theology',
      'Quranic Studies',
      'Coaching',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children:
            categories.map((cat) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(label: Text(cat)),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAllPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          GestureDetector(
            onTap: onSeeAllPressed,
            child: const Text('See all', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalMentorCards(WidgetRef ref) {
    final mentors = ref.watch(mentorsProvider);
    final isLoading = ref.watch(mentorsLoadingProvider);
    final error = ref.watch(mentorsErrorProvider);

    // Load mentors if not already loaded and not currently loading
    if (mentors.isEmpty && !isLoading && error == null) {
      Future(() => ref.read(mentorStateProvider.notifier).loadMentors());
    }

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text('Error: $error'));
    }

    final featuredMentors = mentors.take(5).toList();
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: featuredMentors.length,
        itemBuilder: (context, index) {
          final mentor = featuredMentors[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MentorProfilePage(mentor: mentor),
                ),
              );
            },
            child: Container(
              width: 120,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  mentor.imageUrl != null && mentor.imageUrl!.isNotEmpty
                      ? CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(mentor.imageUrl!),
                      )
                      : CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[400],
                        child: const Icon(
                          Icons.person,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                  const SizedBox(height: 8),
                  Text(
                    mentor.name,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${mentor.expertise}',
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
