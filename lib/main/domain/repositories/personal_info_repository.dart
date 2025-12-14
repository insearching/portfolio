import 'package:portfolio/main/data/personal_info.dart';

/// Repository interface for managing personal information
/// Defines the contract for personal info data operations
abstract class PersonalInfoRepository {
  /// Forces a refresh from remote, bypassing all caches
  Future<PersonalInfo?> refreshPersonalInfo();

  /// Stream that emits personal info progressively from cache layers
  /// Emits from: memory -> local -> remote
  Stream<PersonalInfo?> get personalInfoUpdateStream;
}
