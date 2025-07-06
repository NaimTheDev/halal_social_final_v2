class Mentor {
  final String id;
  final String name;
  final String profilePictureUrl;
  final String? firstName;
  final String? lastName;

  Mentor({
    required this.id,
    required this.name,
    required this.profilePictureUrl,
    this.firstName,
    this.lastName,
  });

  factory Mentor.fromMap(Map<String, dynamic> data) {
    return Mentor(
      id: data['id'] as String,
      name: data['name'] as String,
      profilePictureUrl: data['profilePictureUrl'] as String,
      firstName: data['firstName'] as String?,
      lastName: data['lastName'] as String?,
    );
  }
}
