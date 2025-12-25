import 'package:portfolio/main/data/mapper/firebase_raw_data_mapper.dart';
import 'package:portfolio/main/data/mapper/project_remote_model_mapper.dart';
import 'package:portfolio/main/data/utils/typedefs.dart';
import 'package:portfolio/main/domain/model/project.dart';
import 'package:portfolio/core/logger/app_logger.dart';

/// Remote data source for Projects
/// Handles all Firebase Realtime Database operations for projects
abstract class ProjectsRemoteDataSource {
  Future<void> addProject(Project project);

  Future<List<Project>> readProjects();
}

class ProjectsRemoteDataSourceImpl implements ProjectsRemoteDataSource {
  ProjectsRemoteDataSourceImpl({
    required this.firebaseDatabaseReference,
    required this.logger,
  });

  final FirebaseDatabaseReference firebaseDatabaseReference;
  final AppLogger logger;
  static const String _collectionName = 'projects';

  @override
  Future<void> addProject(Project project) async {
    final projectsCollection = firebaseDatabaseReference.child(_collectionName);

    try {
      final model = projectRemoteModelFromDomain(project);
      await projectsCollection.push().set(model.toJson());
      logger.debug(
          'Project added successfully to Firebase', 'ProjectsRemoteDataSource');
    } catch (e, stackTrace) {
      logger.error('Error adding project to Firebase', e, stackTrace,
          'ProjectsRemoteDataSource');
      rethrow;
    }
  }

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

      logger.debug('Loaded ${projects.length} projects from Firebase',
          'ProjectsRemoteDataSource');
      return projects;
    } catch (e, stackTrace) {
      logger.error('Error parsing projects from Firebase', e, stackTrace,
          'ProjectsRemoteDataSource');
      rethrow;
    }
  }
}
