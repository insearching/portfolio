import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:get_it/get_it.dart';
import 'package:portfolio/core/config/debug_firebase_remote_config.dart';
import 'package:portfolio/core/config/firebase_remote_config.dart';
import 'package:portfolio/core/config/stub_firebase_remote_config.dart';
import 'package:portfolio/core/logger/app_logger.dart';
import 'package:portfolio/core/logger/debug_logger.dart';
import 'package:portfolio/core/logger/release_logger.dart';
import 'package:portfolio/main/data/local/sqlite/database_helper.dart';
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
import 'package:portfolio/main/data/repository/auth_repository_impl.dart';
import 'package:portfolio/main/data/repository/blog_repository.dart'
    as blog_repo_impl;
import 'package:portfolio/main/data/repository/education_repository.dart'
    as education_repo_impl;
import 'package:portfolio/main/data/repository/personal_info_repository.dart'
    as personal_info_repo_impl;
import 'package:portfolio/main/data/repository/portfolio_repository.dart';
import 'package:portfolio/main/data/repository/position_repository.dart'
    as position_repo_impl;
import 'package:portfolio/main/data/repository/project_repository.dart'
    as project_repo_impl;
import 'package:portfolio/main/data/repository/skill_repository.dart'
    as skill_repo_impl;
import 'package:portfolio/main/data/utils/typedefs.dart';
import 'package:portfolio/main/domain/model/device_info.dart';
import 'package:portfolio/main/domain/model/device_type.dart';
import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/domain/model/personal_info.dart';
import 'package:portfolio/main/domain/model/position.dart';
import 'package:portfolio/main/domain/model/post.dart';
import 'package:portfolio/main/domain/model/project.dart';
import 'package:portfolio/main/domain/model/skill.dart';
import 'package:portfolio/main/domain/repositories/auth_repository.dart';
import 'package:portfolio/main/domain/repositories/blog_repository.dart';
import 'package:portfolio/main/domain/repositories/education_repository.dart';
import 'package:portfolio/main/domain/repositories/personal_info_repository.dart';
import 'package:portfolio/main/domain/repositories/position_repository.dart';
import 'package:portfolio/main/domain/repositories/project_repository.dart';
import 'package:portfolio/main/domain/repositories/skill_repository.dart';
import 'package:portfolio/main/domain/usecases/add_blog_post.dart';
import 'package:portfolio/main/domain/usecases/add_education.dart';
import 'package:portfolio/main/domain/usecases/add_position.dart';
import 'package:portfolio/main/domain/usecases/add_project.dart';
import 'package:portfolio/main/domain/usecases/add_skill.dart';
import 'package:portfolio/main/domain/usecases/authenticate_admin.dart';
import 'package:portfolio/main/domain/usecases/check_authentication.dart';
import 'package:portfolio/main/domain/usecases/get_education_stream.dart';
import 'package:portfolio/main/domain/usecases/get_personal_info_stream.dart';
import 'package:portfolio/main/domain/usecases/get_positions_stream.dart';
import 'package:portfolio/main/domain/usecases/get_posts_stream.dart';
import 'package:portfolio/main/domain/usecases/get_projects_stream.dart';
import 'package:portfolio/main/domain/usecases/get_skills_stream.dart';
import 'package:portfolio/main/domain/usecases/refresh_all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

final GetIt locator = GetIt.instance;

/// Detects if the app is running in a CI/CD environment
///
/// Checks common CI environment variables to determine if running in CI:
/// - CI (generic)
/// - CONTINUOUS_INTEGRATION (generic)
/// - GITHUB_ACTIONS (GitHub Actions)
/// - GITLAB_CI (GitLab CI)
/// - CIRCLECI (CircleCI)
/// - TRAVIS (Travis CI)
/// - JENKINS_HOME (Jenkins)
bool _isRunningInCI() {
  if (kIsWeb) return false; // Web doesn't have access to environment variables

  try {
    final env = Platform.environment;
    return env['CI'] == 'true' ||
        env['CONTINUOUS_INTEGRATION'] == 'true' ||
        env['GITHUB_ACTIONS'] == 'true' ||
        env['GITLAB_CI'] == 'true' ||
        env['CIRCLECI'] == 'true' ||
        env['TRAVIS'] == 'true' ||
        env.containsKey('JENKINS_HOME');
  } catch (e) {
    // If we can't access environment variables, assume not in CI
    return false;
  }
}

