class Mentor {
  final String id;
  final String name;
  final String bio;
  final String expertise;
  final String imageUrl;
  final String? calendlyUrl;

  Mentor({
    required this.id,
    required this.name,
    required this.bio,
    required this.expertise,
    required this.imageUrl,
    this.calendlyUrl,
  });

  factory Mentor.fromMap(String id, Map<String, dynamic> data) {
    return Mentor(
      id: id,
      name: data['name'] ?? '',
      bio: data['bio'] ?? '',
      expertise: data['expertise'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      calendlyUrl: data['calendlyUrl'],
    );
  }
}