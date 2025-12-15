import 'package:equatable/equatable.dart';
import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/domain/model/personal_info.dart';
import 'package:portfolio/main/domain/model/position.dart';
import 'package:portfolio/main/domain/model/post.dart';
import 'package:portfolio/main/domain/model/project.dart';
import 'package:portfolio/main/domain/model/skill.dart';

/// Status enumeration for static_data loading states
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

/// Main portfolio state containing all portfolio static_data
class PortfolioState extends Equatable {
  const PortfolioState({
    this.status = PortfolioStatus.initial,
    this.personalInfo,
    this.skills = const [],
    this.education = const [],
    this.projects = const [],
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
      posts: posts ?? this.posts,
      positions: positions ?? this.positions,
      resumeTabs: resumeTabs ?? this.resumeTabs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
