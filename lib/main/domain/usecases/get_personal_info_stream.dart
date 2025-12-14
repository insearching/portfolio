import 'package:portfolio/main/data/personal_info.dart';
import 'package:portfolio/main/domain/repositories/personal_info_repository.dart';

/// Use case for fetching personal info progressively from cache layers
/// Emits data from: memory cache -> local storage -> remote source
class GetPersonalInfoStream {
  GetPersonalInfoStream({
    required this.personalInfoRepository,
  });

  final PersonalInfoRepository personalInfoRepository;

  /// Returns a stream that emits personal info as it becomes available
  /// from different cache layers
  Stream<PersonalInfo?> call() {
    return personalInfoRepository.personalInfoUpdateStream;
  }
}
