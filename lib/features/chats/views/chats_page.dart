import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentor_app/models/chat.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final CollectionReference _chatCollection = FirebaseFirestore.instance
      .collection('chats');
  List<Chat> _activeChats = [];

  @override
  void initState() {
    super.initState();
    _fetchActiveChats();
  }

  void _fetchActiveChats() {
    _chatCollection.snapshots().listen((snapshot) {
      setState(() {
        _activeChats =
            snapshot.docs.map((doc) {
              return Chat.fromMap(doc.id, doc.data() as Map<String, dynamic>);
            }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body:
          _activeChats.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No active chats yet.',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/mentors');
                      },
                      child: const Text('Start Chatting with a Mentor'),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: _activeChats.length,
                itemBuilder: (context, index) {
                  final chat = _activeChats[index];
                  return ListTile(
                    title: Text('Chat with ${chat.mentor!.name}'),
                    subtitle: Text(
                      'Last active: ${DateTime.fromMillisecondsSinceEpoch(chat.timestamp).toLocal().toString().split('.').first}',
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/chat-detail',
                        arguments: chat.chatId,
                      );
                    },
                  );
                },
              ),
    );
  }
}
