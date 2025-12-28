class Project {
  const Project({
    required this.image,
    required this.title,
    required this.role,
    required this.description,
    this.link,
    this.order = 0,
  });

  final String image;
  final String title;
  final String role;
  final String description;
  final String? link;
  final int order;
}
