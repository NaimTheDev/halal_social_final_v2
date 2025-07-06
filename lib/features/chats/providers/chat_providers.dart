import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentor_app/features/auth/controllers/auth_controller.dart';
import 'package:mentor_app/features/auth/models/app_user.dart';

final receiverIdProvider = FutureProvider.family<String?, String>((
  ref,
  chatId,
) async {
  final appUser = await ref.watch(currentUserProvider.future);
  final chatCollection = FirebaseFirestore.instance.collection('chats');
  final chatDoc = await chatCollection.doc(chatId).get();

  if (chatDoc.exists && appUser != null) {
    return appUser.role == UserRole.mentor
        ? chatDoc['menteeId'] as String
        : chatDoc['mentorId'] as String;
  }
  return null;
});
