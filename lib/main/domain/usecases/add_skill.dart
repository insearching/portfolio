import 'package:portfolio/main/domain/model/skill.dart';
import 'package:portfolio/main/domain/repositories/skill_repository.dart';

/// Use case for adding a new skill
class AddSkill {
  AddSkill({required this.skillRepository});

  final SkillRepository skillRepository;

  /// Adds a new skill
  Future<void> call(Skill skill) async {
    try {
      await skillRepository.addSkill(skill);
    } catch (e) {
      throw Exception('Failed to add skill: $e');
    }
  }
}
