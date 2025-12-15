import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/domain/repositories/education_repository.dart';

/// Use case for getting education stream
/// Returns a Stream that emits education progressively from cache layers
/// Emits from: memory -> local -> remote
class GetEducationStream {
  const GetEducationStream({required this.educationRepository});

  final EducationRepository educationRepository;

  Stream<List<Education>> call() {
    try {
      return educationRepository.educationUpdateStream;
    } catch (e) {
      throw Exception('Failed to load education stream: $e');
    }
  }
}
