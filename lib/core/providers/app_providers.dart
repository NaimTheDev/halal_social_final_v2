import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../services/storage_service.dart';

/// Core Firebase providers
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

/// Storage service provider
final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(),
);

/// App initialization provider
final appInitializationProvider = FutureProvider<void>((ref) async {
  try {
    print('🔥 Starting app initialization...');
    if (Firebase.apps.isEmpty) {
      print('🔥 Initializing Firebase...');
      await Firebase.initializeApp();
      print('🔥 Firebase initialized successfully');
    } else {
      print('🔥 Firebase already initialized');
    }
    print('🔥 App initialization completed');
  } catch (e, stackTrace) {
    print('❌ App initialization failed: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
});
