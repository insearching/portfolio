class Education {
  final String title;
  final String description;
  final EducationType type;
  final String? text;
  final String? link;
  final String? imageUrl;

  const Education({
    required this.title,
    required this.description,
    required this.type,
    this.text,
    this.link,
    this.imageUrl,
  });

  /// Convert Education to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'type': type.name,
      'text': text,
      'link': link,
      'imageUrl': imageUrl,
    };
  }

  /// Create Education from Map
  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      type: EducationType.values.firstWhere(
        (e) => e.name == (map['type'] as String? ?? 'certification'),
        orElse: () => EducationType.certification,
      ),
      text: map['text'] as String?,
      link: map['link'] as String?,
      imageUrl: map['imageUrl'] as String?,
    );
  }
}

enum EducationType { college, certification }
