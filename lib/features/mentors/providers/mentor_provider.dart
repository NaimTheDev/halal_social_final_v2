import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/mentor.dart';

final mentorProvider = FutureProvider.family<Mentor, String>((
  ref,
  mentorId,
) async {
  final docSnapshot =
      await FirebaseFirestore.instance
          .collection('mentors')
          .doc(mentorId)
          .get();

  if (!docSnapshot.exists) {
    throw Exception('Mentor not found');
  }

  return Mentor.fromJson(docSnapshot.data()!);
});
