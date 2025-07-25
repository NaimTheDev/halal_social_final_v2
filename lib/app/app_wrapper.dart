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
          () => const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          ),
      error:
          (error, stackTrace) => MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
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
      title: 'Mentor App',
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
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
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
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
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
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }

  ThemeData _getTheme(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return appTheme;
      case AppTheme.dark:
        return appTheme.copyWith(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(),
        );
    }
  }
}
