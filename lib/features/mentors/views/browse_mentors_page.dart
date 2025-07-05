import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/mentor.dart';
import 'mentor_profile_page.dart';
import 'widgets/mentor_card.dart';

class BrowseMentorsPage extends ConsumerWidget {
  const BrowseMentorsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Mentors')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('mentors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading mentors'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No mentors available'));
          }

          final mentors =
              snapshot.data!.docs
                  .map(
                    (doc) => Mentor.fromMap(
                      doc.id,
                      doc.data() as Map<String, dynamic>,
                    ),
                  )
                  .toList();

          return ListView.builder(
            itemCount: mentors.length,
            itemBuilder: (context, index) {
              final mentor = mentors[index];
              return MentorCard(
                mentor: mentor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MentorProfilePage(mentor: mentor),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
