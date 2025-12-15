import 'package:equatable/equatable.dart';
import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/domain/model/position.dart';
import 'package:portfolio/main/domain/model/post.dart';
import 'package:portfolio/main/domain/model/project.dart';
import 'package:portfolio/main/domain/model/skill.dart';

/// Base class for admin events
abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check authentication status
class CheckAdminAuth extends AdminEvent {
  const CheckAdminAuth();
}

/// Event to authenticate admin
class AuthenticateAdminEvent extends AdminEvent {
  const AuthenticateAdminEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Event to add a blog post
class AddBlogPostEvent extends AdminEvent {
  const AddBlogPostEvent(this.post);

  final Post post;

  @override
  List<Object?> get props => [post];
}

/// Event to add a project
class AddProjectEvent extends AdminEvent {
  const AddProjectEvent(this.project);

  final Project project;

  @override
  List<Object?> get props => [project];
}

/// Event to add a skill
class AddSkillEvent extends AdminEvent {
  const AddSkillEvent(this.skill);

  final Skill skill;

  @override
  List<Object?> get props => [skill];
}

/// Event to add an education record
class AddEducationEvent extends AdminEvent {
  const AddEducationEvent(this.education);

  final Education education;

  @override
  List<Object?> get props => [education];
}

/// Event to add a position
class AddPositionEvent extends AdminEvent {
  const AddPositionEvent(this.position);

  final Position position;

  @override
  List<Object?> get props => [position];
}

/// Event to reset add operation state
class ResetAddOperationState extends AdminEvent {
  const ResetAddOperationState();
}
