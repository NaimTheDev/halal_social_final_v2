import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../features/auth/views/login_page.dart';
import '../../features/auth/views/signup_page.dart';
import '../../features/auth/views/auth_page.dart';
import '../../features/shell/main_shell_page.dart';
import '../../features/mentors/views/browse_mentors_page.dart';
import '../../features/chats/views/chats_page.dart';
import '../../features/chats/views/chat_detail_page.dart';
import '../../features/calls/views/calls_page_improved.dart';
import '../../features/settings/views/settings_page.dart';

/// App routes
class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String auth = '/auth';
  static const String mentors = '/mentors';
  static const String chats = '/chats';
  static const String chatDetail = '/chat-detail';
  static const String calls = '/calls';
  static const String settings = '/settings';
  static const String profile = '/profile';
}

/// Route generator
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const MainShellPage());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());

      case AppRoutes.auth:
        return MaterialPageRoute(builder: (_) => const AuthPage());

      case AppRoutes.mentors:
        return MaterialPageRoute(builder: (_) => const BrowseMentorsPage());

      case AppRoutes.chats:
        return MaterialPageRoute(builder: (_) => const ChatsPage());

      case AppRoutes.chatDetail:
        final chatId = settings.arguments as String?;
        if (chatId != null) {
          return MaterialPageRoute(
            builder: (_) => ChatDetailPage(chatId: chatId),
          );
        }
        return _errorRoute();

      case AppRoutes.calls:
        return MaterialPageRoute(builder: (_) => const CallsPage());

      case AppRoutes.settings:
        return MaterialPageRoute(
          builder:
              (context) => Consumer(
                builder: (context, ref, child) => SettingsPage(ref: ref),
              ),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Page not found')),
          ),
    );
  }
}

/// Navigation extension for easy navigation
extension NavigationExtension on BuildContext {
  void pushNamed(String routeName, {Object? arguments}) {
    Navigator.pushNamed(this, routeName, arguments: arguments);
  }

  void pushReplacementNamed(String routeName, {Object? arguments}) {
    Navigator.pushReplacementNamed(this, routeName, arguments: arguments);
  }

  void pushNamedAndRemoveUntil(String routeName, {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      this,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  void pop([Object? result]) {
    Navigator.pop(this, result);
  }
}

/// Navigation provider
final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});

/// Navigation service
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  static Future<dynamic> replaceWith(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  static void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
