import 'package:portfolio/main/domain/model/skill.dart';

/// Repository interface for managing skills
/// Defines the contract for skill data operations
abstract class SkillRepository {
  /// Adds a new skill
  Future<void> addSkill(Skill skill);

  /// Forces a refresh from remote, bypassing all caches
  Future<List<Skill>> refreshSkills();

  /// Stream that emits skills progressively from cache layers
  /// Emits from: memory -> local -> remote
  Stream<List<Skill>> get skillsUpdateStream;
}
