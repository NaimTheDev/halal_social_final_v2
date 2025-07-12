class Mentor {
  final String id;
  final String name;
  final String bio;
  final String expertise;
  final String? imageUrl;
  final String? calendlyUrl;
  final String? calendlyOrgId;
  final String? calendlyPAT;
  final String? calendlyUserUri;
  final List<String>? categories;
  final String? firstName;
  final String? lastName;

  Mentor({
    required this.id,
    required this.name,
    required this.bio,
    required this.expertise,
    required this.imageUrl,
    this.calendlyUrl,
    this.calendlyOrgId,
    this.calendlyPAT,
    this.calendlyUserUri,
    this.categories,
    this.firstName,
    this.lastName,
  });

  factory Mentor.fromMap(String id, Map<String, dynamic> data) {
    return Mentor(
      id: id,
      name: data['name'] ?? '',
      bio: data['bio'] ?? '',
      expertise: data['expertise'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      calendlyUrl: data['calendlyUrl'],
      calendlyOrgId: data['calendlyOrgId'],
      calendlyPAT: data['calendlyPAT'],
      calendlyUserUri: data['calendlyUserUri'],
      categories:
          (data['categories'] as List<dynamic>?)
              ?.map((cat) => cat.toString())
              .toList(),
      firstName: data['firstName'] as String?,
      lastName: data['lastName'] as String?,
    );
  }

  factory Mentor.fromJson(Map<String, dynamic> json) {
    return Mentor(
      id: json['id'] ?? '',
      name:
          (json['firstName'] != null && json['lastName'] != null)
              ? '${json['firstName']} ${json['lastName']}'
              : (json['name'] ?? ''),
      bio: json['bio'] ?? '',
      expertise: json['expertise'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      calendlyUrl: json['calendlyUrl'],
      calendlyOrgId: json['calendlyOrgId'],
      calendlyPAT: json['calendlyPAT'],
      calendlyUserUri: json['calendlyUserUri'],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((cat) => cat.toString())
              .toList(),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'expertise': expertise,
      'imageUrl': imageUrl,
      'calendlyUrl': calendlyUrl,
      'calendlyOrgId': calendlyOrgId,
      'calendlyPAT': calendlyPAT,
      'calendlyUserUri': calendlyUserUri,
      'categories': categories,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