Future<void> setupLocator() async {
  // Register Logger (Debug or Release implementation based on build mode)
  locator.registerLazySingleton<AppLogger>(
    () => kDebugMode ? DebugLogger() : ReleaseLogger(),
  );

  // Register FirebaseRemoteConfig based on build mode and environment
  // In CI: Always uses StubFirebaseRemoteConfig (committed)
  // In debug mode: uses DebugFirebaseRemoteConfig (gitignored, local only)
  //                Falls back to StubFirebaseRemoteConfig if placeholders detected
  // In release (non-CI): uses StubFirebaseRemoteConfig (committed)
  locator.registerLazySingleton<FirebaseRemoteConfig>(
    () {
      // Always use stub config in CI environments
      if (_isRunningInCI()) {
        return const StubFirebaseRemoteConfig();
      }

      // In debug mode, try to use debug config if properly configured
      if (kDebugMode) {
        const debugConfig = DebugFirebaseRemoteConfig();
        // Check if debug config has placeholder values
        if (debugConfig.firebaseEmail.contains('YOUR_FIREBASE') ||
            debugConfig.firebasePassword.contains('YOUR_FIREBASE')) {
          // Placeholders detected - use stub config instead
          return const StubFirebaseRemoteConfig();
        }
        return debugConfig;
      }

      // Release mode (non-CI) - use stub config
      return const StubFirebaseRemoteConfig();
    },
  );

  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Register Firebase Auth
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Register Firebase Database Reference (Remote)
  locator.registerLazySingleton<FirebaseDatabaseReference>(
    () => FirebaseDatabase.instance.ref(),
  );

  // Register Remote Data Sources
  locator.registerLazySingleton<PostsRemoteDataSource>(
    () => PostsRemoteDataSourceImpl(
      firebaseDatabaseReference: locator<FirebaseDatabaseReference>(),
      logger: locator<AppLogger>(),
    ),
  );
  locator.registerLazySingleton<PositionsRemoteDataSource>(
    () => PositionsRemoteDataSourceImpl(
      firebaseDatabaseReference: locator<FirebaseDatabaseReference>(),
      logger: locator<AppLogger>(),
    ),
  );
  locator.registerLazySingleton<ProjectsRemoteDataSource>(
    () => ProjectsRemoteDataSourceImpl(
      firebaseDatabaseReference: locator<FirebaseDatabaseReference>(),
      logger: locator<AppLogger>(),
    ),
  );
  locator.registerLazySingleton<EducationRemoteDataSource>(
    () => EducationRemoteDataSourceImpl(
      firebaseDatabaseReference: locator<FirebaseDatabaseReference>(),
      logger: locator<AppLogger>(),
    ),
  );
  locator.registerLazySingleton<SkillsRemoteDataSource>(
    () => SkillsRemoteDataSourceImpl(
      firebaseDatabaseReference: locator<FirebaseDatabaseReference>(),
      logger: locator<AppLogger>(),
    ),
  );
  locator.registerLazySingleton<PersonalInfoRemoteDataSource>(
    () => PersonalInfoRemoteDataSourceImpl(
      firebaseDatabaseReference: locator<FirebaseDatabaseReference>(),
      logger: locator<AppLogger>(),
    ),
  );

  // Register Local Data Sources based on platform
  if (kIsWeb) {
    // Web platform: Use in-memory caching
    locator.registerLazySingleton<PostsLocalDataSource>(
      () => _PostsLocalDataSourceWebAdapter(
        PostsLocalDataSourceWebImpl(logger: locator<AppLogger>()),
      ),
    );
    locator.registerLazySingleton<PositionsLocalDataSource>(
      () => _PositionsLocalDataSourceWebAdapter(
        PositionsLocalDataSourceWebImpl(logger: locator<AppLogger>()),
      ),
    );
    locator.registerLazySingleton<ProjectsLocalDataSource>(
      () => _ProjectsLocalDataSourceWebAdapter(
        ProjectsLocalDataSourceWebImpl(logger: locator<AppLogger>()),
      ),
    );
    locator.registerLazySingleton<EducationLocalDataSource>(
      () => _EducationLocalDataSourceWebAdapter(
        EducationLocalDataSourceWebImpl(logger: locator<AppLogger>()),
      ),
    );
    locator.registerLazySingleton<SkillsLocalDataSource>(
      () => _SkillsLocalDataSourceWebAdapter(
        SkillsLocalDataSourceWebImpl(logger: locator<AppLogger>()),
      ),
    );
    locator.registerLazySingleton<PersonalInfoLocalDataSource>(
      () => _PersonalInfoLocalDataSourceWebAdapter(
        PersonalInfoLocalDataSourceWebImpl(logger: locator<AppLogger>()),
      ),
    );
  } else {
    // Native platforms (mobile, desktop): Use SQLite
    final database = await DatabaseHelper.initDatabase();
    locator.registerLazySingleton<Database>(() => database);

    locator.registerLazySingleton<PostsLocalDataSource>(
      () => PostsLocalDataSourceImpl(
        database: locator<Database>(),
        logger: locator<AppLogger>(),
      ),
    );
    locator.registerLazySingleton<PositionsLocalDataSource>(
      () => PositionsLocalDataSourceImpl(
        database: locator<Database>(),
        logger: locator<AppLogger>(),
      ),
    );
    locator.registerLazySingleton<ProjectsLocalDataSource>(
      () => ProjectsLocalDataSourceImpl(
        database: locator<Database>(),
        logger: locator<AppLogger>(),
      ),
    );
    locator.registerLazySingleton<EducationLocalDataSource>(
      () => EducationLocalDataSourceImpl(
        database: locator<Database>(),
        logger: locator<AppLogger>(),
      ),
    );
    locator.registerLazySingleton<SkillsLocalDataSource>(
      () => SkillsLocalDataSourceImpl(
        database: locator<Database>(),
        logger: locator<AppLogger>(),
      ),
    );
    locator.registerLazySingleton<PersonalInfoLocalDataSource>(
      () => PersonalInfoLocalDataSourceImpl(
        database: locator<Database>(),
        logger: locator<AppLogger>(),
      ),
    );
  }

  // Register repositories - directly inject static_data sources (no DAO layer)

  // Blog Repository
  locator.registerLazySingleton<BlogRepository>(
    () => blog_repo_impl.BlogRepositoryImpl(
      remoteDataSource: locator<PostsRemoteDataSource>(),
      localDataSource: locator<PostsLocalDataSource>(),
      logger: locator<AppLogger>(),
    ),
  );

  // Position Repository
  locator.registerLazySingleton<PositionRepository>(
    () => position_repo_impl.PositionRepositoryImpl(
      remoteDataSource: locator<PositionsRemoteDataSource>(),
      localDataSource: locator<PositionsLocalDataSource>(),
      logger: locator<AppLogger>(),
    ),
  );

  // Project Repository
  locator.registerLazySingleton<ProjectRepository>(
    () => project_repo_impl.ProjectRepositoryImpl(
      remoteDataSource: locator<ProjectsRemoteDataSource>(),
      localDataSource: locator<ProjectsLocalDataSource>(),
      logger: locator<AppLogger>(),
    ),
  );

  // Education Repository
  locator.registerLazySingleton<EducationRepository>(
    () => education_repo_impl.EducationRepositoryImpl(
      remoteDataSource: locator<EducationRemoteDataSource>(),
      localDataSource: locator<EducationLocalDataSource>(),
      logger: locator<AppLogger>(),
    ),
  );

  // Skill Repository
  locator.registerLazySingleton<SkillRepository>(
    () => skill_repo_impl.SkillRepositoryImpl(
      remoteDataSource: locator<SkillsRemoteDataSource>(),
      localDataSource: locator<SkillsLocalDataSource>(),
      logger: locator<AppLogger>(),
    ),
  );

  // PersonalInfo Repository
  locator.registerLazySingleton<PersonalInfoRepository>(
    () => personal_info_repo_impl.PersonalInfoRepositoryImpl(
      remoteDataSource: locator<PersonalInfoRemoteDataSource>(),
      localDataSource: locator<PersonalInfoLocalDataSource>(),
      logger: locator<AppLogger>(),
    ),
  );

  // Register centralized Portfolio Repository (for static data only)
  locator.registerLazySingleton<PortfolioRepository>(
    () => const PortfolioRepository(),
  );

  // Register Use Cases
  locator.registerLazySingleton<GetEducationStream>(
    () => GetEducationStream(
      educationRepository: locator<EducationRepository>(),
    ),
  );

  locator.registerLazySingleton<GetProjectsStream>(
    () => GetProjectsStream(
      projectRepository: locator<ProjectRepository>(),
    ),
  );

  locator.registerLazySingleton<GetPostsStream>(
    () => GetPostsStream(
      blogRepository: locator<BlogRepository>(),
    ),
  );

  locator.registerLazySingleton<GetPositionsStream>(
    () => GetPositionsStream(
      positionRepository: locator<PositionRepository>(),
    ),
  );

  locator.registerLazySingleton<GetSkillsStream>(
    () => GetSkillsStream(
      skillRepository: locator<SkillRepository>(),
    ),
  );

  locator.registerLazySingleton<GetPersonalInfoStream>(
    () => GetPersonalInfoStream(
      personalInfoRepository: locator<PersonalInfoRepository>(),
    ),
  );

  locator.registerLazySingleton<RefreshAll>(
    () => RefreshAll(
      blogRepository: locator<BlogRepository>(),
      positionRepository: locator<PositionRepository>(),
      projectRepository: locator<ProjectRepository>(),
      educationRepository: locator<EducationRepository>(),
      skillRepository: locator<SkillRepository>(),
      personalInfoRepository: locator<PersonalInfoRepository>(),
    ),
  );

  // Register Auth Repository
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseAuth: locator<FirebaseAuth>(),
      sharedPreferences: locator<SharedPreferences>(),
    ),
  );

  // Register Admin Use Cases
  locator.registerLazySingleton<AuthenticateAdmin>(
    () => AuthenticateAdmin(authRepository: locator<AuthRepository>()),
  );

  locator.registerLazySingleton<CheckAuthentication>(
    () => CheckAuthentication(authRepository: locator<AuthRepository>()),
  );

  locator.registerLazySingleton<AddBlogPost>(
    () => AddBlogPost(blogRepository: locator<BlogRepository>()),
  );

  locator.registerLazySingleton<AddProject>(
    () => AddProject(projectRepository: locator<ProjectRepository>()),
  );

  locator.registerLazySingleton<AddSkill>(
    () => AddSkill(skillRepository: locator<SkillRepository>()),
  );

  locator.registerLazySingleton<AddEducation>(
    () => AddEducation(educationRepository: locator<EducationRepository>()),
  );

  locator.registerLazySingleton<AddPosition>(
    () => AddPosition(positionRepository: locator<PositionRepository>()),
  );
}

