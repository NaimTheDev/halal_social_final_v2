import 'package:flutter/material.dart';
import '../../models/mentor.dart';

class MentorCard extends StatelessWidget {
  final Mentor mentor;
  final VoidCallback onTap;
  final Widget? actions; // Optional parameter for additional actions

  const MentorCard({
    super.key,
    required this.mentor,
    required this.onTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(mentor.imageUrl),
            ),
            title: Text(mentor.name),
            subtitle: Text(mentor.expertise),
            onTap: onTap,
          ),
          if (actions != null) actions!,
        ],
      ),
    );
  }
}
