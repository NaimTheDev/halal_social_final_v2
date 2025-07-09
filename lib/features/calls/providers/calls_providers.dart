import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../models/scheduled_call.dart';
import '../../../core/providers/app_providers.dart';
import '../../auth/controllers/auth_state_controller.dart';

/// Scheduled calls provider
final scheduledCallsProvider = FutureProvider<List<ScheduledCall>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    throw Exception('User not logged in');
  }

  final firestore = ref.watch(firestoreProvider);
  final scheduledCallsRef = firestore
      .collection('users')
      .doc(user.uid)
      .collection('scheduled_calls');

  final snapshot = await scheduledCallsRef.get();
  return snapshot.docs
      .map((doc) => ScheduledCall.fromFirestore(doc.data()))
      .toList();
});

/// Upcoming calls provider
final upcomingCallsProvider = Provider<List<ScheduledCall>>((ref) {
  final callsAsync = ref.watch(scheduledCallsProvider);
  return callsAsync.when(
    data:
        (calls) =>
            calls
                .where(
                  (call) =>
                      DateTime.parse(call.startTime).isAfter(DateTime.now()),
                )
                .toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Past calls provider
final pastCallsProvider = Provider<List<ScheduledCall>>((ref) {
  final callsAsync = ref.watch(scheduledCallsProvider);
  return callsAsync.when(
    data:
        (calls) =>
            calls
                .where(
                  (call) =>
                      DateTime.parse(call.startTime).isBefore(DateTime.now()),
                )
                .toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Calls loading state provider
final callsLoadingProvider = Provider<bool>((ref) {
  final callsAsync = ref.watch(scheduledCallsProvider);
  return callsAsync.isLoading;
});

/// Calls error provider
final callsErrorProvider = Provider<Object?>((ref) {
  final callsAsync = ref.watch(scheduledCallsProvider);
  return callsAsync.hasError ? callsAsync.error : null;
});
