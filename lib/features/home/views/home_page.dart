import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../mentors/controllers/mentor_state_controller.dart';
import '../../mentors/views/mentor_profile_page.dart';
import '../../mentors/views/browse_mentors_page.dart';
import '../../auth/controllers/auth_state_controller.dart';
import '../../calls/providers/calls_providers.dart';
import '../../chats/views/chats_page.dart';
import '../../calls/views/calls_page_improved.dart';
import '../../chats/providers/chat_providers.dart';

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
            SliverToBoxAdapter(child: _buildQuickStats(context, ref)),
            SliverToBoxAdapter(child: _buildRecentActivity(context, ref)),
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
            SliverToBoxAdapter(child: _buildPopularCategories(context)),
            SliverToBoxAdapter(child: _buildQuickActions(context)),
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

  Widget _buildQuickStats(BuildContext context, WidgetRef ref) {
    final upcomingCalls = ref.watch(upcomingCallsProvider);
    final activeChatsCount = ref.watch(activeChatsCountProvider);

    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              'Upcoming Calls',
              upcomingCalls.length.toString(),
              Icons.video_call,
              Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CallsPage()),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              'Active Chats',
              activeChatsCount.toString(),
              Icons.chat,
              Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatsPage()),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              'Categories',
              '4', // Based on current category count
              Icons.category,
              Colors.orange,
              onTap: () {
                // Navigate to categories page
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, WidgetRef ref) {
    final upcomingCalls = ref.watch(upcomingCallsProvider);
    final nextCall = upcomingCalls.isNotEmpty ? upcomingCalls.first : null;

    if (nextCall == null) {
      return Container();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Next Call',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${nextCall.eventType} with ${nextCall.inviteeName}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              Text(
                DateTime.parse(
                  nextCall.startTime,
                ).toLocal().toString().split('.').first,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CallsPage()),
                    );
                  },
                  child: const Text('View Details'),
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

  Widget _buildPopularCategories(BuildContext context) {
    final popularCategories = [
      {'name': 'Theology', 'icon': Icons.menu_book, 'color': Colors.purple},
      {
        'name': 'Fitness & Nutrition',
        'icon': Icons.fitness_center,
        'color': Colors.red,
      },
      {
        'name': 'Quranic Studies',
        'icon': Icons.auto_stories,
        'color': Colors.green,
      },
      {'name': 'Coaching', 'icon': Icons.psychology, 'color': Colors.blue},
      {'name': 'Business', 'icon': Icons.business, 'color': Colors.orange},
      {'name': 'Mental Health', 'icon': Icons.favorite, 'color': Colors.pink},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'Popular Categories',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: popularCategories.length,
            itemBuilder: (context, index) {
              final category = popularCategories[index];
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 12),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BrowseMentorsPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            category['icon'] as IconData,
                            color: category['color'] as Color,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category['name'] as String,
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  'Find Mentor',
                  Icons.search,
                  Colors.blue,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BrowseMentorsPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  context,
                  'Schedule Call',
                  Icons.calendar_today,
                  Colors.green,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CallsPage()),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  'Browse Chats',
                  Icons.chat,
                  Colors.orange,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChatsPage()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  context,
                  'Explore Categories',
                  Icons.category,
                  Colors.purple,
                  () {
                    // Navigate to categories page
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
