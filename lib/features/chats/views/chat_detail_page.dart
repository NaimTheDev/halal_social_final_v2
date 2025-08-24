import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentor_app/features/auth/controllers/auth_state_controller.dart';
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
  final FocusNode _focusNode = FocusNode();
  late final CollectionReference _chatCollection;

  @override
  void initState() {
    super.initState();
    _chatCollection = FirebaseFirestore.instance.collection('chats');
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
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
    final appUser = ref.read(currentUserProvider);

    if (userId != null && message.trim().isNotEmpty) {
      // Determine receiverId based on whether appUser is mentor or not
      final receiverId =
          appUser?.role == UserRole.mentor ? chat.menteeId : chat.mentorId;

      final newMessage = Message(
        senderId: userId,
        receiverId: receiverId,
        message: message.trim(),
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
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading...'),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            body: const Center(child: Text('Error fetching chat data')),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Not Found'),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            body: const Center(child: Text('Chat not found')),
          );
        }

        final chatData = snapshot.data!.data() as Map<String, dynamic>;
        final chat = Chat.fromMap(widget.chatId, chatData);

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  backgroundImage:
                      chat.mentor?.imageUrl != null
                          ? NetworkImage(chat.mentor!.imageUrl!)
                          : null,
                  child:
                      chat.mentor?.imageUrl == null
                          ? const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.white,
                          )
                          : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.mentor?.name ?? 'Unknown Mentor',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Online',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.video_call),
                onPressed: () {
                  // TODO: Implement video call functionality
                },
              ),
              IconButton(
                icon: const Icon(Icons.call),
                onPressed: () {
                  // TODO: Implement voice call functionality
                },
              ),
            ],
          ),
          backgroundColor: Colors.grey[50],
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
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading messages',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.message_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No messages yet',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Start the conversation!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final messages = snapshot.data!.docs;

                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final senderId = message['senderId'] as String? ?? '';
                        final messageText = message['message'] as String? ?? '';
                        final timestamp = message['timestamp'] as int? ?? 0;
                        final isMe =
                            senderId == FirebaseAuth.instance.currentUser?.uid;

                        return MessageWidget(
                          messageText: messageText,
                          isMe: isMe,
                          timestamp: timestamp,
                        );
                      },
                    );
                  },
                ),
              ),
              _buildMessageInput(chat),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageInput(Chat chat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                focusNode: _focusNode,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _sendMessage(value, chat);
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                if (_messageController.text.trim().isNotEmpty) {
                  _sendMessage(_messageController.text, chat);
                  _focusNode.requestFocus();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
