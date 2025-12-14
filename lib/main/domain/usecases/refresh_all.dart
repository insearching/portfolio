import 'package:portfolio/main/domain/repositories/blog_repository.dart';
import 'package:portfolio/main/domain/repositories/education_repository.dart';
import 'package:portfolio/main/domain/repositories/position_repository.dart';
import 'package:portfolio/main/domain/repositories/project_repository.dart';
import 'package:portfolio/main/domain/repositories/skill_repository.dart';

/// Use case for refreshing all remote repositories
/// Refreshes all remote repositories, bypassing all caches
/// Forces fresh data from Firebase for posts, positions, projects, education, and skills
/// This is useful for ensuring the latest data is displayed on web
class RefreshAll {
  const RefreshAll({
    required this.blogRepository,
    required this.positionRepository,
    required this.projectRepository,
    required this.educationRepository,
    required this.skillRepository,
  });

  final BlogRepository blogRepository;
  final PositionRepository positionRepository;
  final ProjectRepository projectRepository;
  final EducationRepository educationRepository;
  final SkillRepository skillRepository;

  Future<void> call() async {
    try {
      // Refresh all repositories in parallel
      await Future.wait<void>([
        blogRepository.refreshPosts(),
        positionRepository.refreshPositions(),
        projectRepository.refreshProjects(),
        educationRepository.refreshEducation(),
        skillRepository.refreshSkills(),
      ]);
    } catch (e) {
      throw Exception('Failed to refresh repositories: $e');
    }
  }
}
