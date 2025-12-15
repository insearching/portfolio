import 'package:portfolio/main/domain/model/project.dart';
import 'package:portfolio/main/domain/repositories/project_repository.dart';

/// Use case for adding a new project
class AddProject {
  AddProject({required this.projectRepository});

  final ProjectRepository projectRepository;

  /// Adds a new project
  Future<void> call(Project project) async {
    try {
      await projectRepository.addProject(project);
    } catch (e) {
      throw Exception('Failed to add project: $e');
    }
  }
}
