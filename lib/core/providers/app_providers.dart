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
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
});
