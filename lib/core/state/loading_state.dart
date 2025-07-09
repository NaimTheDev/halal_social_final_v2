import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Loading state for different features
enum LoadingState { idle, loading, success, error }

/// Loading state notifier
class LoadingStateNotifier extends StateNotifier<Map<String, LoadingState>> {
  LoadingStateNotifier() : super({});

  void setLoading(String key, LoadingState loadingState) {
    state = {...state, key: loadingState};
  }

  void clearLoading(String key) {
    final newState = Map<String, LoadingState>.from(state);
    newState.remove(key);
    state = newState;
  }

  LoadingState getLoadingState(String key) {
    return state[key] ?? LoadingState.idle;
  }

  bool isLoading(String key) {
    return getLoadingState(key) == LoadingState.loading;
  }

  bool hasError(String key) {
    return getLoadingState(key) == LoadingState.error;
  }

  bool isSuccess(String key) {
    return getLoadingState(key) == LoadingState.success;
  }
}

/// Global loading state provider
final loadingStateProvider =
    StateNotifierProvider<LoadingStateNotifier, Map<String, LoadingState>>((
      ref,
    ) {
      return LoadingStateNotifier();
    });

/// Loading state keys
class LoadingKeys {
  static const String auth = 'auth';
  static const String profile = 'profile';
  static const String mentors = 'mentors';
  static const String chats = 'chats';
  static const String calls = 'calls';
  static const String onboarding = 'onboarding';
}

/// Convenience providers for common loading states
final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(loadingStateProvider.notifier).isLoading(LoadingKeys.auth);
});

final profileLoadingProvider = Provider<bool>((ref) {
  return ref
      .watch(loadingStateProvider.notifier)
      .isLoading(LoadingKeys.profile);
});

final mentorsLoadingProvider = Provider<bool>((ref) {
  return ref
      .watch(loadingStateProvider.notifier)
      .isLoading(LoadingKeys.mentors);
});

/// Loading state extension for easy access
extension LoadingStateExtension on WidgetRef {
  void setLoading(String key, LoadingState state) {
    read(loadingStateProvider.notifier).setLoading(key, state);
  }

  void clearLoading(String key) {
    read(loadingStateProvider.notifier).clearLoading(key);
  }

  bool isLoading(String key) {
    return read(loadingStateProvider.notifier).isLoading(key);
  }

  bool hasError(String key) {
    return read(loadingStateProvider.notifier).hasError(key);
  }

  bool isSuccess(String key) {
    return read(loadingStateProvider.notifier).isSuccess(key);
  }
}
