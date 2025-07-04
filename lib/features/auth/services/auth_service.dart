import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> signUp(String email, String password, UserRole role) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null) {
        throw FirebaseAuthException(
          code: 'user-creation-failed',
          message: 'Failed to create user.',
        );
      }

      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'role': role.name,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirebaseAuthException(
        code: 'signup-error',
        message: 'Error during signup: ${e.toString()}',
      );
    }
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<AppUser?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final snapshot = await _firestore.collection('users').doc(user.uid).get();
    return AppUser.fromMap(user.uid, snapshot.data() ?? {});
  }

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('User signed out successfully'); // Debugging log
    } catch (e) {
      print('Error during sign out: ${e.toString()}'); // Debugging log
      throw FirebaseAuthException(
        code: 'signout-error',
        message: 'Error during sign out: ${e.toString()}',
      );
    }
  }

  /// Updates the user's profile with selected categories and optional Calendly URL
  Future<void> updateProfileData(
    List<String> categories,
    String? calendlyUrl,
  ) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No authenticated user to update profile for.',
      );
    }
    final data = <String, dynamic>{'categories': categories};
    if (calendlyUrl != null && calendlyUrl.isNotEmpty) {
      data['calendlyUrl'] = calendlyUrl;
    }
    await _firestore.collection('users').doc(user.uid).update(data);
  }
}
