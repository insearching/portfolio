import 'package:portfolio/main/domain/model/position.dart';

/// Repository interface for managing positions
/// Defines the contract for position static_data operations
abstract class PositionRepository {
  /// Adds a new position
  Future<void> addPosition(Position position);

  /// Forces a refresh from remote, bypassing all caches
  Future<List<Position>> refreshPositions();

  /// Stream that emits positions progressively from cache layers
  /// Emits from: memory -> local -> remote
  Stream<List<Position>> get positionsUpdateStream;
}
