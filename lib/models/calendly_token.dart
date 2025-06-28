class CalendlyToken {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String organizationUri;
  final String userUri;

  CalendlyToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.organizationUri,
    required this.userUri,
  });

  factory CalendlyToken.fromJson(Map<String, dynamic> json) {
    return CalendlyToken(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      organizationUri: json['organizationUri'] as String,
      userUri: json['userUri'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
      'organizationUri': organizationUri,
      'userUri': userUri,
    };
  }
}
