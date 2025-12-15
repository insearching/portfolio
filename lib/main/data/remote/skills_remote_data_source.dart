import 'package:portfolio/main/data/mapper/firebase_raw_data_mapper.dart';
import 'package:portfolio/main/data/mapper/skill_remote_model_mapper.dart';
import 'package:portfolio/main/data/utils/typedefs.dart';
import 'package:portfolio/main/domain/model/skill.dart';

/// Remote data source for Skills
/// Handles all Firebase Realtime Database operations for skills
abstract class SkillsRemoteDataSource {
  Future<void> addSkill(Skill skill);

  Future<List<Skill>> readSkills();
}

class SkillsRemoteDataSourceImpl implements SkillsRemoteDataSource {
  SkillsRemoteDataSourceImpl({
    required this.firebaseDatabaseReference,
  });

  final FirebaseDatabaseReference firebaseDatabaseReference;
  static const String _collectionName = 'skills';

  @override
  Future<void> addSkill(Skill skill) async {
    final skillsCollection = firebaseDatabaseReference.child(_collectionName);

    try {
      final model = skillRemoteModelFromDomain(skill);
      await skillsCollection.push().set(model.toJson());
      print('Skill added successfully to Firebase');
    } catch (e) {
      print('Error adding skill to Firebase: $e');
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

      print('Loaded ${skills.length} skills from Firebase');
      return skills;
    } catch (e) {
      print('Error parsing skills from Firebase: $e');
      rethrow;
    }
  }
}
