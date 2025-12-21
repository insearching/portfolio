import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/logger/app_logger.dart';
import 'package:portfolio/main/data/local/sqlite/education_local_data_source.dart';
import 'package:portfolio/main/data/local/sqlite/personal_info_local_data_source.dart';
import 'package:portfolio/main/data/local/sqlite/positions_local_data_source.dart';
import 'package:portfolio/main/data/local/sqlite/posts_local_data_source.dart';
import 'package:portfolio/main/data/local/sqlite/projects_local_data_source.dart';
import 'package:portfolio/main/data/local/sqlite/skills_local_data_source.dart';
import 'package:portfolio/main/data/remote/education_remote_data_source.dart';
import 'package:portfolio/main/data/remote/personal_info_remote_data_source.dart';
import 'package:portfolio/main/data/remote/positions_remote_data_source.dart';
import 'package:portfolio/main/data/remote/posts_remote_data_source.dart';
import 'package:portfolio/main/data/remote/projects_remote_data_source.dart';
import 'package:portfolio/main/data/remote/skills_remote_data_source.dart';
import 'package:portfolio/main/data/repository/base_repository.dart';
import 'package:portfolio/main/data/repository/blog_repository.dart';
import 'package:portfolio/main/data/repository/education_repository.dart';
import 'package:portfolio/main/data/repository/personal_info_repository.dart';
import 'package:portfolio/main/data/repository/position_repository.dart';
import 'package:portfolio/main/data/repository/project_repository.dart';
import 'package:portfolio/main/data/repository/skill_repository.dart';
import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/domain/model/personal_info.dart';
import 'package:portfolio/main/domain/model/position.dart';
import 'package:portfolio/main/domain/model/post.dart';
import 'package:portfolio/main/domain/model/project.dart';
import 'package:portfolio/main/domain/model/skill.dart';
import 'package:portfolio/main/domain/model/social_info.dart';

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

  group('BaseRepository', () {
    test('fetchWithCache emits memory -> local -> remote and caches remote',
        () async {
      final local = _FakeListLocal<int>(items: [2]);
      final remote = _FakeListRemote<int>(items: [3]);
      final repo = _TestIntRepository(remote: remote, local: local);

      // Prime memory cache
      repo.updateMemoryCacheWithItem(1);

      final emitted = await repo.fetchWithCache(entityName: 'ints').toList();

      // Memory cache is empty initially (updateMemoryCacheWithItem only adds if cache exists)
      // so we expect local then remote.
      expect(emitted, [
        [2],
        [3],
      ]);

      expect(local.savedItems, [3]);

      // Now memory cache should exist and emit first.
      final emitted2 = await repo.fetchWithCache(entityName: 'ints').toList();
      expect(emitted2.first, [3]);
    });

    test('fetchWithCache emits [] when all layers empty', () async {
      final local = _FakeListLocal<int>(items: []);
      final remote = _FakeListRemote<int>(items: []);
      final repo = _TestIntRepository(remote: remote, local: local);

      final emitted = await repo.fetchWithCache(entityName: 'ints').toList();
      expect(emitted, [<int>[]]);
    });
  });

  group('Concrete repositories', () {
    test(
        'BlogRepositoryImpl.addPost calls remote, caches locally, updates memory',
        () async {
      final remote = _FakePostsRemoteDataSource(initial: [
        const Post(title: 'p1', description: 'd', imageLink: 'i', link: 'l'),
      ]);
      final local = _FakePostsLocalDataSource(initial: []);

      final repo = BlogRepositoryImpl(
          remoteDataSource: remote,
          localDataSource: local,
          logger: testLocator<AppLogger>());

      // Populate memory cache
      await repo.postsUpdateStream.last;

      await repo.addPost(
        const Post(title: 'p2', description: 'd', imageLink: 'i', link: 'l'),
      );

      expect(remote.addCalled, isTrue);
      expect(local.cachedSingleTitles, contains('p2'));

      // Next fetch should emit from memory containing the new post.
      final firstEmission = await repo.postsUpdateStream.first;
      expect(firstEmission.map((p) => p.title).toList(),
          containsAll(['p1', 'p2']));
    });

    test('EducationRepositoryImpl streams local then remote', () async {
      final remote = _FakeEducationRemote([_edu('r')]);
      final local = _FakeEducationLocal([_edu('l')]);
      final repo = EducationRepositoryImpl(
          remoteDataSource: remote,
          localDataSource: local,
          logger: testLocator<AppLogger>());

      final emitted = await repo.educationUpdateStream.toList();
      expect(emitted.length, 2);
      expect(emitted.first.single.title, 'l');
      expect(emitted.last.single.title, 'r');
    });

    test('ProjectRepositoryImpl streams local then remote', () async {
      final remote = _FakeProjectsRemote([_proj('r')]);
      final local = _FakeProjectsLocal([_proj('l')]);
      final repo = ProjectRepositoryImpl(
          remoteDataSource: remote,
          localDataSource: local,
          logger: testLocator<AppLogger>());

      final emitted = await repo.projectsUpdateStream.toList();
      expect(emitted.length, 2);
      expect(emitted.first.single.title, 'l');
      expect(emitted.last.single.title, 'r');
    });

    test('PositionRepositoryImpl streams local then remote', () async {
      final remote = _FakePositionsRemote([_pos('r')]);
      final local = _FakePositionsLocal([_pos('l')]);
      final repo = PositionRepositoryImpl(
          remoteDataSource: remote,
          localDataSource: local,
          logger: testLocator<AppLogger>());

      final emitted = await repo.positionsUpdateStream.toList();
      expect(emitted.length, 2);
      expect(emitted.first.single.title, 'l');
      expect(emitted.last.single.title, 'r');
    });

    test('SkillRepositoryImpl streams local then remote', () async {
      final remote = _FakeSkillsRemote([_skill('r')]);
      final local = _FakeSkillsLocal([_skill('l')]);
      final repo = SkillRepositoryImpl(
          remoteDataSource: remote,
          localDataSource: local,
          logger: testLocator<AppLogger>());

      final emitted = await repo.skillsUpdateStream.toList();
      expect(emitted.length, 2);
      expect(emitted.first.single.title, 'l');
      expect(emitted.last.single.title, 'r');
    });

    test('PersonalInfoRepositoryImpl emits memory -> local -> remote',
        () async {
      final remote = _FakePersonalInfoRemote(const PersonalInfo(
        image: 'r',
        title: 'r',
        description: 'r',
        email: 'r',
        socials: [SocialInfo.github],
      ));
      final local = _FakePersonalInfoLocal(const PersonalInfo(
        image: 'l',
        title: 'l',
        description: 'l',
        email: 'l',
        socials: [SocialInfo.linkedin],
      ));

      final repo = PersonalInfoRepositoryImpl(
          remoteDataSource: remote,
          localDataSource: local,
          logger: testLocator<AppLogger>());

      final values = await repo.personalInfoUpdateStream.toList();
      expect(values.length, 2);
      expect(values.first!.email, 'l');
      expect(values.last!.email, 'r');

      // After first run, memory cache is set; should emit immediately.
      final first = await repo.personalInfoUpdateStream.first;
      expect(first!.email, 'r');
    });
  });
}

