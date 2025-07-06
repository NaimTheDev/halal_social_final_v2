enum UserRole { mentor, mentee }

class AppUser {
  final String uid;
  final String email;
  final UserRole role;
  final String? imageUrl;
  final String? name;
  final String? firstName;
  final String? lastName;

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
    this.imageUrl,
    this.name,
    this.firstName,
    this.lastName,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      role: data['role'] == 'mentor' ? UserRole.mentor : UserRole.mentee,
      imageUrl: data['imageUrl'] as String?,
      name:
          (data['firstName'] != null && data['lastName'] != null)
              ? '${data['firstName']}${data['lastName']}'
              : data['name'] as String?,
      firstName: data['firstName'] as String?,
      lastName: data['lastName'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'role': role.name,
    'name': (firstName ?? '') + (lastName ?? ''),
  };
}
