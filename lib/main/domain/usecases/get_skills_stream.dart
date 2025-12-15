import 'package:portfolio/main/domain/model/skill.dart';
import 'package:portfolio/main/domain/repositories/skill_repository.dart';

/// Use case for getting skills stream
/// Returns a Stream that emits skills progressively from cache layers
/// Emits from: memory -> local -> remote
class GetSkillsStream {
  const GetSkillsStream({required this.skillRepository});

  final SkillRepository skillRepository;

  Stream<List<Skill>> call() {
    try {
      return skillRepository.skillsUpdateStream;
    } catch (e) {
      throw Exception('Failed to load skills stream: $e');
    }
  }
}
