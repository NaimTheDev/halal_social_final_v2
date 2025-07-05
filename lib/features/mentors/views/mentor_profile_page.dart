import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mentor_app/features/auth/controllers/auth_controller.dart';
import 'package:mentor_app/shared/widgets/calendly_embed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    final appUserAsync = ref.watch(currentUserProvider);
    final appUser = appUserAsync.asData?.value;
    return Scaffold(
      appBar: AppBar(title: Text(widget.mentor.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(widget.mentor.imageUrl),
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
                    Navigator.pushNamed(context, '/Chats');
                  } else {
                    // Create a new chat and navigate
                    FirebaseFirestore.instance
                        .collection('chats')
                        .doc('chatId_${widget.mentor.id}')
                        .set({
                          'mentorId': widget.mentor.id,
                          'menteeId':
                              appUser!.uid, // Replace with actual user ID
                          'timestamp': DateTime.now().millisecondsSinceEpoch,
                        });
                    Navigator.pushNamed(context, '/Chats');
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
