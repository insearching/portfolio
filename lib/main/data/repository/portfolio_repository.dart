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
  Future<List<Education>> getEducation() async {
    try {
      return await educationRepository.readEducation();
    } catch (e) {
      throw Exception('Failed to load education: $e');
    }
  }

  /// Returns a Stream that emits education progressively from cache layers
  /// Emits from: memory -> local -> remote
  Stream<List<Education>> getEducationStream() {
    try {
      // Cast to implementation type to access stream method
      final educationRepoImpl = educationRepository as dynamic;
      return educationRepoImpl.readEducationStream() as Stream<List<Education>>;
    } catch (e) {
      throw Exception('Failed to load education stream: $e');
    }
  }

  // Projects - Remote data (from Firebase)
  Future<List<Project>> getProjects() async {
    try {
      return await projectRepository.readProjects();
    } catch (e) {
      throw Exception('Failed to load projects: $e');
    }
  }

  /// Returns a Stream that emits projects progressively from cache layers
  /// Emits from: memory -> local -> remote
  Stream<List<Project>> getProjectsStream() {
    try {
      // Cast to implementation type to access stream method
      final projectRepoImpl = projectRepository as dynamic;
      return projectRepoImpl.readProjectsStream() as Stream<List<Project>>;
    } catch (e) {
      throw Exception('Failed to load projects stream: $e');
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

  /// Returns a Stream that emits posts progressively from cache layers
  /// Emits from: memory -> local -> remote
  Stream<List<Post>> getPostsStream() {
    try {
      // Cast to implementation type to access stream method
      final blogRepoImpl = blogRepository as dynamic;
      return blogRepoImpl.readPostsStream() as Stream<List<Post>>;
    } catch (e) {
      throw Exception('Failed to load posts stream: $e');
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

  /// Returns a Stream that emits positions progressively from cache layers
  /// Emits from: memory -> local -> remote
  Stream<List<Position>> getPositionsStream() {
    try {
      // Cast to implementation type to access stream method
      final positionRepoImpl = positionRepository as dynamic;
      return positionRepoImpl.readPositionsStream() as Stream<List<Position>>;
    } catch (e) {
      throw Exception('Failed to load positions stream: $e');
    }
  }

  /// Refreshes all remote repositories, bypassing all caches
  /// Forces fresh data from Firebase for posts, positions, projects, and education
  /// This is useful for ensuring the latest data is displayed on web
  Future<void> refreshAll() async {
    try {
      // Cast to implementation types to access refresh methods
      final blogRepoImpl = blogRepository as dynamic;
      final positionRepoImpl = positionRepository as dynamic;
      final projectRepoImpl = projectRepository as dynamic;
      final educationRepoImpl = educationRepository as dynamic;

      // Refresh all repositories in parallel
      await Future.wait<void>([
        blogRepoImpl.refreshPosts() as Future<void>,
        positionRepoImpl.refreshPositions() as Future<void>,
        projectRepoImpl.refreshProjects() as Future<void>,
        educationRepoImpl.refreshEducation() as Future<void>,
      ]);
    } catch (e) {
      throw Exception('Failed to refresh repositories: $e');
    }
  }

  // Stream getters that notify when data is updated from remote

  /// Stream that notifies when posts are updated from remote
  Stream<List<Post>> get postsUpdateStream {
    final blogRepoImpl = blogRepository as dynamic;
    return blogRepoImpl.postsUpdateStream as Stream<List<Post>>;
  }

  /// Stream that notifies when positions are updated from remote
  Stream<List<Position>> get positionsUpdateStream {
    final positionRepoImpl = positionRepository as dynamic;
    return positionRepoImpl.positionsUpdateStream as Stream<List<Position>>;
  }

  /// Stream that notifies when projects are updated from remote
  Stream<List<Project>> get projectsUpdateStream {
    final projectRepoImpl = projectRepository as dynamic;
    return projectRepoImpl.projectsUpdateStream as Stream<List<Project>>;
  }

  /// Stream that notifies when education is updated from remote
  Stream<List<Education>> get educationUpdateStream {
    final educationRepoImpl = educationRepository as dynamic;
    return educationRepoImpl.educationUpdateStream as Stream<List<Education>>;
  }
}
