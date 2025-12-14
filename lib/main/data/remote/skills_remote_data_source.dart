import 'package:portfolio/main/data/skill.dart';
import 'package:portfolio/main/data/typedefs.dart';

/// Remote data source for Skills
/// Handles all Firebase Realtime Database operations for skills
abstract class SkillsRemoteDataSource {
  Future<List<Skill>> readSkills();
}

class SkillsRemoteDataSourceImpl implements SkillsRemoteDataSource {
  SkillsRemoteDataSourceImpl({
    required this.firebaseDatabaseReference,
  });

  final FirebaseDatabaseReference firebaseDatabaseReference;
  static const String _collectionName = 'skills';

  @override
  Future<List<Skill>> readSkills() async {
    final skillsCollection = firebaseDatabaseReference.child(_collectionName);
    final event = await skillsCollection.once();

    if (event.snapshot.value == null) return [];

    try {
      final rawData = event.snapshot.value;
      final List<Skill> skills = [];

      // Handle both Map (from .push()) and List formats
      if (rawData is Map) {
        // Firebase returns Map when using .push()
        for (var entry in rawData.entries) {
          final value = entry.value;
          if (value is Map) {
            skills.add(
              Skill(
                title: value['title']?.toString() ?? '',
                value: (value['value'] as num?)?.toInt() ?? 0,
                type: _parseSkillType(value['type']?.toString() ?? 'hard'),
              ),
            );
          }
        }
      } else if (rawData is List) {
        // Handle List format (if data is structured as array)
        for (var value in rawData) {
          if (value is Map) {
            skills.add(
              Skill(
                title: value['title']?.toString() ?? '',
                value: (value['value'] as num?)?.toInt() ?? 0,
                type: _parseSkillType(value['type']?.toString() ?? 'hard'),
              ),
            );
          }
        }
      }

      print('Loaded ${skills.length} skills from Firebase');
      return skills;
    } catch (e) {
      print('Error parsing skills from Firebase: $e');
      rethrow;
    }
  }

  /// Helper method to parse SkillType from string
  SkillType _parseSkillType(String typeString) {
    return typeString.toLowerCase() == 'soft' ? SkillType.soft : SkillType.hard;
  }
}
