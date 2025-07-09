import 'package:flutter_test/flutter_test.dart';
import 'package:mentor_app/features/mentors/controllers/mentor_state_controller.dart';
import 'package:mentor_app/features/mentors/models/mentor.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('Mentor Search Tests', () {
    late ProviderContainer container;
    late MentorStateNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(mentorStateProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('should filter mentors by search query', () {
      // Create test mentors
      final mentors = [
        Mentor(
          id: '1',
          name: 'John Doe',
          bio: 'Expert in fitness and nutrition',
          expertise: 'Fitness',
          imageUrl: null,
          categories: ['Fitness & Nutrition'],
        ),
        Mentor(
          id: '2',
          name: 'Jane Smith',
          bio: 'Theology expert and scholar',
          expertise: 'Theology',
          imageUrl: null,
          categories: ['Theology'],
        ),
        Mentor(
          id: '3',
          name: 'Ahmed Ali',
          bio: 'Quranic studies teacher',
          expertise: 'Quranic Studies',
          imageUrl: null,
          categories: ['Quranic Studies'],
        ),
      ];

      // Set up initial state with mentors
      notifier.state = notifier.state.copyWith(mentors: mentors);

      // Test search by name
      notifier.updateSearchQuery('John');
      var filteredMentors = notifier.filteredMentors;
      expect(filteredMentors.length, 1);
      expect(filteredMentors.first.name, 'John Doe');

      // Test search by expertise
      notifier.updateSearchQuery('Theology');
      filteredMentors = notifier.filteredMentors;
      expect(filteredMentors.length, 1);
      expect(filteredMentors.first.expertise, 'Theology');

      // Test search by bio
      notifier.updateSearchQuery('fitness');
      filteredMentors = notifier.filteredMentors;
      expect(filteredMentors.length, 1);
      expect(filteredMentors.first.name, 'John Doe');

      // Test search by category
      notifier.updateSearchQuery('Quranic');
      filteredMentors = notifier.filteredMentors;
      expect(filteredMentors.length, 1);
      expect(filteredMentors.first.name, 'Ahmed Ali');

      // Test case insensitive search
      notifier.updateSearchQuery('JOHN');
      filteredMentors = notifier.filteredMentors;
      expect(filteredMentors.length, 1);
      expect(filteredMentors.first.name, 'John Doe');

      // Test empty search returns all mentors
      notifier.updateSearchQuery('');
      filteredMentors = notifier.filteredMentors;
      expect(filteredMentors.length, 3);
    });

    test('should filter mentors by search query and categories', () {
      // Create test mentors
      final mentors = [
        Mentor(
          id: '1',
          name: 'John Doe',
          bio: 'Expert in fitness and nutrition',
          expertise: 'Fitness',
          imageUrl: null,
          categories: ['Fitness & Nutrition'],
        ),
        Mentor(
          id: '2',
          name: 'Jane Smith',
          bio: 'Theology expert and scholar',
          expertise: 'Theology',
          imageUrl: null,
          categories: ['Theology'],
        ),
        Mentor(
          id: '3',
          name: 'Ahmed Ali',
          bio: 'Fitness coach and trainer',
          expertise: 'Fitness',
          imageUrl: null,
          categories: ['Fitness & Nutrition'],
        ),
      ];

      // Set up initial state with mentors
      notifier.state = notifier.state.copyWith(mentors: mentors);

      // Test combined search and category filter
      notifier.updateSearchQuery('fitness');
      notifier.updateSelectedCategories(['Fitness & Nutrition']);

      var filteredMentors = notifier.filteredMentors;
      expect(filteredMentors.length, 2);
      expect(
        filteredMentors.every(
          (mentor) => mentor.categories!.contains('Fitness & Nutrition'),
        ),
        true,
      );
      expect(
        filteredMentors.every(
          (mentor) =>
              mentor.name.toLowerCase().contains('fitness') ||
              mentor.expertise.toLowerCase().contains('fitness') ||
              mentor.bio.toLowerCase().contains('fitness'),
        ),
        true,
      );
    });
  });
}
