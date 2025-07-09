import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentor_app/features/auth/controllers/auth_controller.dart';
import 'package:mentor_app/features/auth/models/app_user.dart';
import 'package:mentor_app/models/chat.dart';

/// Provider for active chats count
final activeChatsProvider = StreamProvider<List<Chat>>((ref) async* {
  final appUser = await ref.watch(currentUserProvider.future);

  if (appUser == null) {
    yield [];
    return;
  }

  final chatCollection = FirebaseFirestore.instance.collection('chats');

  // Filter chats where the current user is either mentor or mentee
  yield* chatCollection
      .where('mentorId', isEqualTo: appUser.uid)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs
                .map((doc) => Chat.fromMap(doc.id, doc.data()))
                .toList(),
      )
      .asyncMap((mentorChats) async {
        // Also get chats where user is a mentee
        final menteeChatsSnapshot =
            await chatCollection
                .where('menteeId', isEqualTo: appUser.uid)
                .get();

        final menteeChats =
            menteeChatsSnapshot.docs
                .map((doc) => Chat.fromMap(doc.id, doc.data()))
                .toList();

        // Combine both lists and remove duplicates
        final allChats = [...mentorChats, ...menteeChats];
        final uniqueChats = <String, Chat>{};

        for (final chat in allChats) {
          uniqueChats[chat.chatId] = chat;
        }

        return uniqueChats.values.toList();
      });
});

/// Provider for active chats count
final activeChatsCountProvider = Provider<int>((ref) {
  final chatsAsync = ref.watch(activeChatsProvider);
  return chatsAsync.when(
    data: (chats) => chats.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

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
