class PersonalInfo {
  final String image;
  final String title;
  final String description;
  final String email;
  final List<SocialInfo> socials;

  const PersonalInfo({
    required this.image,
    required this.title,
    required this.description,
    required this.email,
    required this.socials,
  });

  /// Creates a PersonalInfo from a JSON map
  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    final rawSocials = json['socials'];

    Iterable<dynamic> socialsIterable;
    if (rawSocials is List) {
      socialsIterable = rawSocials;
    } else if (rawSocials is Map) {
      // In case Firebase returns a Map (e.g. indexed/object map)
      socialsIterable = rawSocials.values;
    } else {
      socialsIterable = const [];
    }

    final socials = socialsIterable
        .whereType<Map>()
        .map((s) => SocialInfo.fromJson(Map<String, dynamic>.from(s)))
        .toList();

    return PersonalInfo(
      image: json['image'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      email: json['email'] as String? ?? '',
      socials: socials,
    );
  }

  /// Converts this PersonalInfo to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
      'description': description,
      'email': email,
      'socials': socials.map((s) => s.toJson()).toList(),
    };
  }
}

enum SocialInfo {
  linkedin(
    url: 'https://www.linkedin.com/in/serhii-hrabas/',
    icon: 'assets/img/linkedin.png',
  ),
  github(url: 'https://github.com/insearching', icon: 'assets/img/github.png'),
  medium(url: 'https://medium.com/@graser1305', icon: 'assets/img/medium.png');

  final String url;
  final String icon;

  const SocialInfo({required this.url, required this.icon});

  /// Creates a SocialInfo from a JSON map
  factory SocialInfo.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String? ?? '';

    // Try to match with enum values
    for (final social in SocialInfo.values) {
      if (social.url == url) {
        return social;
      }
    }

    // If no match, return a default based on URL
    if (url.contains('linkedin')) return SocialInfo.linkedin;
    if (url.contains('github')) return SocialInfo.github;
    if (url.contains('medium')) return SocialInfo.medium;

    return SocialInfo.linkedin; // default fallback
  }

  /// Converts this SocialInfo to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'icon': icon,
    };
  }
}
