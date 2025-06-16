import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../services/auth_service.dart';
import '../models/app_user.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateChangesProvider = StreamProvider((ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});

final currentUserProvider = FutureProvider<AppUser?>((ref) async {
  return ref.watch(authServiceProvider).getCurrentUserData();
});