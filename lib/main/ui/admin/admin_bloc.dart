import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/domain/usecases/add_blog_post.dart';
import 'package:portfolio/main/domain/usecases/add_education.dart';
import 'package:portfolio/main/domain/usecases/add_position.dart';
import 'package:portfolio/main/domain/usecases/add_project.dart';
import 'package:portfolio/main/domain/usecases/add_skill.dart';
import 'package:portfolio/main/domain/usecases/authenticate_admin.dart';
import 'package:portfolio/main/domain/usecases/check_authentication.dart';
import 'package:portfolio/main/ui/admin/admin_event.dart';
import 'package:portfolio/main/ui/admin/admin_state.dart';

/// BLoC for admin functionality
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc({
    required this.authenticateAdmin,
    required this.checkAuthentication,
    required this.addBlogPost,
    required this.addProject,
    required this.addSkill,
    required this.addEducation,
    required this.addPosition,
  }) : super(const AdminState()) {
    on<CheckAdminAuth>(_onCheckAdminAuth);
    on<AuthenticateAdminEvent>(_onAuthenticateAdmin);
    on<AddBlogPostEvent>(_onAddBlogPost);
    on<AddProjectEvent>(_onAddProject);
    on<AddSkillEvent>(_onAddSkill);
    on<AddEducationEvent>(_onAddEducation);
    on<AddPositionEvent>(_onAddPosition);
    on<ResetAddOperationState>(_onResetAddOperationState);
  }

  final AuthenticateAdmin authenticateAdmin;
  final CheckAuthentication checkAuthentication;
  final AddBlogPost addBlogPost;
  final AddProject addProject;
  final AddSkill addSkill;
  final AddEducation addEducation;
  final AddPosition addPosition;

  Future<void> _onCheckAdminAuth(
    CheckAdminAuth event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(authStatus: AuthStatus.authenticating));

    try {
      final isAuthenticated = await checkAuthentication();

      if (isAuthenticated) {
        emit(state.copyWith(authStatus: AuthStatus.authenticated));
      } else {
        emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
      }
    } catch (e) {
      emit(state.copyWith(
        authStatus: AuthStatus.authenticationFailed,
        errorMessage: 'Authentication check failed: $e',
      ));
    }
  }

  Future<void> _onAuthenticateAdmin(
    AuthenticateAdminEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(authStatus: AuthStatus.authenticating));

    try {
      final success = await authenticateAdmin(event.email, event.password);

      if (success) {
        emit(state.copyWith(authStatus: AuthStatus.authenticated));
      } else {
        emit(state.copyWith(
          authStatus: AuthStatus.authenticationFailed,
          errorMessage: 'Invalid credentials',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        authStatus: AuthStatus.authenticationFailed,
        errorMessage: 'Authentication failed: $e',
      ));
    }
  }

  Future<void> _onAddBlogPost(
    AddBlogPostEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(
      addOperationStatus: AddOperationStatus.loading,
      errorMessage: null,
      successMessage: null,
    ));

    try {
      await addBlogPost(event.post);
      emit(state.copyWith(
        addOperationStatus: AddOperationStatus.success,
        successMessage: 'Blog post added successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        addOperationStatus: AddOperationStatus.failure,
        errorMessage: 'Failed to add blog post: $e',
      ));
    }
  }

  Future<void> _onAddProject(
    AddProjectEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(
      addOperationStatus: AddOperationStatus.loading,
      errorMessage: null,
      successMessage: null,
    ));

    try {
      await addProject(event.project);
      emit(state.copyWith(
        addOperationStatus: AddOperationStatus.success,
        successMessage: 'Project added successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        addOperationStatus: AddOperationStatus.failure,
        errorMessage: 'Failed to add project: $e',
      ));
    }
  }

  Future<void> _onAddSkill(
    AddSkillEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(
      addOperationStatus: AddOperationStatus.loading,
      errorMessage: null,
      successMessage: null,
    ));

    try {
      await addSkill(event.skill);
      emit(state.copyWith(
        addOperationStatus: AddOperationStatus.success,
        successMessage: 'Skill added successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        addOperationStatus: AddOperationStatus.failure,
        errorMessage: 'Failed to add skill: $e',
      ));
    }
  }

  Future<void> _onAddEducation(
    AddEducationEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(
      addOperationStatus: AddOperationStatus.loading,
      errorMessage: null,
      successMessage: null,
    ));

    try {
      await addEducation(event.education);
      emit(state.copyWith(
        addOperationStatus: AddOperationStatus.success,
        successMessage: 'Education added successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        addOperationStatus: AddOperationStatus.failure,
        errorMessage: 'Failed to add education: $e',
      ));
    }
  }

  Future<void> _onAddPosition(
    AddPositionEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(
      addOperationStatus: AddOperationStatus.loading,
      errorMessage: null,
      successMessage: null,
    ));

    try {
      await addPosition(event.position);
      emit(state.copyWith(
        addOperationStatus: AddOperationStatus.success,
        successMessage: 'Position added successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        addOperationStatus: AddOperationStatus.failure,
        errorMessage: 'Failed to add position: $e',
      ));
    }
  }

  void _onResetAddOperationState(
    ResetAddOperationState event,
    Emitter<AdminState> emit,
  ) {
    emit(state.copyWith(
      addOperationStatus: AddOperationStatus.initial,
      errorMessage: null,
      successMessage: null,
    ));
  }
}
