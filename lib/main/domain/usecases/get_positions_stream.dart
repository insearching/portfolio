import 'package:portfolio/main/data/position.dart';
import 'package:portfolio/main/domain/repositories/position_repository.dart';

/// Use case for getting positions stream
/// Returns a Stream that emits positions progressively from cache layers
/// Emits from: memory -> local -> remote
class GetPositionsStream {
  const GetPositionsStream({required this.positionRepository});

  final PositionRepository positionRepository;

  Stream<List<Position>> call() {
    try {
      return positionRepository.positionsUpdateStream;
    } catch (e) {
      throw Exception('Failed to load positions stream: $e');
    }
  }
}
