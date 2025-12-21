import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/logger/app_logger.dart';
import 'package:portfolio/main/data/remote/education_remote_data_source.dart';
import 'package:portfolio/main/data/remote/personal_info_remote_data_source.dart';
import 'package:portfolio/main/data/remote/positions_remote_data_source.dart';
import 'package:portfolio/main/data/remote/posts_remote_data_source.dart';
import 'package:portfolio/main/data/remote/projects_remote_data_source.dart';
import 'package:portfolio/main/data/remote/skills_remote_data_source.dart';
import 'package:portfolio/main/domain/model/personal_info.dart';
import 'package:portfolio/main/domain/model/post.dart';
import 'package:portfolio/main/domain/model/social_info.dart';

import '../../../helpers/fake_firebase_auth.dart';
import '../../../helpers/fake_firebase_database.dart';
import '../../../helpers/test_service_locator.dart';

void main() {
  // Setup test dependencies before all tests
  setUpAll(() async {
    await setupTestLocator();
  });

  // Clean up after all tests
  tearDownAll(() async {
    await tearDownTestLocator();
  });

  group('Remote data sources (Firebase)', () {
    test('EducationRemoteDataSourceImpl.readEducation parses map snapshots',
        () async {
      final root = FakeDatabaseReference.root(
        initialValue: {
          'education': {
            'a': {
              'title': 'T1',
              'description': 'D1',
              'type': 'college',
            },
            'b': {
              'title': 'T2',
              'description': 'D2',
              'type': 'certification',
            },
          },
        },
      );

      final ds = EducationRemoteDataSourceImpl(
          firebaseDatabaseReference: root, logger: testLocator<AppLogger>());
      final items = await ds.readEducation();

      expect(items.length, 2);
      expect(items.first.title, 'T1');
      expect(items.last.title, 'T2');
    });

    test('SkillsRemoteDataSourceImpl.readSkills parses list snapshots',
        () async {
      final root = FakeDatabaseReference.root(
        initialValue: {
          'skills': [
            {'title': 'Dart', 'value': 90, 'type': 'hard'},
            {'title': 'Communication', 'value': 80, 'type': 'soft'},
          ],
        },
      );

      final ds = SkillsRemoteDataSourceImpl(
          firebaseDatabaseReference: root, logger: testLocator<AppLogger>());
      final items = await ds.readSkills();

      expect(items.length, 2);
      expect(items.first.title, 'Dart');
      expect(items.last.title, 'Communication');
      expect(items.last.type.name, 'soft');
    });

    test(
        'ProjectsRemoteDataSourceImpl.readProjects returns [] on null snapshot',
        () async {
      final root = FakeDatabaseReference.root(initialValue: {'projects': null});
      final ds = ProjectsRemoteDataSourceImpl(
          firebaseDatabaseReference: root, logger: testLocator<AppLogger>());

      final items = await ds.readProjects();
      expect(items, isEmpty);
    });

    test('PositionsRemoteDataSourceImpl.readPositions parses map snapshots',
        () async {
      final root = FakeDatabaseReference.root(
        initialValue: {
          'positions': {
            'a': {
              'title': 'Android',
              'position': 'Dev',
              'description': 'Desc',
              'icon': 'assets/img/android.png',
            },
          },
        },
      );

      final ds = PositionsRemoteDataSourceImpl(
          firebaseDatabaseReference: root, logger: testLocator<AppLogger>());
      final items = await ds.readPositions();

      expect(items.length, 1);
      expect(items.single.title, 'Android');
    });

    test('PostsRemoteDataSourceImpl.readPosts parses map snapshots', () async {
      final root = FakeDatabaseReference.root(
        initialValue: {
          'posts': {
            'a': {
              'title': 'Hello',
              'description': 'World',
              'imageLink': 'img',
              'link': 'url',
            },
          },
        },
      );

      final ds = PostsRemoteDataSourceImpl(
          firebaseDatabaseReference: root, logger: testLocator<AppLogger>());
      final posts = await ds.readPosts();

      expect(posts.length, 1);
      expect(posts.single.title, 'Hello');
    });

    test('PostsRemoteDataSourceImpl.addPost pushes to /posts', () async {
      final root = FakeDatabaseReference.root(initialValue: {});
      final ds = PostsRemoteDataSourceImpl(
          firebaseDatabaseReference: root, logger: testLocator<AppLogger>());

      await ds.addPost(
        const Post(
          title: 'T',
          description: 'D',
          imageLink: 'I',
          link: 'L',
        ),
      );

      final posts =
          (root.child('posts') as FakeDatabaseReference).debugReadValue();
      expect(posts, isA<Map>());
      expect((posts as Map).length, 1);

      final pushed = posts.values.first;
      expect(pushed, isA<Map>());
      expect((pushed as Map)['title'], 'T');
    });

    test(
        'PersonalInfoRemoteDataSourceImpl.readPersonalInfo returns null on null',
        () async {
      final root =
          FakeDatabaseReference.root(initialValue: {'personal_info': null});
      final ds = PersonalInfoRemoteDataSourceImpl(
          firebaseDatabaseReference: root, logger: testLocator<AppLogger>());

      final info = await ds.readPersonalInfo();
      expect(info, isNull);
    });

    test(
        'PersonalInfoRemoteDataSourceImpl.readPersonalInfo parses socials as list',
        () async {
      final root = FakeDatabaseReference.root(
        initialValue: {
          'personal_info': {
            'image': 'img',
            'title': 'title',
            'description': 'desc',
            'email': 'mail',
            'socials': [
              {'url': SocialInfo.github.url, 'icon': SocialInfo.github.icon},
            ],
          },
        },
      );

      final ds = PersonalInfoRemoteDataSourceImpl(
          firebaseDatabaseReference: root, logger: testLocator<AppLogger>());
      final info = await ds.readPersonalInfo();

      expect(info, isNotNull);
      expect(info!.socials, [SocialInfo.github]);
    });

    test(
        'PersonalInfoRemoteDataSourceImpl.writePersonalInfo authenticates and sets data',
        () async {
      final root = FakeDatabaseReference.root(initialValue: {});
      final auth = FakeFirebaseAuth(currentUser: null);

      final ds = PersonalInfoRemoteDataSourceImpl(
        firebaseDatabaseReference: root,
        firebaseAuth: auth,
        firebaseEmail: 'e',
        firebasePassword: 'p',
        logger: testLocator<AppLogger>(),
      );

      await ds.writePersonalInfo(
        const PersonalInfo(
          image: 'img',
          title: 'title',
          description: 'desc',
          email: 'mail',
          socials: [SocialInfo.linkedin],
        ),
      );

      expect(auth.signInCalled, isTrue);
      expect(auth.signOutCalled, isTrue);

      final written = (root.child('personal_info') as FakeDatabaseReference)
          .debugReadValue();
      expect(written, isA<Map>());
      expect((written as Map)['title'], 'title');
      expect((written)['socials'], isA<List>());
    });
  });
}
