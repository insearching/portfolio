import 'package:equatable/equatable.dart';

/// Base class for all portfolio events
/// Using sealed class pattern for exhaustive event handling
sealed class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all portfolio data
class LoadPortfolioData extends PortfolioEvent {
  const LoadPortfolioData();
}

/// Event to load posts from blog
class LoadPosts extends PortfolioEvent {
  const LoadPosts();
}

/// Event to load positions
class LoadPositions extends PortfolioEvent {
  const LoadPositions();
}

/// Event to refresh all data
class RefreshPortfolioData extends PortfolioEvent {
  const RefreshPortfolioData();
}
