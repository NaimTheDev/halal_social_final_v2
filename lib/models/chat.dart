import 'package:mentor_app/features/mentors/models/mentor.dart';

class Chat {
  final String chatId;
  final String mentorId;
  final String menteeId; // Added menteeId
  final int timestamp;
  final Mentor? mentor;

  Chat({
    required this.chatId,
    required this.mentorId,
    required this.menteeId, // Added menteeId
    required this.timestamp,
    this.mentor,
  });

  factory Chat.fromMap(String id, Map<String, dynamic> data) {
    return Chat(
      chatId: id,
      mentorId: data['mentorId'] as String,
      menteeId: data['menteeId'] as String, // Added menteeId
      timestamp: data['timestamp'] as int,
      mentor:
          data['mentor'] != null
              ? Mentor.fromMap(
                data['mentorId'] as String,
                data['mentor'] as Map<String, dynamic>,
              )
              : null,
    );
  }
}
