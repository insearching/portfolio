import 'package:get_it/get_it.dart';
import 'package:portfolio/core/logger/app_logger.dart';
import 'package:portfolio/main/data/local/sqlite/education_local_data_source.dart';
import 'package:portfolio/main/data/local/sqlite/personal_info_local_data_source.dart';
import 'package:portfolio/main/data/local/sqlite/positions_local_data_source.dart';
import 'package:portfolio/main/data/local/sqlite/posts_local_data_source.dart';
import 'package:portfolio/main/data/local/sqlite/projects_local_data_source.dart';
import 'package:portfolio/main/data/local/sqlite/skills_local_data_source.dart';
import 'package:portfolio/main/data/local/web/education_local_data_source_web.dart';
import 'package:portfolio/main/data/local/web/personal_info_local_data_source_web.dart';
import 'package:portfolio/main/data/local/web/positions_local_data_source_web.dart';
import 'package:portfolio/main/data/local/web/posts_local_data_source_web.dart';
import 'package:portfolio/main/data/local/web/projects_local_data_source_web.dart';
import 'package:portfolio/main/data/local/web/skills_local_data_source_web.dart';
import 'package:portfolio/main/data/remote/education_remote_data_source.dart';
import 'package:portfolio/main/data/remote/personal_info_remote_data_source.dart';
import 'package:portfolio/main/data/remote/positions_remote_data_source.dart';
import 'package:portfolio/main/data/remote/posts_remote_data_source.dart';
import 'package:portfolio/main/data/remote/projects_remote_data_source.dart';
import 'package:portfolio/main/data/remote/skills_remote_data_source.dart';
import 'package:portfolio/main/data/repository/blog_repository.dart'
    as blog_repo_impl;
import 'package:portfolio/main/data/repository/education_repository.dart'
    as education_repo_impl;
import 'package:portfolio/main/data/repository/personal_info_repository.dart'
    as personal_info_repo_impl;
import 'package:portfolio/main/data/repository/position_repository.dart'
    as position_repo_impl;
import 'package:portfolio/main/data/repository/project_repository.dart'
    as project_repo_impl;
import 'package:portfolio/main/data/repository/skill_repository.dart'
    as skill_repo_impl;
import 'package:portfolio/main/data/utils/typedefs.dart';
import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/domain/model/personal_info.dart';
import 'package:portfolio/main/domain/model/position.dart';
import 'package:portfolio/main/domain/model/post.dart';
import 'package:portfolio/main/domain/model/project.dart';
import 'package:portfolio/main/domain/model/skill.dart';
import 'package:portfolio/main/domain/repositories/blog_repository.dart';
import 'package:portfolio/main/domain/repositories/education_repository.dart';
import 'package:portfolio/main/domain/repositories/personal_info_repository.dart';
import 'package:portfolio/main/domain/repositories/position_repository.dart';
import 'package:portfolio/main/domain/repositories/project_repository.dart';
import 'package:portfolio/main/domain/repositories/skill_repository.dart';

import 'fake_firebase_auth.dart';
import 'fake_firebase_database.dart';
import 'fake_logger.dart';
import 'fake_sqflite.dart';

/// Test service locator instance - separate from production
final GetIt testLocator = GetIt.asNewInstance();

