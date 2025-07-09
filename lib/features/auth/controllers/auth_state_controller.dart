import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

/// Auth state enumeration
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

/// Auth state class
class AuthState {
  final AuthStatus status;
  final AppUser? user;
  final String? error;

  const AuthState({this.status = AuthStatus.initial, this.user, this.error});

  AuthState copyWith({AuthStatus? status, AppUser? user, String? error}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get hasError => status == AuthStatus.error;
}

/// Auth state notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthStateNotifier(this._authService) : super(const AuthState()) {
    _initializeAuth();
  }

  void _initializeAuth() {
    _authService.authStateChanges().listen((user) async {
      if (user != null) {
        state = state.copyWith(status: AuthStatus.loading);
        try {
          final appUser = await _authService.getCurrentUserData();
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: appUser,
            error: null,
          );
        } catch (e) {
          state = state.copyWith(status: AuthStatus.error, error: e.toString());
        }
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          error: null,
        );
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _authService.login(email, password);
      // State will be updated automatically by auth state listener
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
    }
  }

  Future<void> signUp(String email, String password, UserRole role) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _authService.signUp(email, password, role);
      // State will be updated automatically by auth state listener
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _authService.signOut();
      // State will be updated automatically by auth state listener
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
    }
  }

  Future<void> updateProfile({
    required List<String> categories,
    String? calendlyUrl,
    String? bio,
    String? expertise,
    String? firstName,
    String? lastName,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _authService.updateProfileData(
        categories,
        calendlyUrl,
        bio: bio,
        expertise: expertise,
        firstName: firstName,
        lastName: lastName,
      );

      // Refresh user data
      final updatedUser = await _authService.getCurrentUserData();
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: updatedUser,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// Auth state provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((
  ref,
) {
  return AuthStateNotifier(ref.watch(authServiceProvider));
});

/// Convenience providers
final currentUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(authStateProvider).user;
});

final authStatusProvider = Provider<AuthStatus>((ref) {
  return ref.watch(authStateProvider).status;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isLoading;
});
