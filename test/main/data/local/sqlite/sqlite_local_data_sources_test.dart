import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/logger/app_logger.dart';
import 'package:portfolio/main/data/local/sqlite/education_local_data_source.dart';
import 'package:portfolio/main/data/local/sqlite/personal_info_local_data_source.dart';
import 'package:portfolio/main/data/local/sqlite/positions_local_data_source.dart';
import 'package:portfolio/main/data/local/sqlite/posts_local_data_source.dart';
import 'package:portfolio/main/data/local/sqlite/projects_local_data_source.dart';
import 'package:portfolio/main/data/local/sqlite/skills_local_data_source.dart';
import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/domain/model/personal_info.dart';
import 'package:portfolio/main/domain/model/position.dart';
import 'package:portfolio/main/domain/model/post.dart';
import 'package:portfolio/main/domain/model/project.dart';
import 'package:portfolio/main/domain/model/skill.dart';
import 'package:portfolio/main/domain/model/social_info.dart';

import '../../../../helpers/fake_sqflite.dart';
import '../../../../helpers/test_service_locator.dart';

void main() {
  // Setup test dependencies before all tests
  setUpAll(() async {
    await setupTestLocator();
  });

  // Clean up after all tests
  tearDownAll(() async {
    await tearDownTestLocator();
  });

  group('SQLite local data sources', () {
    test('PostsLocalDataSourceImpl caches and reads posts', () async {
      final db = FakeDatabase();
      final ds = PostsLocalDataSourceImpl(
          database: db, logger: testLocator<AppLogger>());

      await ds.cachePosts(
        const [
          Post(title: 't1', description: 'd1', imageLink: 'i1', link: 'l1'),
          Post(title: 't2', description: 'd2', imageLink: 'i2', link: 'l2'),
        ],
      );

      final posts = await ds.getCachedPosts();
      expect(posts.length, 2);
      expect(posts.first.title, 't1');

      await ds.clearCache();
      expect(await ds.getCachedPosts(), isEmpty);
    });

    test('ProjectsLocalDataSourceImpl caches and reads projects', () async {
      final db = FakeDatabase();
      final ds = ProjectsLocalDataSourceImpl(
          database: db, logger: testLocator<AppLogger>());

      await ds.saveProjects(
        const [
          Project(
            image: 'img',
            title: 'p1',
            role: 'r1',
            description: 'd1',
            link: null,
          ),
        ],
      );

      final projects = await ds.getProjects();
      expect(projects.length, 1);
      expect(projects.single.title, 'p1');

      await ds.clearCache();
      expect(await ds.getProjects(), isEmpty);
    });

    test('SkillsLocalDataSourceImpl caches and reads skills (type mapping)',
        () async {
      final db = FakeDatabase();
      final ds = SkillsLocalDataSourceImpl(
          database: db, logger: testLocator<AppLogger>());

      await ds.saveSkills(
        const [
          Skill(title: 'S1', value: 10, type: SkillType.hard),
          Skill(title: 'S2', value: 20, type: SkillType.soft),
        ],
      );

      final skills = await ds.getSkills();
      expect(skills.length, 2);
      expect(skills.first.type, SkillType.hard);
      expect(skills.last.type, SkillType.soft);

      await ds.clearCache();
      expect(await ds.getSkills(), isEmpty);
    });

    test('PositionsLocalDataSourceImpl caches and reads positions', () async {
      final db = FakeDatabase();
      final ds = PositionsLocalDataSourceImpl(
          database: db, logger: testLocator<AppLogger>());

      await ds.savePositions(
        const [
          Position(
            title: 't',
            position: 'p',
            description: 'd',
            icon: 'icon',
          ),
        ],
      );

      final positions = await ds.getPositions();
      expect(positions.length, 1);
      expect(positions.single.position, 'p');

      await ds.clearCache();
      expect(await ds.getPositions(), isEmpty);
    });

    test('EducationLocalDataSourceImpl caches and reads education', () async {
      final db = FakeDatabase();
      final ds = EducationLocalDataSourceImpl(
          database: db, logger: testLocator<AppLogger>());

      await ds.saveEducationList(
        const [
          Education(
            title: 't',
            description: 'd',
            type: EducationType.college,
            text: null,
            link: null,
            imageUrl: null,
          ),
        ],
      );

      final education = await ds.getEducation();
      expect(education.length, 1);
      expect(education.single.type, EducationType.college);

      await ds.clearCache();
      expect(await ds.getEducation(), isEmpty);
    });

    test('PersonalInfoLocalDataSourceImpl saves and reads personal info',
        () async {
      final db = FakeDatabase();
      final ds = PersonalInfoLocalDataSourceImpl(
          database: db, logger: testLocator<AppLogger>());

      await ds.savePersonalInfo(
        const PersonalInfo(
          image: 'img',
          title: 't',
          description: 'd',
          email: 'e',
          socials: [SocialInfo.github, SocialInfo.linkedin],
        ),
      );

      final info = await ds.getPersonalInfo();
      expect(info, isNotNull);
      expect(info!.email, 'e');
      expect(info.socials.length, 2);

      await ds.clearCache();
      expect(await ds.getPersonalInfo(), isNull);
    });
  });
}
