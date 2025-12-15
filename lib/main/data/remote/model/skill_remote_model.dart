class SkillRemoteModel {
  const SkillRemoteModel({
    required this.title,
    required this.value,
    required this.type,
  });

  final String title;
  final int value;

  /// Expected values: "hard" | "soft".
  final String type;
}
