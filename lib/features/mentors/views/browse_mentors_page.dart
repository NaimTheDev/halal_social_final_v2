import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../controllers/mentor_state_controller.dart';
import '../models/mentor.dart';
import 'mentor_profile_page.dart';
import 'widgets/mentor_card.dart';
import '../../../shared/widgets/common_widgets.dart';

class BrowseMentorsPage extends ConsumerStatefulWidget {
  const BrowseMentorsPage({super.key});

  @override
  ConsumerState<BrowseMentorsPage> createState() => _BrowseMentorsPageState();
}

class _BrowseMentorsPageState extends ConsumerState<BrowseMentorsPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mentorState = ref.watch(mentorStateProvider);
    final mentors = ref.watch(filteredMentorsProvider);

    // Load mentors when the page is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mentorState.mentors.isEmpty && !mentorState.isLoading) {
        ref.read(mentorStateProvider.notifier).loadMentors();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Browse Mentors')),
      body: Column(
        children: [
          _buildSearchBar(context),
          Expanded(child: _buildBody(context, mentorState, mentors)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for mentors...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (query) {
          ref.read(mentorStateProvider.notifier).updateSearchQuery(query);
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    MentorState mentorState,
    List<Mentor> mentors,
  ) {
    if (mentorState.isLoading) {
      return const LoadingDisplay(message: 'Loading mentors...');
    }

    if (mentorState.error != null) {
      return ErrorDisplay(
        title: 'Error Loading Mentors',
        message: mentorState.error!,
        onRetry: () {
          ref.read(mentorStateProvider.notifier).loadMentors();
        },
      );
    }

    if (mentors.isEmpty) {
      return const EmptyStateDisplay(
        title: 'No Mentors Found',
        message: 'Try adjusting your filters or check back later',
        icon: Icons.people_outline,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mentors.length,
      itemBuilder: (context, index) {
        final mentor = mentors[index];
        return MentorCard(
          mentor: mentor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MentorProfilePage(mentor: mentor),
              ),
            );
          },
        );
      },
    );
  }
}
