import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/logger/app_logger.dart';
import 'package:portfolio/main/data/local/web/education_local_data_source_web.dart';
import 'package:portfolio/main/data/local/web/personal_info_local_data_source_web.dart';
import 'package:portfolio/main/data/local/web/positions_local_data_source_web.dart';
import 'package:portfolio/main/data/local/web/posts_local_data_source_web.dart';
import 'package:portfolio/main/data/local/web/projects_local_data_source_web.dart';
import 'package:portfolio/main/data/local/web/skills_local_data_source_web.dart';
import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/domain/model/personal_info.dart';
import 'package:portfolio/main/domain/model/position.dart';
import 'package:portfolio/main/domain/model/post.dart';
import 'package:portfolio/main/domain/model/project.dart';
import 'package:portfolio/main/domain/model/skill.dart';
import 'package:portfolio/main/domain/model/social_info.dart';

import '../../../../helpers/test_service_locator.dart';

void main() {
  // Setup test dependencies before all tests (web mode)
  setUpAll(() async {
    await setupTestLocator(useWeb: true);
  });

  // Clean up after all tests
  tearDownAll(() async {
    await tearDownTestLocator();
  });

  group('Web local data sources (in-memory)', () {
    test('PostsLocalDataSourceWebImpl caches list and clears', () async {
      final ds = PostsLocalDataSourceWebImpl(logger: testLocator<AppLogger>());

      await ds.cachePosts(
        const [
          Post(title: 't', description: 'd', imageLink: 'i', link: 'l'),
        ],
      );

      expect((await ds.getCachedPosts()).length, 1);

      await ds.clearCache();
      expect(await ds.getCachedPosts(), isEmpty);
    });

    test('SkillsLocalDataSourceWebImpl caches list and clears', () async {
      final ds = SkillsLocalDataSourceWebImpl(logger: testLocator<AppLogger>());

      await ds.cacheSkills(
        const [Skill(title: 't', value: 1, type: SkillType.hard)],
      );

      expect((await ds.getCachedSkills()).single.title, 't');

      await ds.clearCache();
      expect(await ds.getCachedSkills(), isEmpty);
    });

    test('ProjectsLocalDataSourceWebImpl caches list and clears', () async {
      final ds =
          ProjectsLocalDataSourceWebImpl(logger: testLocator<AppLogger>());

      await ds.cacheProjects(
        const [
          Project(
            image: 'i',
            title: 't',
            role: 'r',
            description: 'd',
            link: null,
          ),
        ],
      );

      expect((await ds.getCachedProjects()).single.title, 't');

      await ds.clearCache();
      expect(await ds.getCachedProjects(), isEmpty);
    });

    test('PositionsLocalDataSourceWebImpl caches list and clears', () async {
      final ds =
          PositionsLocalDataSourceWebImpl(logger: testLocator<AppLogger>());

      await ds.cachePositions(
        const [
          Position(title: 't', position: 'p', description: 'd', icon: 'i'),
        ],
      );

      expect((await ds.getCachedPositions()).single.position, 'p');

      await ds.clearCache();
      expect(await ds.getCachedPositions(), isEmpty);
    });

    test('EducationLocalDataSourceWebImpl caches list and clears', () async {
      final ds =
          EducationLocalDataSourceWebImpl(logger: testLocator<AppLogger>());

      await ds.cacheEducationList(
        const [
          Education(
            title: 't',
            description: 'd',
            type: EducationType.certification,
            text: null,
            link: null,
            imageUrl: null,
          ),
        ],
      );

      expect((await ds.getCachedEducation()).single.title, 't');

      await ds.clearCache();
      expect(await ds.getCachedEducation(), isEmpty);
    });

    test('PersonalInfoLocalDataSourceWebImpl caches item and clears', () async {
      final ds =
          PersonalInfoLocalDataSourceWebImpl(logger: testLocator<AppLogger>());

      await ds.cachePersonalInfo(
        const PersonalInfo(
          image: 'i',
          title: 't',
          description: 'd',
          email: 'e',
          socials: [SocialInfo.github],
        ),
      );

      expect((await ds.getCachedPersonalInfo())!.email, 'e');

      await ds.clearCache();
      expect(await ds.getCachedPersonalInfo(), isNull);
    });
  });
}
