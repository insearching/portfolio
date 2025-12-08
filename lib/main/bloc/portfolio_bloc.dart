import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/bloc/portfolio_event.dart';
import 'package:portfolio/main/bloc/portfolio_state.dart';
import 'package:portfolio/main/data/repository/portfolio_repository.dart';

/// Main BLoC for managing portfolio data
/// Follows the event-stream-state pattern as described in the Medium article
/// Events are processed through handlers that emit new states
class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  PortfolioBloc({
    required this.portfolioRepository,
  }) : super(const PortfolioState()) {
    // Register event handlers
    on<LoadPortfolioData>(_onLoadPortfolioData);
    on<LoadPosts>(_onLoadPosts);
    on<LoadPositions>(_onLoadPositions);
    on<RefreshPortfolioData>(_onRefreshPortfolioData);
  }

  final PortfolioRepository portfolioRepository;

  /// Handler for loading all portfolio data
  Future<void> _onLoadPortfolioData(
    LoadPortfolioData event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(state.copyWith(status: PortfolioStatus.loading));

    try {
      // Load static data (synchronous)
      final personalInfo = portfolioRepository.getPersonalInfo();
      final skills = portfolioRepository.getSkills();
      final education = portfolioRepository.getEducation();
      final projects = portfolioRepository.getProjects();
      final responsibilities = portfolioRepository.getResponsibilities();
      final resumeTabs = portfolioRepository.getResumeTabs();

      // Load remote data (asynchronous)
      final posts = await portfolioRepository.getPosts();
      final positions = await portfolioRepository.getPositions();

      emit(
        state.copyWith(
          status: PortfolioStatus.success,
          personalInfo: personalInfo,
          skills: skills,
          education: education,
          projects: projects,
          responsibilities: responsibilities,
          posts: posts,
          positions: positions,
          resumeTabs: resumeTabs,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PortfolioStatus.error,
          errorMessage: 'Failed to load portfolio data: $error',
        ),
      );
    }
  }

  /// Handler for loading posts only
  Future<void> _onLoadPosts(
    LoadPosts event,
    Emitter<PortfolioState> emit,
  ) async {
    try {
      final posts = await portfolioRepository.getPosts();
      emit(state.copyWith(posts: posts));
    } catch (error) {
      emit(
        state.copyWith(
          status: PortfolioStatus.error,
          errorMessage: 'Failed to load posts: $error',
        ),
      );
    }
  }

  /// Handler for loading positions only
  Future<void> _onLoadPositions(
    LoadPositions event,
    Emitter<PortfolioState> emit,
  ) async {
    try {
      final positions = await portfolioRepository.getPositions();
      emit(state.copyWith(positions: positions));
    } catch (error) {
      emit(
        state.copyWith(
          status: PortfolioStatus.error,
          errorMessage: 'Failed to load positions: $error',
        ),
      );
    }
  }

  /// Handler for refreshing all data
  Future<void> _onRefreshPortfolioData(
    RefreshPortfolioData event,
    Emitter<PortfolioState> emit,
  ) async {
    // Delegate to load portfolio data
    add(const LoadPortfolioData());
  }
}
