import 'package:portfolio/main/domain/model/position.dart';
import 'package:portfolio/main/domain/repositories/position_repository.dart';

/// Use case for adding a new position
class AddPosition {
  AddPosition({required this.positionRepository});

  final PositionRepository positionRepository;

  /// Adds a new position
  Future<void> call(Position position) async {
    try {
      await positionRepository.addPosition(position);
    } catch (e) {
      throw Exception('Failed to add position: $e');
    }
  }
}
