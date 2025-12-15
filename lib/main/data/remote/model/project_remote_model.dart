class ProjectRemoteModel {
  const ProjectRemoteModel({
    required this.image,
    required this.title,
    required this.role,
    required this.description,
    this.link,
  });

  final String image;
  final String title;
  final String role;
  final String description;
  final String? link;
}
