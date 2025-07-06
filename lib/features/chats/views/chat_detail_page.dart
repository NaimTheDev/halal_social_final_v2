import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentor_app/features/auth/controllers/auth_controller.dart';
import 'package:mentor_app/features/auth/models/app_user.dart';
import 'package:mentor_app/features/chats/widgets/message_widget.dart';
import 'package:mentor_app/models/message.dart';
import 'package:mentor_app/models/chat.dart';

class ChatDetailPage extends ConsumerStatefulWidget {
  final String chatId;

  const ChatDetailPage({super.key, required this.chatId});

  @override
  ConsumerState<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  late final CollectionReference _chatCollection;

  @override
  void initState() {
    super.initState();
    _chatCollection = FirebaseFirestore.instance.collection('chats');
  }

  Stream<QuerySnapshot> _getMessagesStream() {
    return _chatCollection
        .doc(widget.chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> _sendMessage(String message, Chat chat) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final appUser = await ref.read(currentUserProvider.future);

    if (userId != null) {
      // Determine receiverId based on whether appUser is mentor or not
      final receiverId =
          appUser?.role == UserRole.mentor ? chat.menteeId : chat.mentorId;

      final newMessage = Message(
        senderId: userId,
        receiverId: receiverId,
        message: message,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      await _chatCollection
          .doc(widget.chatId)
          .collection('messages')
          .add(newMessage.toMap());
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _chatCollection.doc(widget.chatId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching chat data'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('Chat not found'));
        }

        final chatData = snapshot.data!.data() as Map<String, dynamic>;
        final chat = Chat.fromMap(widget.chatId, chatData);

        return Scaffold(
          appBar: AppBar(
            title: Text('Chat with ${chat.mentor?.name ?? 'Mentor'}'),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _getMessagesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error loading messages'),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No Messages Yet',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    final messages = snapshot.data!.docs;

                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final senderId = message['senderId'] as String? ?? '';
                        final messageText = message['message'] as String? ?? '';
                        final isMe =
                            senderId == FirebaseAuth.instance.currentUser?.uid;

                        return MessageWidget(
                          messageText: messageText,
                          isMe: isMe,
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your message',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed:
                          () => _sendMessage(_messageController.text, chat),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