// --------- BaseRepository test harness ---------

class _FakeListRemote<T> {
  _FakeListRemote({required this.items});

  final List<T> items;

  Future<List<T>> fetch() async => List<T>.from(items);
}

class _FakeListLocal<T> {
  _FakeListLocal({required this.items});

  final List<T> items;
  List<T>? savedItems;

  Future<List<T>> read() async => List<T>.from(items);

  Future<void> save(List<T> newItems) async {
    savedItems = List<T>.from(newItems);
  }

  Future<void> clear() async {
    items.clear();
  }
}

class _TestIntRepository
    extends BaseRepository<int, _FakeListRemote<int>, _FakeListLocal<int>> {
  _TestIntRepository({
    required _FakeListRemote<int> remote,
    required _FakeListLocal<int> local,
  })  : _remote = remote,
        _local = local,
        super(
          remoteDataSource: remote,
          localDataSource: local,
          logger: testLocator<AppLogger>(),
        );

  final _FakeListRemote<int> _remote;
  final _FakeListLocal<int> _local;

  @override
  Future<List<int>> fetchFromRemote() => _remote.fetch();

  @override
  Future<List<int>> fetchFromLocal() => _local.read();

  @override
  Future<void> saveToLocal(List<int> items) => _local.save(items);

  @override
  Future<void> clearLocalCache() => _local.clear();
}

// --------- Fakes for concrete repositories ---------

class _FakePostsRemoteDataSource implements PostsRemoteDataSource {
  _FakePostsRemoteDataSource({required List<Post> initial})
      : _posts = List.from(initial);

  final List<Post> _posts;
  bool addCalled = false;

  @override
  Future<void> addPost(Post post) async {
    addCalled = true;
    _posts.add(post);
  }

  @override
  Future<List<Post>> readPosts() async => List<Post>.from(_posts);
}

class _FakePostsLocalDataSource implements PostsLocalDataSource {
  _FakePostsLocalDataSource({required List<Post> initial})
      : _posts = List.from(initial);

  final List<Post> _posts;
  final List<String> cachedSingleTitles = [];

  @override
  Future<void> cachePost(Post post) async {
    cachedSingleTitles.add(post.title);
    _posts.add(post);
  }

