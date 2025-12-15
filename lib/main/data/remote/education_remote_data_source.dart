import 'package:portfolio/main/data/mapper/education_remote_model_mapper.dart';
import 'package:portfolio/main/data/mapper/firebase_raw_data_mapper.dart';
import 'package:portfolio/main/data/utils/typedefs.dart';
import 'package:portfolio/main/domain/model/education.dart';

/// Remote data source for Education
/// Handles all Firebase Realtime Database operations for education records
abstract class EducationRemoteDataSource {
  Future<List<Education>> readEducation();
}

class EducationRemoteDataSourceImpl implements EducationRemoteDataSource {
  EducationRemoteDataSourceImpl({
    required this.firebaseDatabaseReference,
  });

  final FirebaseDatabaseReference firebaseDatabaseReference;
  static const String _collectionName = 'education';

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

      print('Loaded ${educationList.length} education records from Firebase');
      return educationList;
    } catch (e) {
      print('Error parsing education records from Firebase: $e');
      rethrow;
    }
  }
}
