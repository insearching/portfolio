import 'package:equatable/equatable.dart';
import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/data/position.dart';
import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/data/project.dart';
import 'package:portfolio/main/data/skill.dart';

/// Base class for all portfolio events
/// Using sealed class pattern for exhaustive event handling
sealed class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object?> get props => [];
}

/// Event to manually refresh all data from remote sources
/// Clears all caches and forces fresh data fetch
/// Stream subscriptions automatically receive the updated data
class RefreshPortfolioData extends PortfolioEvent {
  const RefreshPortfolioData();
}

// Internal events triggered by stream updates (used by BLoC internally)

/// Internal event when posts are updated from stream
class PostsUpdated extends PortfolioEvent {
  const PostsUpdated(this.posts);

  final List<Post> posts;

  @override
  List<Object?> get props => [posts];
}

/// Internal event when positions are updated from stream
class PositionsUpdated extends PortfolioEvent {
  const PositionsUpdated(this.positions);

  final List<Position> positions;

  @override
  List<Object?> get props => [positions];
}

/// Internal event when projects are updated from stream
class ProjectsUpdated extends PortfolioEvent {
  const ProjectsUpdated(this.projects);

  final List<Project> projects;

  @override
  List<Object?> get props => [projects];
}

/// Internal event when education is updated from stream
class EducationUpdated extends PortfolioEvent {
  const EducationUpdated(this.education);

  final List<Education> education;

  @override
  List<Object?> get props => [education];
}

/// Internal event when skills are updated from stream
class SkillsUpdated extends PortfolioEvent {
  const SkillsUpdated(this.skills);

  final List<Skill> skills;

  @override
  List<Object?> get props => [skills];
}
