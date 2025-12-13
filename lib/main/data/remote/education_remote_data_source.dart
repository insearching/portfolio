import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/data/typedefs.dart';

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

    if (event.snapshot.value == null) return [];

    try {
      final rawData = event.snapshot.value;
      final List<Education> educationList = [];

      // Handle both Map (from .push()) and List formats
      if (rawData is Map) {
        // Firebase returns Map when using .push()
        for (var entry in rawData.entries) {
          final value = entry.value;
          if (value is Map) {
            educationList.add(
              Education(
                title: value['title']?.toString() ?? '',
                description: value['description']?.toString() ?? '',
                type: EducationType.values.firstWhere(
                  (e) =>
                      e.name == (value['type']?.toString() ?? 'certification'),
                  orElse: () => EducationType.certification,
                ),
                text: value['text']?.toString(),
                link: value['link']?.toString(),
                imageUrl: value['imageUrl']?.toString(),
              ),
            );
          }
        }
      } else if (rawData is List) {
        // Handle List format (if data is structured as array)
        for (var value in rawData) {
          if (value is Map) {
            educationList.add(
              Education(
                title: value['title']?.toString() ?? '',
                description: value['description']?.toString() ?? '',
                type: EducationType.values.firstWhere(
                  (e) =>
                      e.name == (value['type']?.toString() ?? 'certification'),
                  orElse: () => EducationType.certification,
                ),
                text: value['text']?.toString(),
                link: value['link']?.toString(),
                imageUrl: value['imageUrl']?.toString(),
              ),
            );
          }
        }
      }

      print('Loaded ${educationList.length} education records from Firebase');
      return educationList;
    } catch (e) {
      print('Error parsing education records from Firebase: $e');
      rethrow;
    }
  }
}
