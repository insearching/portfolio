import 'package:portfolio/main/data/mapper/firebase_raw_data_mapper.dart';
import 'package:portfolio/main/data/mapper/project_remote_model_mapper.dart';
import 'package:portfolio/main/data/utils/typedefs.dart';
import 'package:portfolio/main/domain/model/project.dart';

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

    final rawData = event.snapshot.value;
    if (rawData == null) return [];

    try {
      final projects = firebaseRawToJsonMaps(rawData)
          .map(projectRemoteModelFromJson)
          .map((m) => m.toDomain())
          .toList();

      print('Loaded ${projects.length} projects from Firebase');
      return projects;
    } catch (e) {
      print('Error parsing projects from Firebase: $e');
      rethrow;
    }
  }
}
