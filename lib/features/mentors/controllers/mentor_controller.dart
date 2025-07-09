import './mentor_state_controller.dart';

// Re-export the new mentors provider for backwards compatibility
final mentorsProvider = mentorStateProvider.select((state) => state.mentors);
