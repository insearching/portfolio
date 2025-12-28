import 'package:portfolio/main/domain/model/project.dart';
import 'package:portfolio/main/domain/repositories/project_repository.dart';

/// Use case for adding a new project
class AddProject {
  AddProject({required this.projectRepository});

  final ProjectRepository projectRepository;

  /// Adds a new project after validation
  Future<void> call(Project project) async {
    _validateProject(project);

    try {
      await projectRepository.addProject(project);
    } catch (e) {
      throw Exception('Failed to add project: $e');
    }
  }

  /// Validates the project data before adding
  void _validateProject(Project project) {
    // Validate title
    if (project.title.trim().isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }

    // Validate role
    if (project.role.trim().isEmpty) {
      throw ArgumentError('Role cannot be empty');
    }

    // Validate description
    if (project.description.trim().isEmpty) {
      throw ArgumentError('Description cannot be empty');
    }

    // Validate image link
    if (project.image.trim().isEmpty) {
      throw ArgumentError('Image URL cannot be empty');
    }
    if (!_isValidUrl(project.image)) {
      throw ArgumentError('Image URL must be a valid URL');
    }

    // Validate project link (optional field)
    if (project.link != null && project.link!.trim().isNotEmpty) {
      if (!_isValidUrl(project.link!)) {
        throw ArgumentError('Project link must be a valid URL');
      }
    }
  }

  /// Checks if a string is a valid URL
  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }
}
