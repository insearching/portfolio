import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/data/local/static_data/repository.dart';
import 'package:portfolio/main/data/personal_info.dart';
import 'package:portfolio/main/data/position.dart';
import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/data/project.dart';
import 'package:portfolio/main/data/skill.dart';
import 'package:portfolio/main/domain/repositories/blog_repository.dart';
import 'package:portfolio/main/domain/repositories/education_repository.dart';
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
    required this.educationRepository,
  });

  final BlogRepository blogRepository;
  final PositionRepository positionRepository;
  final ProjectRepository projectRepository;
  final EducationRepository educationRepository;

  // Personal Information
  PersonalInfo getPersonalInfo() => Repository.info;

  String getUserName() => Repository.info.title;

  String getUserEmail() => Repository.info.email;

  // Skills
  List<Skill> getSkills() => Repository.skills;

  // Education - Remote data (from Firebase)
  /// Returns a Stream that emits education progressively from cache layers
  /// Emits from: memory -> local -> remote
  Stream<List<Education>> getEducationStream() {
    try {
      return educationRepository.educationUpdateStream;
    } catch (e) {
      throw Exception('Failed to load education stream: $e');
    }
  }

  // Projects - Remote data (from Firebase)
  /// Returns a Stream that emits projects progressively from cache layers
  /// Emits from: memory -> local -> remote
  Stream<List<Project>> getProjectsStream() {
    try {
      return projectRepository.projectsUpdateStream;
    } catch (e) {
      throw Exception('Failed to load projects stream: $e');
    }
  }

  // Resume Tabs
  List<String> getResumeTabs() => Repository.tabs;

  // Remote static_data - Posts (from Firebase)
  /// Returns a Stream that emits posts progressively from cache layers
  /// Emits from: memory -> local -> remote
  Stream<List<Post>> getPostsStream() {
    try {
      return blogRepository.postsUpdateStream;
    } catch (e) {
      throw Exception('Failed to load posts stream: $e');
    }
  }

  // Remote static_data - Positions (from Firebase)
  /// Returns a Stream that emits positions progressively from cache layers
  /// Emits from: memory -> local -> remote
  Stream<List<Position>> getPositionsStream() {
    try {
      return positionRepository.positionsUpdateStream;
    } catch (e) {
      throw Exception('Failed to load positions stream: $e');
    }
  }

  /// Refreshes all remote repositories, bypassing all caches
  /// Forces fresh data from Firebase for posts, positions, projects, and education
  /// This is useful for ensuring the latest data is displayed on web
  Future<void> refreshAll() async {
    try {
      // Refresh all repositories in parallel
      await Future.wait<void>([
        blogRepository.refreshPosts(),
        positionRepository.refreshPositions(),
        projectRepository.refreshProjects(),
        educationRepository.refreshEducation(),
      ]);
    } catch (e) {
      throw Exception('Failed to refresh repositories: $e');
    }
  }

  // Stream getters that notify when data is updated from remote

  /// Stream that notifies when posts are updated from remote
  Stream<List<Post>> get postsUpdateStream => blogRepository.postsUpdateStream;

  /// Stream that notifies when positions are updated from remote
  Stream<List<Position>> get positionsUpdateStream =>
      positionRepository.positionsUpdateStream;

  /// Stream that notifies when projects are updated from remote
  Stream<List<Project>> get projectsUpdateStream =>
      projectRepository.projectsUpdateStream;

  /// Stream that notifies when education is updated from remote
  Stream<List<Education>> get educationUpdateStream =>
      educationRepository.educationUpdateStream;
}
