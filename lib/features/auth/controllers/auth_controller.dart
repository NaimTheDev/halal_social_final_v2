import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref));

final authStateChangesProvider = StreamProvider((ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});