/// Setup test dependencies - mirrors production service locator but with fakes
Future<void> setupTestLocator({bool useWeb = false}) async {
  // Clear any existing registrations
  await testLocator.reset();

  // Register Mock Logger
  testLocator.registerLazySingleton<AppLogger>(() => FakeLogger());

  // Register Fake Firebase Auth
  testLocator.registerLazySingleton<FakeFirebaseAuth>(
    () => FakeFirebaseAuth(),
  );

  // Register Fake Firebase Database Reference
  testLocator.registerLazySingleton<FirebaseDatabaseReference>(
    () => FakeDatabaseReference.root(),
  );

  // Register Remote Data Sources with fakes
  testLocator.registerLazySingleton<PostsRemoteDataSource>(
    () => PostsRemoteDataSourceImpl(
      firebaseDatabaseReference: testLocator<FirebaseDatabaseReference>(),
      logger: testLocator<AppLogger>(),
    ),
  );

  testLocator.registerLazySingleton<PositionsRemoteDataSource>(
    () => PositionsRemoteDataSourceImpl(
      firebaseDatabaseReference: testLocator<FirebaseDatabaseReference>(),
      logger: testLocator<AppLogger>(),
    ),
  );

  testLocator.registerLazySingleton<ProjectsRemoteDataSource>(
    () => ProjectsRemoteDataSourceImpl(
      firebaseDatabaseReference: testLocator<FirebaseDatabaseReference>(),
      logger: testLocator<AppLogger>(),
    ),
  );

  testLocator.registerLazySingleton<EducationRemoteDataSource>(
    () => EducationRemoteDataSourceImpl(
      firebaseDatabaseReference: testLocator<FirebaseDatabaseReference>(),
      logger: testLocator<AppLogger>(),
    ),
  );

  testLocator.registerLazySingleton<SkillsRemoteDataSource>(
    () => SkillsRemoteDataSourceImpl(
      firebaseDatabaseReference: testLocator<FirebaseDatabaseReference>(),
      logger: testLocator<AppLogger>(),
    ),
  );

  testLocator.registerLazySingleton<PersonalInfoRemoteDataSource>(
    () => PersonalInfoRemoteDataSourceImpl(
      firebaseDatabaseReference: testLocator<FirebaseDatabaseReference>(),
      logger: testLocator<AppLogger>(),
    ),
  );

  // Register Local Data Sources based on platform (test parameter)
  if (useWeb) {
    // Web platform: Use in-memory caching
    testLocator.registerLazySingleton<PostsLocalDataSource>(
      () => _PostsLocalDataSourceWebAdapter(
        PostsLocalDataSourceWebImpl(logger: testLocator<AppLogger>()),
      ),
    );

    testLocator.registerLazySingleton<PositionsLocalDataSource>(
      () => _PositionsLocalDataSourceWebAdapter(
        PositionsLocalDataSourceWebImpl(logger: testLocator<AppLogger>()),
      ),
    );

    testLocator.registerLazySingleton<ProjectsLocalDataSource>(
      () => _ProjectsLocalDataSourceWebAdapter(
        ProjectsLocalDataSourceWebImpl(logger: testLocator<AppLogger>()),
      ),
    );

    testLocator.registerLazySingleton<EducationLocalDataSource>(
      () => _EducationLocalDataSourceWebAdapter(
        EducationLocalDataSourceWebImpl(logger: testLocator<AppLogger>()),
      ),
    );

    testLocator.registerLazySingleton<SkillsLocalDataSource>(
      () => _SkillsLocalDataSourceWebAdapter(
        SkillsLocalDataSourceWebImpl(logger: testLocator<AppLogger>()),
      ),
    );

    testLocator.registerLazySingleton<PersonalInfoLocalDataSource>(
      () => _PersonalInfoLocalDataSourceWebAdapter(
        PersonalInfoLocalDataSourceWebImpl(logger: testLocator<AppLogger>()),
      ),
    );
  } else {
    // Native platforms: Use fake SQLite
    final fakeDatabase = FakeDatabase();
    testLocator.registerLazySingleton<FakeDatabase>(() => fakeDatabase);

    testLocator.registerLazySingleton<PostsLocalDataSource>(
      () => PostsLocalDataSourceImpl(
        database: testLocator<FakeDatabase>(),
        logger: testLocator<AppLogger>(),
      ),
    );

    testLocator.registerLazySingleton<PositionsLocalDataSource>(
      () => PositionsLocalDataSourceImpl(
        database: testLocator<FakeDatabase>(),
        logger: testLocator<AppLogger>(),
      ),
    );

    testLocator.registerLazySingleton<ProjectsLocalDataSource>(
      () => ProjectsLocalDataSourceImpl(
        database: testLocator<FakeDatabase>(),
        logger: testLocator<AppLogger>(),
      ),
    );

    testLocator.registerLazySingleton<EducationLocalDataSource>(
      () => EducationLocalDataSourceImpl(
        database: testLocator<FakeDatabase>(),
        logger: testLocator<AppLogger>(),
      ),
    );

    testLocator.registerLazySingleton<SkillsLocalDataSource>(
      () => SkillsLocalDataSourceImpl(
        database: testLocator<FakeDatabase>(),
        logger: testLocator<AppLogger>(),
      ),
    );

    testLocator.registerLazySingleton<PersonalInfoLocalDataSource>(
      () => PersonalInfoLocalDataSourceImpl(
        database: testLocator<FakeDatabase>(),
        logger: testLocator<AppLogger>(),
      ),
    );
  }

  // Register Repositories
  testLocator.registerLazySingleton<BlogRepository>(
    () => blog_repo_impl.BlogRepositoryImpl(
      remoteDataSource: testLocator<PostsRemoteDataSource>(),
      localDataSource: testLocator<PostsLocalDataSource>(),
      logger: testLocator<AppLogger>(),
    ),
  );

  testLocator.registerLazySingleton<PositionRepository>(
    () => position_repo_impl.PositionRepositoryImpl(
      remoteDataSource: testLocator<PositionsRemoteDataSource>(),
      localDataSource: testLocator<PositionsLocalDataSource>(),
      logger: testLocator<AppLogger>(),
    ),
  );

  testLocator.registerLazySingleton<ProjectRepository>(
    () => project_repo_impl.ProjectRepositoryImpl(
      remoteDataSource: testLocator<ProjectsRemoteDataSource>(),
      localDataSource: testLocator<ProjectsLocalDataSource>(),
      logger: testLocator<AppLogger>(),
    ),
  );

  testLocator.registerLazySingleton<EducationRepository>(
    () => education_repo_impl.EducationRepositoryImpl(
      remoteDataSource: testLocator<EducationRemoteDataSource>(),
      localDataSource: testLocator<EducationLocalDataSource>(),
      logger: testLocator<AppLogger>(),
    ),
  );

  testLocator.registerLazySingleton<SkillRepository>(
    () => skill_repo_impl.SkillRepositoryImpl(
      remoteDataSource: testLocator<SkillsRemoteDataSource>(),
      localDataSource: testLocator<SkillsLocalDataSource>(),
      logger: testLocator<AppLogger>(),
    ),
  );

  testLocator.registerLazySingleton<PersonalInfoRepository>(
    () => personal_info_repo_impl.PersonalInfoRepositoryImpl(
      remoteDataSource: testLocator<PersonalInfoRemoteDataSource>(),
      localDataSource: testLocator<PersonalInfoLocalDataSource>(),
      logger: testLocator<AppLogger>(),
    ),
  );
}

