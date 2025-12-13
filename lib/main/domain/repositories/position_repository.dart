import 'package:portfolio/main/data/position.dart';

/// Repository interface for managing positions
/// Defines the contract for position static_data operations
abstract class PositionRepository {
  /// Fetches positions from remote source and caches them locally
  /// Falls back to local cache if remote fetch fails
  Future<List<Position>> readPositions();
}
