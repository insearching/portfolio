import 'dart:convert';

import 'package:portfolio/main/data/personal_info.dart';
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
  });

  final Database database;
  static const String _tableName = 'personal_info';

  @override
  Future<void> savePersonalInfo(PersonalInfo info) async {
    try {
      // Clear existing data first (only one record should exist)
      await database.delete(_tableName);

      // Convert socials list to JSON string for storage
      final socialsJson =
          jsonEncode(info.socials.map((s) => s.toJson()).toList());

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
      print('Personal info cached successfully in SQLite');
    } catch (e) {
      print('Error caching personal info in SQLite: $e');
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
          .map((s) => SocialInfo.fromJson(s as Map<String, dynamic>))
          .toList();

      return PersonalInfo(
        image: map['image'] as String? ?? '',
        title: map['title'] as String? ?? '',
        description: map['description'] as String? ?? '',
        email: map['email'] as String? ?? '',
        socials: socials,
      );
    } catch (e) {
      print('Error getting cached personal info from SQLite: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await database.delete(_tableName);
      print('Personal info cache cleared successfully');
    } catch (e) {
      print('Error clearing personal info cache: $e');
      rethrow;
    }
  }
}
