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
}

enum EducationType{
  college,
  certification
}
