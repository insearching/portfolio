class EducationRemoteModel {
  const EducationRemoteModel({
    required this.title,
    required this.description,
    required this.type,
    this.text,
    this.link,
    this.imageUrl,
  });

  final String title;
  final String description;

  /// Expected values: "college" | "certification".
  final String type;
  final String? text;
  final String? link;
  final String? imageUrl;
}
