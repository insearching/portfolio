import 'package:portfolio/main/data/project.dart';
import 'package:portfolio/main/domain/repositories/project_repository.dart';

/// Use case for getting projects stream
/// Returns a Stream that emits projects progressively from cache layers
/// Emits from: memory -> local -> remote
class GetProjectsStream {
  const GetProjectsStream({required this.projectRepository});

  final ProjectRepository projectRepository;

  Stream<List<Project>> call() {
    try {
      return projectRepository.projectsUpdateStream;
    } catch (e) {
      throw Exception('Failed to load projects stream: $e');
    }
  }
}
