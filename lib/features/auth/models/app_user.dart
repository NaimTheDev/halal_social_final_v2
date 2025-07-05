enum UserRole { mentor, mentee }

class AppUser {
  final String uid;
  final String email;
  final UserRole role;
  final String? imageUrl;

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
    this.imageUrl,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      role: data['role'] == 'mentor' ? UserRole.mentor : UserRole.mentee,
      imageUrl: data['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {'email': email, 'role': role.name};
}
