import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/bloc/portfolio_event.dart';
import 'package:portfolio/main/bloc/portfolio_state.dart';
import 'package:portfolio/main/data/repository/portfolio_repository.dart';
import 'package:portfolio/main/domain/usecases/get_education_stream.dart';
import 'package:portfolio/main/domain/usecases/get_personal_info_stream.dart';
import 'package:portfolio/main/domain/usecases/get_positions_stream.dart';
import 'package:portfolio/main/domain/usecases/get_posts_stream.dart';
import 'package:portfolio/main/domain/usecases/get_projects_stream.dart';
import 'package:portfolio/main/domain/usecases/get_skills_stream.dart';
import 'package:portfolio/main/domain/usecases/refresh_all.dart';

/// Main BLoC for managing portfolio data
/// Automatically subscribes to repository streams and emits states as data arrives
/// Supports progressive loading: cached data appears first, then remote updates
class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  PortfolioBloc({
    required this.portfolioRepository,
    required this.getEducationStream,
    required this.getProjectsStream,
    required this.getPostsStream,
    required this.getPositionsStream,
    required this.getSkillsStream,
    required this.getPersonalInfoStream,
    required this.refreshAll,
  }) : super(const PortfolioState(
          // Data will be loaded from streams - start with null to show loading
          personalInfo: null,
          skills: [],
          resumeTabs: ['Education', 'Professional Skills'],
          status: PortfolioStatus.loading,
        )) {
    // Register event handlers
    on<RefreshPortfolioData>(_onRefreshPortfolioData);
    on<PostsUpdated>(_onPostsUpdated);
    on<PositionsUpdated>(_onPositionsUpdated);
    on<ProjectsUpdated>(_onProjectsUpdated);
    on<EducationUpdated>(_onEducationUpdated);
    on<SkillsUpdated>(_onSkillsUpdated);
    on<PersonalInfoUpdated>(_onPersonalInfoUpdated);

    // Set up stream subscriptions for progressive data loading
    _setupStreamSubscriptions();
  }

  final PortfolioRepository portfolioRepository;
  final GetEducationStream getEducationStream;
  final GetProjectsStream getProjectsStream;
  final GetPostsStream getPostsStream;
  final GetPositionsStream getPositionsStream;
  final GetSkillsStream getSkillsStream;
  final GetPersonalInfoStream getPersonalInfoStream;
  final RefreshAll refreshAll;

  /// Sets up stream subscriptions that trigger internal events
  /// This approach properly follows BLoC pattern by using events
  void _setupStreamSubscriptions() {
    // Subscribe to personal info stream (progressive: memory -> local -> remote)
    getPersonalInfoStream().listen(
      (personalInfo) => add(PersonalInfoUpdated(personalInfo)),
      onError: (error) {
        print('Error loading personal info: $error');
      },
    );

    // Subscribe to posts stream (progressive: memory -> local -> remote)
    getPostsStream().listen(
      (posts) => add(PostsUpdated(posts)),
      onError: (error) {
        print('Error loading posts: $error');
      },
    );

    // Subscribe to positions stream (progressive: memory -> local -> remote)
    getPositionsStream().listen(
      (positions) => add(PositionsUpdated(positions)),
      onError: (error) {
        print('Error loading positions: $error');
      },
    );

    // Subscribe to projects stream (progressive: memory -> local -> remote)
    getProjectsStream().listen(
      (projects) => add(ProjectsUpdated(projects)),
      onError: (error) {
        print('Error loading projects: $error');
      },
    );

    // Subscribe to education stream (progressive: memory -> local -> remote)
    getEducationStream().listen(
      (education) => add(EducationUpdated(education)),
      onError: (error) {
        print('Error loading education: $error');
      },
    );

    // Subscribe to skills stream (progressive: memory -> local -> remote)
    getSkillsStream().listen(
      (skills) => add(SkillsUpdated(skills)),
      onError: (error) {
        print('Error loading skills: $error');
      },
    );
  }

  // Event handlers for stream updates

  void _onPostsUpdated(PostsUpdated event, Emitter<PortfolioState> emit) {
    emit(state.copyWith(
      posts: event.posts,
      status: PortfolioStatus.success,
    ));
  }

  void _onPositionsUpdated(
    PositionsUpdated event,
    Emitter<PortfolioState> emit,
  ) {
    emit(state.copyWith(
      positions: event.positions,
      status: PortfolioStatus.success,
    ));
  }

  void _onProjectsUpdated(
    ProjectsUpdated event,
    Emitter<PortfolioState> emit,
  ) {
    emit(state.copyWith(
      projects: event.projects,
      status: PortfolioStatus.success,
    ));
  }

  void _onEducationUpdated(
    EducationUpdated event,
    Emitter<PortfolioState> emit,
  ) {
    emit(state.copyWith(
      education: event.education,
      status: PortfolioStatus.success,
    ));
  }

  void _onSkillsUpdated(
    SkillsUpdated event,
    Emitter<PortfolioState> emit,
  ) {
    emit(state.copyWith(
      skills: event.skills,
      status: PortfolioStatus.success,
    ));
  }

  void _onPersonalInfoUpdated(
    PersonalInfoUpdated event,
    Emitter<PortfolioState> emit,
  ) {
    final info = event.personalInfo;
    if (info == null) {
      emit(
        state.copyWith(
          status: PortfolioStatus.error,
          errorMessage:
              'Failed to load personal info. Check Firebase data and permissions.',
        ),
      );
      return;
    }

    emit(state.copyWith(
      personalInfo: info,
      status: PortfolioStatus.success,
      errorMessage: null,
    ));
  }

  /// Handler for manually refreshing all data
  /// Clears caches and forces fresh data from remote sources
  Future<void> _onRefreshPortfolioData(
    RefreshPortfolioData event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(state.copyWith(status: PortfolioStatus.loading));

    try {
      // Force refresh all remote repositories (clears caches)
      await refreshAll();

      // The stream subscriptions will automatically receive the refreshed data
      // No need to manually reload - the streams handle it automatically
    } catch (error) {
      emit(
        state.copyWith(
          status: PortfolioStatus.error,
          errorMessage: 'Failed to refresh portfolio data: $error',
        ),
      );
    }
  }
}
