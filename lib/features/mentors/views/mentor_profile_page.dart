import 'package:flutter/material.dart';
import 'package:mentor_app/shared/widgets/calendly_embed.dart';

import '../../mentors/models/mentor.dart';

class MentorProfilePage extends StatelessWidget {
  final Mentor mentor;

  const MentorProfilePage({super.key, required this.mentor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(mentor.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(mentor.imageUrl),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              mentor.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              mentor.expertise,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const Text("About", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(mentor.bio),
          const SizedBox(height: 24),
  ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CalendlyEmbed(calendlyUrl: mentor.calendlyUrl!),
      ),
    );
  },
  child: const Text("Schedule a Call"),
),
        ],
      ),
    );
  }
}