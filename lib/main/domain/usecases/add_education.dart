import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/domain/repositories/education_repository.dart';

/// Use case for adding a new education record
class AddEducation {
  AddEducation({required this.educationRepository});

  final EducationRepository educationRepository;

  /// Adds a new education record
  Future<void> call(Education education) async {
    try {
      await educationRepository.addEducation(education);
    } catch (e) {
      throw Exception('Failed to add education: $e');
    }
  }
}
