import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/mentors/models/mentor.dart';
import '../features/auth/models/app_user.dart';

Future<void> seedFirestoreData() async {
  final firestore = FirebaseFirestore.instance;

  // Seed Mentor data
  final mentors = [
    Mentor(
      id: 'mentor1',
      name: 'John Doe',
      bio: 'Experienced software engineer with a passion for teaching.',
      expertise: 'Software Engineering',
      imageUrl: 'https://example.com/john_doe.jpg',
      calendlyUrl: 'https://calendly.com/john_doe',
      categories: ['Technology', 'Programming'],
    ),
    Mentor(
      id: 'mentor2',
      name: 'Jane Smith',
      bio: 'Nutritionist helping people achieve their health goals.',
      expertise: 'Nutrition',
      imageUrl: 'https://example.com/jane_smith.jpg',
      calendlyUrl: 'https://calendly.com/jane_smith',
      categories: ['Health', 'Wellness'],
    ),
  ];

  for (var mentor in mentors) {
    await firestore.collection('mentors').doc(mentor.id).set({
      'name': mentor.name,
      'bio': mentor.bio,
      'expertise': mentor.expertise,
      'imageUrl': mentor.imageUrl,
      'calendlyUrl': mentor.calendlyUrl,
      'categories': mentor.categories,
    });
  }

  // Seed AppUser data
  final users = [
    AppUser(
      uid: 'user1',
      email: 'user1@example.com',
      role: UserRole.mentor,
      imageUrl: 'https://example.com/user1.jpg',
    ),
    AppUser(
      uid: 'user2',
      email: 'user2@example.com',
      role: UserRole.mentee,
      imageUrl: 'https://example.com/user2.jpg',
    ),
  ];

  for (var user in users) {
    await firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'role': user.role.name,
      'imageUrl': user.imageUrl,
    });
  }

  print('Firestore seeding completed!');
}
