import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Export the ConnectlyLogo widget
export 'connectly_logo.dart';

/// Error boundary widget that catches and displays errors
class ErrorBoundary extends ConsumerWidget {
  final Widget child;
  final String? fallbackMessage;
  final VoidCallback? onRetry;

  const ErrorBoundary({
    Key? key,
    required this.child,
    this.fallbackMessage,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return child;
  }
}

/// Error widget for displaying errors consistently
class ErrorDisplay extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const ErrorDisplay({
    Key? key,
    required this.title,
    required this.message,
    this.onRetry,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon ?? Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading widget for displaying loading states consistently
class LoadingDisplay extends StatelessWidget {
  final String? message;

  const LoadingDisplay({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Empty state widget for displaying empty states consistently
class EmptyStateDisplay extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final Widget? action;

  const EmptyStateDisplay({
    Key? key,
    required this.title,
    required this.message,
    this.icon,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}

/// Async value widget for handling async states consistently
class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget Function()? loading;
  final Widget Function(Object error, StackTrace stackTrace)? error;

  const AsyncValueWidget({
    Key? key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: loading ?? () => const LoadingDisplay(),
      error:
          error ??
          (err, stack) => ErrorDisplay(
            title: 'Error',
            message: err.toString(),
            onRetry: () {
              // Implement retry logic if needed
            },
          ),
    );
  }
}
