import 'package:equatable/equatable.dart';
import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/data/personal_info.dart';
import 'package:portfolio/main/data/position.dart';
import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/data/project.dart';
import 'package:portfolio/main/data/responsibility.dart';
import 'package:portfolio/main/data/skill.dart';

/// Status enumeration for data loading states
enum PortfolioStatus {
  initial,
  loading,
  success,
  error,
}

/// Extension for convenient status checks
extension PortfolioStatusX on PortfolioStatus {
  bool get isInitial => this == PortfolioStatus.initial;

  bool get isLoading => this == PortfolioStatus.loading;

  bool get isSuccess => this == PortfolioStatus.success;

  bool get isError => this == PortfolioStatus.error;
}

/// Main portfolio state containing all portfolio data
class PortfolioState extends Equatable {
  const PortfolioState({
    this.status = PortfolioStatus.initial,
    this.personalInfo,
    this.skills = const [],
    this.education = const [],
    this.projects = const [],
    this.responsibilities = const [],
    this.posts = const [],
    this.positions = const [],
    this.resumeTabs = const [],
    this.errorMessage,
  });

  final PortfolioStatus status;
  final PersonalInfo? personalInfo;
  final List<Skill> skills;
  final List<Education> education;
  final List<Project> projects;
  final List<Responsibility> responsibilities;
  final List<Post> posts;
  final List<Position> positions;
  final List<String> resumeTabs;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        status,
        personalInfo,
        skills,
        education,
        projects,
        responsibilities,
        posts,
        positions,
        resumeTabs,
        errorMessage,
      ];

  PortfolioState copyWith({
    PortfolioStatus? status,
    PersonalInfo? personalInfo,
    List<Skill>? skills,
    List<Education>? education,
    List<Project>? projects,
    List<Responsibility>? responsibilities,
    List<Post>? posts,
    List<Position>? positions,
    List<String>? resumeTabs,
    String? errorMessage,
  }) {
    return PortfolioState(
      status: status ?? this.status,
      personalInfo: personalInfo ?? this.personalInfo,
      skills: skills ?? this.skills,
      education: education ?? this.education,
      projects: projects ?? this.projects,
      responsibilities: responsibilities ?? this.responsibilities,
      posts: posts ?? this.posts,
      positions: positions ?? this.positions,
      resumeTabs: resumeTabs ?? this.resumeTabs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
