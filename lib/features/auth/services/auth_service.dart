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
    String? calendlyUrl, {
    String? bio,
    String? expertise,
    String? firstName,
    String? lastName,
  }) async {
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
    if (bio != null && bio.isNotEmpty) {
      data['bio'] = bio;
    }
    if (expertise != null && expertise.isNotEmpty) {
      data['expertise'] = expertise;
    }
    if (firstName != null && firstName.isNotEmpty) {
      data['firstName'] = firstName;
    }
    if (lastName != null && lastName.isNotEmpty) {
      data['lastName'] = lastName;
    }

    await _firestore.collection('users').doc(user.uid).update(data);

    // Push mentor data to Firestore if the user is a mentor
    // Fetch the user's role from Firestore to check if they are a mentor
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final userRole = userDoc.data()?['role'];

    if (userRole == 'mentor') {
      final mentorData = {
        'id': user.uid,
        'email': user.email ?? '',
        'firstName': firstName,
        'lastName': lastName,
        'bio': bio ?? '',
        'expertise': expertise ?? '',
        'calendlyUrl': calendlyUrl ?? '',
        'categories': categories,
      };
      await _firestore.collection('mentors').doc(user.uid).set(mentorData);
    }
  }

  /// Updates the user's profile image URL
  Future<void> updateProfileImage(String imageUrl) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No authenticated user to update profile for.',
      );
    }

    await _firestore.collection('users').doc(user.uid).update({
      'imageUrl': imageUrl,
    });

    // Also update mentor collection if user is a mentor
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final userRole = userDoc.data()?['role'];

    if (userRole == 'mentor') {
      await _firestore.collection('mentors').doc(user.uid).update({
        'imageUrl': imageUrl,
      });
    }
  }

  /// Updates mentor's Calendly information
  Future<void> updateMentorCalendlyInfo({
    String? calendlyUrl,
    String? calendlyOrgId,
    String? calendlyPAT,
    String? calendlyUserUri,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No authenticated user to update profile for.',
      );
    }

    // Check if user is a mentor
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final userRole = userDoc.data()?['role'];

    if (userRole != 'mentor') {
      throw FirebaseAuthException(
        code: 'not-a-mentor',
        message: 'Only mentors can update Calendly information.',
      );
    }

    final mentorData = <String, dynamic>{};
    if (calendlyUrl != null) mentorData['calendlyUrl'] = calendlyUrl;
    if (calendlyOrgId != null) mentorData['calendlyOrgId'] = calendlyOrgId;
    if (calendlyPAT != null) mentorData['calendlyPAT'] = calendlyPAT;
    if (calendlyUserUri != null)
      mentorData['calendlyUserUri'] = calendlyUserUri;

    if (mentorData.isNotEmpty) {
      await _firestore.collection('mentors').doc(user.uid).update(mentorData);
    }
  }
}
