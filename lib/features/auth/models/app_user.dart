enum UserRole { mentor, mentee }

class AppUser {
  final String uid;
  final String email;
  final UserRole role;

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      role: data['role'] == 'mentor' ? UserRole.mentor : UserRole.mentee,
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'role': role.name,
  };
}