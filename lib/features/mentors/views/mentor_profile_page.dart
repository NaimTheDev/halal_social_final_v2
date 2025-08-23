import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mentor_app/features/auth/controllers/auth_state_controller.dart';
import 'package:mentor_app/models/chat.dart';
import 'package:mentor_app/shared/widgets/calendly_embed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentor_app/features/mentors/providers/mentor_provider.dart';

import '../../mentors/models/mentor.dart';

class MentorProfilePage extends ConsumerStatefulWidget {
  final Mentor mentor;

  const MentorProfilePage({super.key, required this.mentor});

  @override
  ConsumerState<MentorProfilePage> createState() => _MentorProfilePageState();
}

class _MentorProfilePageState extends ConsumerState<MentorProfilePage> {
  Future<bool> _checkChatExists(String mentorId) async {
    final DocumentSnapshot chatDoc =
        await FirebaseFirestore.instance
            .collection('chats')
            .doc('chatId_$mentorId')
            .get();
    return chatDoc.exists;
  }

  @override
  Widget build(BuildContext context) {
    final appUser = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppBar(title: Text(widget.mentor.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
                  widget.mentor.imageUrl != null
                      ? NetworkImage(widget.mentor.imageUrl!)
                      : null,
              child:
                  widget.mentor.imageUrl == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              widget.mentor.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              widget.mentor.expertise,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const Text(
            "About",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(widget.mentor.bio),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => CalendlyEmbed(
                        calendlyUrl: widget.mentor.calendlyUrl!,
                      ),
                ),
              );
            },
            child: const Text("Schedule a Call"),
          ),
          const SizedBox(height: 16),
          FutureBuilder<bool>(
            future: _checkChatExists(widget.mentor.id),
            builder: (context, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final chatExists = chatSnapshot.data ?? false;
              return ElevatedButton(
                onPressed: () {
                  if (chatExists) {
                    FirebaseFirestore.instance
                        .collection('chats')
                        .doc('chatId_${widget.mentor.id}')
                        .get()
                        .then((doc) {
                          if (doc.exists) {
                            final chat = Chat.fromMap(
                              doc.id,
                              doc.data() as Map<String, dynamic>,
                            );
                            Navigator.pushNamed(
                              context,
                              '/chat-detail',
                              arguments: chat.chatId,
                            );
                          }
                        });
                    Navigator.pushNamed(
                      context,
                      '/chat-detail',
                      arguments: 'chatId_${widget.mentor.id}',
                    );
                  } else {
                    ref.read(mentorProvider(widget.mentor.id)).whenData((
                      mentor,
                    ) {
                      FirebaseFirestore.instance
                          .collection('chats')
                          .doc('chatId_${mentor.id}')
                          .set({
                            'mentorId': mentor.id,
                            'menteeId': appUser!.uid,
                            'timestamp': DateTime.now().millisecondsSinceEpoch,
                            'mentor': mentor.toMap(),
                          });
                      // navigate to the chat immediately after creating in firestore
                      Navigator.pushNamed(
                        context,
                        '/chat-detail',
                        arguments: 'chatId_${mentor.id}',
                      );
                    });
                  }
                },
                child: Text(
                  chatExists ? 'Continue Conversation' : 'Start a Chat',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
