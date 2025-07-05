import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatDetailPage extends StatefulWidget {
  final String chatId;

  const ChatDetailPage({super.key, required this.chatId});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final CollectionReference _chatCollection = FirebaseFirestore.instance
      .collection('chats');
  String? _receiverId;

  @override
  void initState() {
    super.initState();
    _fetchReceiverId();
  }

  void _fetchReceiverId() async {
    final DocumentSnapshot chatDoc =
        await _chatCollection.doc(widget.chatId).get();
    if (chatDoc.exists) {
      setState(() {
        _receiverId = chatDoc['receiverId'] as String;
      });
    }
  }

  void _sendMessage(String message) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null && _receiverId != null) {
      _chatCollection.doc(widget.chatId).collection('messages').add({
        'senderId': userId,
        'receiverId': _receiverId,
        'message': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Detail: ${widget.chatId}')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Chat details for chat ID: ${widget.chatId} will be implemented here.',
              ),
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
                  onPressed: () => _sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
