import 'package:portfolio/core/logger/app_logger.dart';
import 'dart:convert';

import 'package:portfolio/main/data/mapper/social_info_remote_model_mapper.dart';
import 'package:portfolio/main/domain/model/personal_info.dart';
import 'package:sqflite/sqflite.dart';

/// Local data source for PersonalInfo
/// Handles all SQLite database operations for personal info caching
abstract class PersonalInfoLocalDataSource {
  Future<void> savePersonalInfo(PersonalInfo info);

  Future<PersonalInfo?> getPersonalInfo();

  Future<void> clearCache();
}

class PersonalInfoLocalDataSourceImpl implements PersonalInfoLocalDataSource {
  PersonalInfoLocalDataSourceImpl({
    required this.database,
    required this.logger,
  });

  final Database database;
  final AppLogger logger;
  static const String _tableName = 'personal_info';
  static const String _tag = 'PersonalInfoLocalDataSource';

  @override
  Future<void> savePersonalInfo(PersonalInfo info) async {
    try {
      // Clear existing data first (only one record should exist)
      await database.delete(_tableName);

      // Convert socials list to JSON string for storage
      final socialsJson =
          jsonEncode(info.socials.map(socialInfoToJsonMap).toList());

      await database.insert(
        _tableName,
        {
          'image': info.image,
          'title': info.title,
          'description': info.description,
          'email': info.email,
          'socials': socialsJson,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      logger.debug('Personal info cached successfully in SQLite', _tag);
    } catch (e, stackTrace) {
      logger.error(
          'Error caching personal info in SQLite', e, stackTrace, _tag);
      rethrow;
    }
  }

  @override
  Future<PersonalInfo?> getPersonalInfo() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        _tableName,
        limit: 1,
      );

      if (maps.isEmpty) return null;

      final map = maps.first;

      // Parse socials from JSON string
      final socialsJson = map['socials'] as String? ?? '[]';
      final socialsList = jsonDecode(socialsJson) as List<dynamic>;
      final socials = socialsList
          .whereType<Map>()
          .map((s) => socialInfoFromJsonMap(Map<String, dynamic>.from(s)))
          .toList();

      return PersonalInfo(
        image: map['image'] as String? ?? '',
        title: map['title'] as String? ?? '',
        description: map['description'] as String? ?? '',
        email: map['email'] as String? ?? '',
        socials: socials,
      );
    } catch (e, stackTrace) {
      logger.error('Error getting cached personal info from SQLite', e,
          stackTrace, _tag);
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await database.delete(_tableName);
      logger.debug('Personal info cache cleared successfully', _tag);
    } catch (e, stackTrace) {
      logger.error('Error clearing personal info cache', e, stackTrace, _tag);
      rethrow;
    }
  }
}
