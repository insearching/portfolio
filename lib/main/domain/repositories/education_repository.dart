import 'package:portfolio/main/domain/model/education.dart';

/// Repository interface for managing education records
/// Defines the contract for education data operations
abstract class EducationRepository {
  /// Forces a refresh from remote, bypassing all caches
  Future<List<Education>> refreshEducation();

  /// Stream that emits education progressively from cache layers
  /// Emits from: memory -> local -> remote
  Stream<List<Education>> get educationUpdateStream;
}
