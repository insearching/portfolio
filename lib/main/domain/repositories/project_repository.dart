import 'package:portfolio/main/data/project.dart';

/// Repository interface for managing projects
/// Defines the contract for project data operations
abstract class ProjectRepository {
  /// Fetches projects from remote source and caches them locally
  /// Falls back to local cache if remote fetch fails
  Future<List<Project>> readProjects();
}
