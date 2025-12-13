import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/data/local/static_data/repository.dart';
import 'package:portfolio/main/data/personal_info.dart';
import 'package:portfolio/main/data/position.dart';
import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/data/project.dart';
import 'package:portfolio/main/data/skill.dart';
import 'package:portfolio/main/domain/repositories/blog_repository.dart';
import 'package:portfolio/main/domain/repositories/position_repository.dart';
import 'package:portfolio/main/domain/repositories/project_repository.dart';

/// Centralized repository for all portfolio static_data
/// Combines local static_data and remote static_data sources (Firebase)
/// This is the single source of truth for all portfolio information
class PortfolioRepository {
  PortfolioRepository({
    required this.blogRepository,
    required this.positionRepository,
    required this.projectRepository,
  });

  final BlogRepository blogRepository;
  final PositionRepository positionRepository;
  final ProjectRepository projectRepository;

  // Personal Information
  PersonalInfo getPersonalInfo() => Repository.info;

  String getUserName() => Repository.info.title;

  String getUserEmail() => Repository.info.email;

  // Skills
  List<Skill> getSkills() => Repository.skills;

  // Education
  List<Education> getEducation() => Repository.educationInfo;

  // Projects - Remote data (from Firebase)
  Future<List<Project>> getProjects() async {
    try {
      return await projectRepository.readProjects();
    } catch (e) {
      throw Exception('Failed to load projects: $e');
    }
  }

  // Resume Tabs
  List<String> getResumeTabs() => Repository.tabs;

  // Remote static_data - Posts (from Firebase)
  Future<List<Post>> getPosts() async {
    try {
      return await blogRepository.readPosts();
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }

  // Remote static_data - Positions (from Firebase)
  Future<List<Position>> getPositions() async {
    try {
      return await positionRepository.readPositions();
    } catch (e) {
      throw Exception('Failed to load positions: $e');
    }
  }

  /// Refreshes all remote repositories, bypassing all caches
  /// Forces fresh data from Firebase for posts, positions, and projects
  /// This is useful for ensuring the latest data is displayed on web
  Future<void> refreshAll() async {
    try {
      // Cast to implementation types to access refresh methods
      final blogRepoImpl = blogRepository as dynamic;
      final positionRepoImpl = positionRepository as dynamic;
      final projectRepoImpl = projectRepository as dynamic;

      // Refresh all repositories in parallel
      await Future.wait<void>([
        blogRepoImpl.refreshPosts() as Future<void>,
        positionRepoImpl.refreshPositions() as Future<void>,
        projectRepoImpl.refreshProjects() as Future<void>,
      ]);
    } catch (e) {
      throw Exception('Failed to refresh repositories: $e');
    }
  }
}
