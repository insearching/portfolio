import 'package:portfolio/main/data/project.dart';
import 'package:portfolio/main/data/typedefs.dart';

/// Remote data source for Projects
/// Handles all Firebase Realtime Database operations for projects
abstract class ProjectsRemoteDataSource {
  Future<List<Project>> readProjects();
}

class ProjectsRemoteDataSourceImpl implements ProjectsRemoteDataSource {
  ProjectsRemoteDataSourceImpl({
    required this.firebaseDatabaseReference,
  });

  final FirebaseDatabaseReference firebaseDatabaseReference;
  static const String _collectionName = 'projects';

  @override
  Future<List<Project>> readProjects() async {
    final projectsCollection = firebaseDatabaseReference.child(_collectionName);
    final event = await projectsCollection.once();

    if (event.snapshot.value == null) return [];

    try {
      final rawData = event.snapshot.value;
      final List<Project> projects = [];

      // Handle both Map (from .push()) and List formats
      if (rawData is Map) {
        // Firebase returns Map when using .push()
        for (var entry in rawData.entries) {
          final value = entry.value;
          if (value is Map) {
            final imageValue =
                value['image']?.toString() ?? 'assets/img/default.png';
            projects.add(
              Project(
                image:
                    imageValue.isEmpty ? 'assets/img/default.png' : imageValue,
                title: value['title']?.toString() ?? '',
                role: value['role']?.toString() ?? '',
                description: value['description']?.toString() ?? '',
                link: value['link']?.toString(),
              ),
            );
          }
        }
      } else if (rawData is List) {
        // Handle List format (if data is structured as array)
        for (var value in rawData) {
          if (value is Map) {
            final imageValue =
                value['image']?.toString() ?? 'assets/img/default.png';
            projects.add(
              Project(
                image:
                    imageValue.isEmpty ? 'assets/img/default.png' : imageValue,
                title: value['title']?.toString() ?? '',
                role: value['role']?.toString() ?? '',
                description: value['description']?.toString() ?? '',
                link: value['link']?.toString(),
              ),
            );
          }
        }
      }

      print('Loaded ${projects.length} projects from Firebase');
      return projects;
    } catch (e) {
      print('Error parsing projects from Firebase: $e');
      rethrow;
    }
  }
}
