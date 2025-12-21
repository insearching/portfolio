import 'package:portfolio/main/data/mapper/firebase_raw_data_mapper.dart';
import 'package:portfolio/main/data/mapper/skill_remote_model_mapper.dart';
import 'package:portfolio/main/data/utils/typedefs.dart';
import 'package:portfolio/main/domain/model/skill.dart';
import 'package:portfolio/core/logger/app_logger.dart';

/// Remote data source for Skills
/// Handles all Firebase Realtime Database operations for skills
abstract class SkillsRemoteDataSource {
  Future<void> addSkill(Skill skill);

  Future<List<Skill>> readSkills();
}

class SkillsRemoteDataSourceImpl implements SkillsRemoteDataSource {
  SkillsRemoteDataSourceImpl({
required this.firebaseDatabaseReference,
    required this.logger,
  });

  final FirebaseDatabaseReference firebaseDatabaseReference;
  final AppLogger logger;
  static const String _collectionName = 'skills';

  @override
  Future<void> addSkill(Skill skill) async {
    final skillsCollection = firebaseDatabaseReference.child(_collectionName);

    try {
      final model = skillRemoteModelFromDomain(skill);
      await skillsCollection.push().set(model.toJson());
      logger.debug('Skill added successfully to Firebase', 'SkillsRemoteDataSource');
    } catch (e, stackTrace) {
      logger.error('Error adding skill to Firebase', e, stackTrace, 'SkillsRemoteDataSource');
      rethrow;
    }
  }

  @override
  Future<List<Skill>> readSkills() async {
    final skillsCollection = firebaseDatabaseReference.child(_collectionName);
    final event = await skillsCollection.once();

    final rawData = event.snapshot.value;
    if (rawData == null) return [];

    try {
      final skills = firebaseRawToJsonMaps(rawData)
          .map(skillRemoteModelFromJson)
          .map((m) => m.toDomain())
          .toList();

      logger.debug('Loaded ${skills.length} skills from Firebase', 'SkillsRemoteDataSource');
      return skills;
    } catch (e, stackTrace) {
      logger.error('Error parsing skills from Firebase', e, stackTrace, 'SkillsRemoteDataSource');
      rethrow;
    }
  }
}
