import 'package:portfolio/main/data/education.dart';

/// Repository interface for managing education records
/// Defines the contract for education data operations
abstract class EducationRepository {
  /// Fetches education records from remote source and caches them locally
  /// Falls back to local cache if remote fetch fails
  Future<List<Education>> readEducation();
}
