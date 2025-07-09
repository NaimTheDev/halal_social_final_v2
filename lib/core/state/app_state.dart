import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Theme enumeration
enum AppTheme { light, dark }

/// App-level state that manages global application state
class AppState {
  final bool isLoading;
  final bool isInitialized;
  final String? error;
  final AppTheme theme;

  const AppState({
    this.isLoading = false,
    this.isInitialized = false,
    this.error,
    this.theme = AppTheme.light,
  });

  AppState copyWith({
    bool? isLoading,
    bool? isInitialized,
    String? error,
    AppTheme? theme,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      error: error ?? this.error,
      theme: theme ?? this.theme,
    );
  }
}

/// Global app state notifier
class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(const AppState());

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setInitialized(bool initialized) {
    state = state.copyWith(isInitialized: initialized);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void setTheme(AppTheme theme) {
    state = state.copyWith(theme: theme);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
