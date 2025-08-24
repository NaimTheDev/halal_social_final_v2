import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../core/providers/app_providers.dart';
import '../core/state/app_state.dart';
import '../core/error/error_handler.dart';
import '../features/auth/controllers/auth_state_controller.dart';
import '../features/auth/views/login_page.dart';
import '../features/shell/main_shell_page.dart';
import '../theme/app_theme.dart';
import '../core/navigation/app_router.dart';
import '../shared/widgets/connectly_logo.dart';

/// Global app state provider
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((
  ref,
) {
  return AppStateNotifier();
});

/// App initialization provider
final appInitProvider = FutureProvider<void>((ref) async {
  await ref.read(appInitializationProvider.future);
  ref.read(appStateProvider.notifier).setInitialized(true);
});

/// App wrapper widget that handles initialization and global state
class AppWrapper extends ConsumerWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInit = ref.watch(appInitProvider);

    return appInit.when(
      data: (_) => const _App(),
      loading:
          () => MaterialApp(
            home: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const ConnectlyLogo(
                        height: 100,
                        variant: ConnectlyLogoVariant.full,
                      ),
                      const SizedBox(height: 30),
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFFF8C00),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Initializing...',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      error:
          (error, stackTrace) => MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to initialize app',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(appInitProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}

/// Main app widget
class _App extends ConsumerWidget {
  const _App();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final appState = ref.watch(appStateProvider);
    final error = ref.watch(errorStateProvider);

    // Handle global errors
    if (error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ErrorHandler.showError(context, error);
        ref.clearError();
      });
    }

    return MaterialApp(
      title: 'Connectly',
      theme: _getTheme(appState.theme),
      home: _buildHome(authState),
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _buildHome(AuthState authState) {
    return Consumer(
      builder: (context, ref, child) {
        switch (authState.status) {
          case AuthStatus.loading:
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ConnectlyLogo(
                      height: 100,
                      variant: ConnectlyLogoVariant.full,
                    ),
                    const SizedBox(height: 30),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF8C00),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Signing you in...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          case AuthStatus.authenticated:
            return const MainShellPage();
          case AuthStatus.unauthenticated:
            return const LoginPage();
          case AuthStatus.error:
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Authentication Error',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      authState.error ?? 'Unknown error',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Clear error and retry
                        ref.read(authStateProvider.notifier).clearError();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          case AuthStatus.initial:
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ConnectlyLogo(
                      height: 100,
                      variant: ConnectlyLogoVariant.full,
                    ),
                    const SizedBox(height: 30),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF8C00),
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }

  ThemeData _getTheme(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return lightTheme;
      case AppTheme.dark:
        return lightTheme.copyWith(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(),
        );
    }
  }
}
