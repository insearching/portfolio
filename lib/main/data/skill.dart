class Skill {
  const Skill({
    required this.title,
    required this.value,
    required this.type,
  });

  final String title;
  final int value;
  final SkillType type;

  factory Skill.soft(String title, int value) {
    return Skill(title: title, value: value, type: SkillType.soft);
  }

  factory Skill.hard(String title, int value) {
    return Skill(title: title, value: value, type: SkillType.hard);
  }

  /// Creates a Skill from a JSON map
  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      title: json['title'] as String? ?? '',
      value: json['value'] as int? ?? 0,
      type: _skillTypeFromString(json['type'] as String? ?? 'hard'),
    );
  }

  /// Converts this Skill to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
      'type': type.name,
    };
  }

  /// Helper method to convert string to SkillType
  static SkillType _skillTypeFromString(String type) {
    return type.toLowerCase() == 'soft' ? SkillType.soft : SkillType.hard;
  }
}

enum SkillType { hard, soft }
