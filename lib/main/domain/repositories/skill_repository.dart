import 'package:portfolio/main/data/skill.dart';

/// Repository interface for managing skills
/// Defines the contract for skill data operations
abstract class SkillRepository {
  /// Forces a refresh from remote, bypassing all caches
  Future<List<Skill>> refreshSkills();

  /// Stream that emits skills progressively from cache layers
  /// Emits from: memory -> local -> remote
  Stream<List<Skill>> get skillsUpdateStream;
}