/// Tear down test locator - call between tests for isolation
Future<void> tearDownTestLocator() async {
  await testLocator.reset();
}

// Adapter classes for web implementations (same as production)

class _PostsLocalDataSourceWebAdapter implements PostsLocalDataSource {
  _PostsLocalDataSourceWebAdapter(this._webImpl);

  final PostsLocalDataSourceWeb _webImpl;

  @override
  Future<void> cachePost(post) => _webImpl.cachePost(post);

  @override
  Future<void> cachePosts(posts) => _webImpl.cachePosts(posts);

  @override
  Future<List<Post>> getCachedPosts() => _webImpl.getCachedPosts();

  @override
  Future<void> clearCache() => _webImpl.clearCache();
}

class _PositionsLocalDataSourceWebAdapter implements PositionsLocalDataSource {
  _PositionsLocalDataSourceWebAdapter(this._webImpl);

  final PositionsLocalDataSourceWeb _webImpl;

  @override
  Future<void> savePosition(position) => _webImpl.cachePosition(position);

  @override
  Future<void> savePositions(positions) => _webImpl.cachePositions(positions);

  @override
  Future<List<Position>> getPositions() => _webImpl.getCachedPositions();

  @override
  Future<void> clearCache() => _webImpl.clearCache();
}

class _ProjectsLocalDataSourceWebAdapter implements ProjectsLocalDataSource {
  _ProjectsLocalDataSourceWebAdapter(this._webImpl);

  final ProjectsLocalDataSourceWeb _webImpl;

  @override
  Future<void> saveProject(project) => _webImpl.cacheProject(project);

  @override
  Future<void> saveProjects(projects) => _webImpl.cacheProjects(projects);

  @override
  Future<List<Project>> getProjects() => _webImpl.getCachedProjects();

  @override
  Future<void> clearCache() => _webImpl.clearCache();
}

class _EducationLocalDataSourceWebAdapter implements EducationLocalDataSource {
  _EducationLocalDataSourceWebAdapter(this._webImpl);

  final EducationLocalDataSourceWeb _webImpl;

  @override
  Future<void> saveEducation(education) => _webImpl.cacheEducation(education);

  @override
  Future<void> saveEducationList(educationList) =>
      _webImpl.cacheEducationList(educationList);

  @override
  Future<List<Education>> getEducation() => _webImpl.getCachedEducation();

  @override
  Future<void> clearCache() => _webImpl.clearCache();
}

class _SkillsLocalDataSourceWebAdapter implements SkillsLocalDataSource {
  _SkillsLocalDataSourceWebAdapter(this._webImpl);

  final SkillsLocalDataSourceWeb _webImpl;

  @override
  Future<void> saveSkill(skill) => _webImpl.cacheSkill(skill);

  @override
  Future<void> saveSkills(skills) => _webImpl.cacheSkills(skills);

  @override
  Future<List<Skill>> getSkills() => _webImpl.getCachedSkills();

  @override
  Future<void> clearCache() => _webImpl.clearCache();
}

class _PersonalInfoLocalDataSourceWebAdapter
    implements PersonalInfoLocalDataSource {
  _PersonalInfoLocalDataSourceWebAdapter(this._webImpl);

  final PersonalInfoLocalDataSourceWeb _webImpl;

  @override
  Future<void> savePersonalInfo(info) => _webImpl.cachePersonalInfo(info);

  @override
  Future<PersonalInfo?> getPersonalInfo() => _webImpl.getCachedPersonalInfo();

  @override
  Future<void> clearCache() => _webImpl.clearCache();
}
