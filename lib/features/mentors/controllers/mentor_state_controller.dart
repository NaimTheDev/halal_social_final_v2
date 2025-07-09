import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../models/mentor.dart';

/// Mentor state management
class MentorState {
  final List<Mentor> mentors;
  final bool isLoading;
  final String? error;
  final List<String> selectedCategories;
  final String searchQuery;

  const MentorState({
    this.mentors = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategories = const [],
    this.searchQuery = '',
  });

  MentorState copyWith({
    List<Mentor>? mentors,
    bool? isLoading,
    String? error,
    List<String>? selectedCategories,
    String? searchQuery,
  }) {
    return MentorState(
      mentors: mentors ?? this.mentors,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Mentor state notifier
class MentorStateNotifier extends StateNotifier<MentorState> {
  MentorStateNotifier(this._ref) : super(const MentorState());

  final Ref _ref;

  Future<void> loadMentors() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final firestore = _ref.read(firestoreProvider);
      final snapshot = await firestore.collection('mentors').get();

      final mentors =
          snapshot.docs
              .map((doc) => Mentor.fromMap(doc.id, doc.data()))
              .toList();

      state = state.copyWith(mentors: mentors, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateSelectedCategories(List<String> categories) {
    state = state.copyWith(selectedCategories: categories);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  List<Mentor> get filteredMentors {
    List<Mentor> filteredList = state.mentors;

    // Filter by search query
    if (state.searchQuery.isNotEmpty) {
      filteredList =
          filteredList.where((mentor) {
            final query = state.searchQuery.toLowerCase();
            return mentor.name.toLowerCase().contains(query) ||
                mentor.expertise.toLowerCase().contains(query) ||
                mentor.bio.toLowerCase().contains(query) ||
                (mentor.categories?.any(
                      (category) => category.toLowerCase().contains(query),
                    ) ??
                    false);
          }).toList();
    }

    // Filter by selected categories
    if (state.selectedCategories.isNotEmpty) {
      filteredList =
          filteredList.where((mentor) {
            return mentor.categories?.any(
                  (category) => state.selectedCategories.contains(category),
                ) ??
                false;
          }).toList();
    }

    return filteredList;
  }
}

/// Mentor providers
final mentorStateProvider =
    StateNotifierProvider<MentorStateNotifier, MentorState>((ref) {
      return MentorStateNotifier(ref);
    });

/// Convenience providers
final mentorsProvider = Provider<List<Mentor>>((ref) {
  return ref.watch(mentorStateProvider).mentors;
});

final filteredMentorsProvider = Provider<List<Mentor>>((ref) {
  final notifier = ref.watch(mentorStateProvider.notifier);
  // Watch the state to trigger rebuilds when it changes
  ref.watch(mentorStateProvider);
  return notifier.filteredMentors;
});

final mentorsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(mentorStateProvider).isLoading;
});

final mentorsErrorProvider = Provider<String?>((ref) {
  return ref.watch(mentorStateProvider).error;
});

final selectedCategoriesProvider = Provider<List<String>>((ref) {
  return ref.watch(mentorStateProvider).selectedCategories;
});

final searchQueryProvider = Provider<String>((ref) {
  return ref.watch(mentorStateProvider).searchQuery;
});
