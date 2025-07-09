import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Error types for better error handling
enum ErrorType { network, authentication, authorization, validation, unknown }

/// Custom error class
class AppError {
  final ErrorType type;
  final String message;
  final String? code;
  final dynamic originalError;

  const AppError({
    required this.type,
    required this.message,
    this.code,
    this.originalError,
  });

  factory AppError.network(String message) =>
      AppError(type: ErrorType.network, message: message);

  factory AppError.authentication(String message, {String? code}) =>
      AppError(type: ErrorType.authentication, message: message, code: code);

  factory AppError.authorization(String message) =>
      AppError(type: ErrorType.authorization, message: message);

  factory AppError.validation(String message) =>
      AppError(type: ErrorType.validation, message: message);

  factory AppError.unknown(String message, {dynamic originalError}) => AppError(
    type: ErrorType.unknown,
    message: message,
    originalError: originalError,
  );

  String get displayMessage {
    switch (type) {
      case ErrorType.network:
        return 'Network error: $message';
      case ErrorType.authentication:
        return 'Authentication error: $message';
      case ErrorType.authorization:
        return 'Authorization error: $message';
      case ErrorType.validation:
        return 'Validation error: $message';
      case ErrorType.unknown:
        return 'An unexpected error occurred: $message';
    }
  }
}

/// Error handler utility
class ErrorHandler {
  static void showError(BuildContext context, AppError error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.displayMessage),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showErrorDialog(BuildContext context, AppError error) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(error.displayMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}

/// Global error state provider
final errorStateProvider = StateProvider<AppError?>((ref) => null);

/// Error handler hook
extension ErrorHandlerExtension on WidgetRef {
  void handleError(AppError error) {
    read(errorStateProvider.notifier).state = error;
  }

  void clearError() {
    read(errorStateProvider.notifier).state = null;
  }
}
