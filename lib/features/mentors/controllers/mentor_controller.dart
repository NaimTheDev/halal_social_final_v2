import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/mentor.dart';

final mentorsProvider = FutureProvider<List<Mentor>>((ref) async {
  final snapshot = await FirebaseFirestore.instance.collection('mentors').get();
  return snapshot.docs.map((doc) => Mentor.fromMap(doc.id, doc.data())).toList();
});