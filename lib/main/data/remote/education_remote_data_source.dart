import 'package:portfolio/main/data/mapper/education_remote_model_mapper.dart';
import 'package:portfolio/main/data/mapper/firebase_raw_data_mapper.dart';
import 'package:portfolio/main/data/utils/typedefs.dart';
import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/core/logger/app_logger.dart';

/// Remote data source for Education
/// Handles all Firebase Realtime Database operations for education records
abstract class EducationRemoteDataSource {
  Future<void> addEducation(Education education);

  Future<List<Education>> readEducation();
}

class EducationRemoteDataSourceImpl implements EducationRemoteDataSource {
  EducationRemoteDataSourceImpl({
required this.firebaseDatabaseReference,
    required this.logger,
  });

  final FirebaseDatabaseReference firebaseDatabaseReference;
  final AppLogger logger;
  static const String _collectionName = 'education';

  @override
  Future<void> addEducation(Education education) async {
    final educationCollection =
        firebaseDatabaseReference.child(_collectionName);

    try {
      final model = educationRemoteModelFromDomain(education);
      await educationCollection.push().set(model.toJson());
      logger.debug('Education record added successfully to Firebase', 'EducationRemoteDataSource');
    } catch (e, stackTrace) {
      logger.error('Error adding education record to Firebase', e, stackTrace, 'EducationRemoteDataSource');
      rethrow;
    }
  }

  @override
  Future<List<Education>> readEducation() async {
    final educationCollection =
        firebaseDatabaseReference.child(_collectionName);
    final event = await educationCollection.once();

    final rawData = event.snapshot.value;
    if (rawData == null) return [];

    try {
      final educationList = firebaseRawToJsonMaps(rawData)
          .map(educationRemoteModelFromJson)
          .map((m) => m.toDomain())
          .toList();

      logger.debug('Loaded ${educationList.length} education records from Firebase', 'EducationRemoteDataSource');
      return educationList;
    } catch (e, stackTrace) {
      logger.error('Error parsing education records from Firebase', e, stackTrace, 'EducationRemoteDataSource');
      rethrow;
    }
  }
}