  @override
  Future<void> cachePosts(List<Post> posts) async {
    _posts
      ..clear()
      ..addAll(posts);
  }

  @override
  Future<List<Post>> getCachedPosts() async => List<Post>.from(_posts);

  @override
  Future<void> clearCache() async => _posts.clear();
}

Education _edu(String s) => Education(
      title: s,
      description: s,
      type: EducationType.certification,
      text: null,
      link: null,
      imageUrl: null,
    );

class _FakeEducationRemote implements EducationRemoteDataSource {
  _FakeEducationRemote(this._items);

  final List<Education> _items;

  @override
  Future<void> addEducation(Education education) async {
    _items.add(education);
  }

  @override
  Future<List<Education>> readEducation() async => List<Education>.from(_items);
}

class _FakeEducationLocal implements EducationLocalDataSource {
  _FakeEducationLocal(this._items);

  final List<Education> _items;

  @override
  Future<void> saveEducation(Education education) async {}

  @override
  Future<void> saveEducationList(List<Education> educationList) async {
    _items
      ..clear()
      ..addAll(educationList);
  }

  @override
  Future<List<Education>> getEducation() async => List<Education>.from(_items);

  @override
  Future<void> clearCache() async => _items.clear();
}

Project _proj(String s) => Project(
      image: s,
      title: s,
      role: s,
      description: s,
      link: null,
    );

class _FakeProjectsRemote implements ProjectsRemoteDataSource {
  _FakeProjectsRemote(this._items);

  final List<Project> _items;

  @override
  Future<void> addProject(Project project) async {
    _items.add(project);
  }

  @override
  Future<List<Project>> readProjects() async => List<Project>.from(_items);
}

class _FakeProjectsLocal implements ProjectsLocalDataSource {
  _FakeProjectsLocal(this._items);

  final List<Project> _items;

  @override
  Future<void> saveProject(Project project) async {}

  @override
  Future<void> saveProjects(List<Project> projects) async {
    _items
      ..clear()
      ..addAll(projects);
  }

  @override
  Future<List<Project>> getProjects() async => List<Project>.from(_items);

  @override
  Future<void> clearCache() async => _items.clear();
}

Position _pos(String s) => Position(
      title: s,
      position: s,
      description: s,
      icon: s,
    );

class _FakePositionsRemote implements PositionsRemoteDataSource {
  _FakePositionsRemote(this._items);

  final List<Position> _items;

  @override
  Future<void> addPosition(Position position) async {
    _items.add(position);
  }

  @override
  Future<List<Position>> readPositions() async => List<Position>.from(_items);
}

class _FakePositionsLocal implements PositionsLocalDataSource {
  _FakePositionsLocal(this._items);

  final List<Position> _items;

  @override
  Future<void> savePosition(Position position) async {}

  @override
  Future<void> savePositions(List<Position> positions) async {
    _items
      ..clear()
      ..addAll(positions);
  }

  @override
  Future<List<Position>> getPositions() async => List<Position>.from(_items);

  @override
  Future<void> clearCache() async => _items.clear();
}

Skill _skill(String s) => Skill(title: s, value: 1, type: SkillType.hard);

class _FakeSkillsRemote implements SkillsRemoteDataSource {
  _FakeSkillsRemote(this._items);

  final List<Skill> _items;

  @override
  Future<void> addSkill(Skill skill) async {
    _items.add(skill);
  }

  @override
  Future<List<Skill>> readSkills() async => List<Skill>.from(_items);
}

class _FakeSkillsLocal implements SkillsLocalDataSource {
  _FakeSkillsLocal(this._items);

  final List<Skill> _items;

  @override
  Future<void> saveSkill(Skill skill) async {}

  @override
  Future<void> saveSkills(List<Skill> skills) async {
    _items
      ..clear()
      ..addAll(skills);
  }

  @override
  Future<List<Skill>> getSkills() async => List<Skill>.from(_items);

  @override
  Future<void> clearCache() async => _items.clear();
}

class _FakePersonalInfoRemote implements PersonalInfoRemoteDataSource {
  _FakePersonalInfoRemote(this._info);

  final PersonalInfo? _info;

  @override
  Future<PersonalInfo?> readPersonalInfo() async => _info;

  @override
  Future<void> writePersonalInfo(PersonalInfo info) async {}
}

class _FakePersonalInfoLocal implements PersonalInfoLocalDataSource {
  _FakePersonalInfoLocal(this._info);

  PersonalInfo? _info;

  @override
  Future<void> savePersonalInfo(PersonalInfo info) async {
    _info = info;
  }

  @override
  Future<PersonalInfo?> getPersonalInfo() async => _info;

  @override
  Future<void> clearCache() async {
    _info = null;
  }
}
