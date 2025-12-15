import 'package:portfolio/main/domain/model/project.dart';

/// Repository interface for managing projects
/// Defines the contract for project data operations
abstract class ProjectRepository {
  /// Adds a new project
  Future<void> addProject(Project project);

  /// Forces a refresh from remote, bypassing all caches
  Future<List<Project>> refreshProjects();

  /// Stream that emits projects progressively from cache layers
  /// Emits from: memory -> local -> remote
  Stream<List<Project>> get projectsUpdateStream;
}