/// Initialize DeviceInfo with the current device type
/// This should be called from the UI layer when the device type is determined
void setupDeviceInfo(DeviceType deviceType) {
  // Unregister existing instance if it exists
  if (locator.isRegistered<DeviceInfo>()) {
    locator.unregister<DeviceInfo>();
  }

  // Register the new DeviceInfo instance
  locator.registerLazySingleton<DeviceInfo>(
    () => DeviceInfo(deviceType),
  );
}

/// Adapter to make web implementation compatible with the PersonalInfoLocalDataSource interface
class _PersonalInfoLocalDataSourceWebAdapter
    implements PersonalInfoLocalDataSource {
  _PersonalInfoLocalDataSourceWebAdapter(this._webImpl);

  final PersonalInfoLocalDataSourceWeb _webImpl;

  @override
  Future<void> savePersonalInfo(PersonalInfo info) =>
      _webImpl.cachePersonalInfo(info);

  @override
  Future<PersonalInfo?> getPersonalInfo() => _webImpl.getCachedPersonalInfo();

  @override
  Future<void> clearCache() => _webImpl.clearCache();
}

/// Adapter to make web implementation compatible with the PostsLocalDataSource interface
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

/// Adapter to make web implementation compatible with the PositionsLocalDataSource interface
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

/// Adapter to make web implementation compatible with the ProjectsLocalDataSource interface
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

/// Adapter to make web implementation compatible with the EducationLocalDataSource interface
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

/// Adapter to make web implementation compatible with the SkillsLocalDataSource interface
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
