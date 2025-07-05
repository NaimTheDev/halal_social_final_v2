import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final CollectionReference _chatCollection = FirebaseFirestore.instance
      .collection('chats');
  List<Map<String, dynamic>> _activeChats = [];

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
              return {'chatId': doc.id, ...doc.data() as Map<String, dynamic>};
            }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: ListView.builder(
        itemCount: _activeChats.length,
        itemBuilder: (context, index) {
          final chat = _activeChats[index];
          return ListTile(
            title: Text('Chat with ${chat['mentorId']}'),
            subtitle: Text(
              'Last active: ${DateTime.fromMillisecondsSinceEpoch(chat['timestamp']).toLocal()}',
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/ChatDetail',
                arguments: chat['chatId'],
              );
            },
          );
        },
      ),
    );
  }
}
