import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/data/local/data/repository.dart';
import 'package:portfolio/main/data/personal_info.dart';
import 'package:portfolio/main/data/position.dart';
import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/data/project.dart';
import 'package:portfolio/main/data/repository/blog_repository.dart';
import 'package:portfolio/main/data/repository/position_repository.dart';
import 'package:portfolio/main/data/responsibility.dart';
import 'package:portfolio/main/data/skill.dart';

/// Centralized repository for all portfolio data
/// Combines local data and remote data sources (Firebase)
/// This is the single source of truth for all portfolio information
class PortfolioRepository {
  PortfolioRepository({
    required this.blogRepository,
    required this.positionRepository,
  });

  final BlogRepository blogRepository;
  final PositionRepository positionRepository;

  // Personal Information
  PersonalInfo getPersonalInfo() => Repository.info;

  String getUserName() => Repository.info.title;

  String getUserEmail() => Repository.info.email;

  // Skills
  List<Skill> getSkills() => Repository.skills;

  // Education
  List<Education> getEducation() => Repository.educationInfo;

  // Projects
  List<Project> getProjects() => Repository.projects;

  // Responsibilities
  List<Responsibility> getResponsibilities() => Repository.responsibilities;

  // Resume Tabs
  List<String> getResumeTabs() => Repository.tabs;

  // Remote data - Posts (from Firebase)
  Future<List<Post>> getPosts() async {
    try {
      return await blogRepository.readPosts();
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }

  // Remote data - Positions (from Firebase)
  Future<List<Position>> getPositions() async {
    try {
      return await positionRepository.readPositions();
    } catch (e) {
      throw Exception('Failed to load positions: $e');
    }
  }
}
