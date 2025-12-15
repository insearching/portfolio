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
}

enum SkillType { hard, soft }
