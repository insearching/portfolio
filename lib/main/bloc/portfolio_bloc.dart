import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/bloc/portfolio_event.dart';
import 'package:portfolio/main/bloc/portfolio_state.dart';
import 'package:portfolio/main/data/repository/portfolio_repository.dart';

/// Main BLoC for managing portfolio data
/// Automatically subscribes to repository streams and emits states as data arrives
/// Supports progressive loading: cached data appears first, then remote updates
class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  PortfolioBloc({
    required this.portfolioRepository,
  }) : super(PortfolioState(
          // Load static data immediately in initial state
          personalInfo: portfolioRepository.getPersonalInfo(),
          skills: portfolioRepository.getSkills(),
          resumeTabs: portfolioRepository.getResumeTabs(),
          status: PortfolioStatus.loading,
        )) {
    // Register event handlers
    on<RefreshPortfolioData>(_onRefreshPortfolioData);
    on<PostsUpdated>(_onPostsUpdated);
    on<PositionsUpdated>(_onPositionsUpdated);
    on<ProjectsUpdated>(_onProjectsUpdated);
    on<EducationUpdated>(_onEducationUpdated);

    // Set up stream subscriptions for progressive data loading
    _setupStreamSubscriptions();
  }

  final PortfolioRepository portfolioRepository;

  /// Sets up stream subscriptions that trigger internal events
  /// This approach properly follows BLoC pattern by using events
  void _setupStreamSubscriptions() {
    // Subscribe to posts stream (progressive: memory -> local -> remote)
    portfolioRepository.getPostsStream().listen(
      (posts) => add(PostsUpdated(posts)),
      onError: (error) {
        print('Error loading posts: $error');
      },
    );

    // Subscribe to positions stream (progressive: memory -> local -> remote)
    portfolioRepository.getPositionsStream().listen(
      (positions) => add(PositionsUpdated(positions)),
      onError: (error) {
        print('Error loading positions: $error');
      },
    );

    // Subscribe to projects stream (progressive: memory -> local -> remote)
    portfolioRepository.getProjectsStream().listen(
      (projects) => add(ProjectsUpdated(projects)),
      onError: (error) {
        print('Error loading projects: $error');
      },
    );

    // Subscribe to education stream (progressive: memory -> local -> remote)
    portfolioRepository.getEducationStream().listen(
      (education) => add(EducationUpdated(education)),
      onError: (error) {
        print('Error loading education: $error');
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

  /// Handler for manually refreshing all data
  /// Clears caches and forces fresh data from remote sources
  Future<void> _onRefreshPortfolioData(
    RefreshPortfolioData event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(state.copyWith(status: PortfolioStatus.loading));

    try {
      // Force refresh all remote repositories (clears caches)
      await portfolioRepository.refreshAll();

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
