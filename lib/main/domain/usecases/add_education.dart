import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/domain/repositories/education_repository.dart';

/// Use case for adding a new education record
class AddEducation {
  AddEducation({required this.educationRepository});

  final EducationRepository educationRepository;

  /// Adds a new education record after validation
  Future<void> call(Education education) async {
    _validateEducation(education);

    try {
      await educationRepository.addEducation(education);
    } catch (e) {
      throw Exception('Failed to add education: $e');
    }
  }

  /// Validates the education data before adding
  void _validateEducation(Education education) {
    // Validate title
    if (education.title.trim().isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }

    // Validate description
    if (education.description.trim().isEmpty) {
      throw ArgumentError('Description cannot be empty');
    }

    // Validate optional link
    if (education.link != null && education.link!.trim().isNotEmpty) {
      if (!_isValidUrl(education.link!)) {
        throw ArgumentError('Link must be a valid URL');
      }
    }

    // Validate optional image URL
    if (education.imageUrl != null && education.imageUrl!.trim().isNotEmpty) {
      if (!_isValidUrl(education.imageUrl!)) {
        throw ArgumentError('Image URL must be a valid URL');
      }
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
