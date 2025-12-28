import 'package:portfolio/main/domain/model/position.dart';
import 'package:portfolio/main/domain/repositories/position_repository.dart';

/// Use case for adding a new position
class AddPosition {
  AddPosition({required this.positionRepository});

  final PositionRepository positionRepository;

  /// Adds a new position after validation
  Future<void> call(Position position) async {
    _validatePosition(position);

    try {
      await positionRepository.addPosition(position);
    } catch (e) {
      throw Exception('Failed to add position: $e');
    }
  }

  /// Validates the position data before adding
  void _validatePosition(Position position) {
    // Validate title (company/organization)
    if (position.title.trim().isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }

    // Validate position (role)
    if (position.position.trim().isEmpty) {
      throw ArgumentError('Position cannot be empty');
    }

    // Validate description
    if (position.description.trim().isEmpty) {
      throw ArgumentError('Description cannot be empty');
    }

    // Validate icon URL
    if (position.icon.trim().isEmpty) {
      throw ArgumentError('Icon URL cannot be empty');
    }
    if (!_isValidUrl(position.icon)) {
      throw ArgumentError('Icon URL must be a valid URL');
    }
  }

  /// Checks if a string is a valid URL
  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }
}
