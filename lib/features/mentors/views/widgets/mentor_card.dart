import 'package:flutter/material.dart';
import '../../models/mentor.dart';
import '../mentor_profile_page.dart';

class MentorCard extends StatelessWidget {
  final Mentor mentor;

  const MentorCard({super.key, required this.mentor, required Null Function() onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(mentor.imageUrl)),
        title: Text(mentor.name),
        subtitle: Text(mentor.expertise),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MentorProfilePage(mentor: mentor),
            ),
          );
        },
      ),
    );
  }
}