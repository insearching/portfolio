import 'package:portfolio/main/data/local/dao/position_dao.dart';
import 'package:portfolio/main/data/position.dart';

/// Repository for managing positions
/// Provides business logic layer between UI and data access
class PositionRepository {
  PositionRepository({
    required this.positionDao,
  });

  final PositionDao positionDao;

  Future<List<Position>> readPositions() async {
    try {
      return await positionDao.readPositions();
    } catch (e) {
      throw Exception('Failed to read positions: $e');
    }
  }
}
