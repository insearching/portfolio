import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get_it/get_it.dart';
import 'package:portfolio/main/data/local/sqlite/database_helper.dart';
import 'package:portfolio/main/data/local/sqlite/positions_local_data_source.dart';
import 'package:portfolio/main/data/local/sqlite/posts_local_data_source.dart';
import 'package:portfolio/main/data/local/sqlite/projects_local_data_source.dart';
import 'package:portfolio/main/data/local/web/positions_local_data_source_web.dart';
import 'package:portfolio/main/data/local/web/posts_local_data_source_web.dart';
import 'package:portfolio/main/data/local/web/projects_local_data_source_web.dart';
import 'package:portfolio/main/data/position.dart';
import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/data/project.dart';
import 'package:portfolio/main/data/remote/positions_remote_data_source.dart';
import 'package:portfolio/main/data/remote/posts_remote_data_source.dart';
import 'package:portfolio/main/data/remote/projects_remote_data_source.dart';
import 'package:portfolio/main/data/repository/blog_repository.dart'
    as blog_repo_impl;
import 'package:portfolio/main/data/repository/portfolio_repository.dart';
import 'package:portfolio/main/data/repository/position_repository.dart'
    as position_repo_impl;
import 'package:portfolio/main/data/repository/project_repository.dart'
    as project_repo_impl;
import 'package:portfolio/main/data/typedefs.dart';
import 'package:portfolio/main/domain/repositories/blog_repository.dart';
import 'package:portfolio/main/domain/repositories/position_repository.dart';
import 'package:portfolio/main/domain/repositories/project_repository.dart';
import 'package:sqflite/sqflite.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // Register Firebase Database Reference (Remote)
  locator.registerLazySingleton<FirebaseDatabaseReference>(
    () => FirebaseDatabase.instance.ref(),
  );

  // Register Remote Data Sources
  locator.registerLazySingleton<PostsRemoteDataSource>(
    () => PostsRemoteDataSourceImpl(
      firebaseDatabaseReference: locator<FirebaseDatabaseReference>(),
    ),
  );
  locator.registerLazySingleton<PositionsRemoteDataSource>(
    () => PositionsRemoteDataSourceImpl(
      firebaseDatabaseReference: locator<FirebaseDatabaseReference>(),
    ),
  );
  locator.registerLazySingleton<ProjectsRemoteDataSource>(
    () => ProjectsRemoteDataSourceImpl(
      firebaseDatabaseReference: locator<FirebaseDatabaseReference>(),
    ),
  );

  // Register Local Data Sources based on platform
  if (kIsWeb) {
    // Web platform: Use in-memory caching
    locator.registerLazySingleton<PostsLocalDataSource>(
      () => _PostsLocalDataSourceWebAdapter(
        PostsLocalDataSourceWebImpl(),
      ),
    );
    locator.registerLazySingleton<PositionsLocalDataSource>(
      () => _PositionsLocalDataSourceWebAdapter(
        PositionsLocalDataSourceWebImpl(),
      ),
    );
    locator.registerLazySingleton<ProjectsLocalDataSource>(
      () => _ProjectsLocalDataSourceWebAdapter(
        ProjectsLocalDataSourceWebImpl(),
      ),
    );
  } else {
    // Native platforms (mobile, desktop): Use SQLite
    final database = await DatabaseHelper.initDatabase();
    locator.registerLazySingleton<Database>(() => database);

    locator.registerLazySingleton<PostsLocalDataSource>(
      () => PostsLocalDataSourceImpl(
        database: locator<Database>(),
      ),
    );
    locator.registerLazySingleton<PositionsLocalDataSource>(
      () => PositionsLocalDataSourceImpl(
        database: locator<Database>(),
      ),
    );
    locator.registerLazySingleton<ProjectsLocalDataSource>(
      () => ProjectsLocalDataSourceImpl(
        database: locator<Database>(),
      ),
    );
  }

  // Register repositories - directly inject static_data sources (no DAO layer)

  // Blog Repository
  locator.registerLazySingleton<BlogRepository>(
    () => blog_repo_impl.BlogRepositoryImpl(
      remoteDataSource: locator<PostsRemoteDataSource>(),
      localDataSource: locator<PostsLocalDataSource>(),
    ),
  );

  // Position Repository
  locator.registerLazySingleton<PositionRepository>(
    () => position_repo_impl.PositionRepositoryImpl(
      remoteDataSource: locator<PositionsRemoteDataSource>(),
      localDataSource: locator<PositionsLocalDataSource>(),
    ),
  );

  // Project Repository
  locator.registerLazySingleton<ProjectRepository>(
    () => project_repo_impl.ProjectRepositoryImpl(
      remoteDataSource: locator<ProjectsRemoteDataSource>(),
      localDataSource: locator<ProjectsLocalDataSource>(),
    ),
  );

  // Register centralized Portfolio Repository
  locator.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepository(
      blogRepository: locator<BlogRepository>(),
      positionRepository: locator<PositionRepository>(),
      projectRepository: locator<ProjectRepository>(),
    ),
  );
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
