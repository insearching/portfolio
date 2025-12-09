import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get_it/get_it.dart';
import 'package:portfolio/main/data/database/database_helper.dart';
import 'package:portfolio/main/data/local/dao/position_dao.dart';
import 'package:portfolio/main/data/local/dao/post_dao.dart';
import 'package:portfolio/main/data/local/positions_local_data_source.dart';
import 'package:portfolio/main/data/local/positions_local_data_source_web.dart';
import 'package:portfolio/main/data/local/posts_local_data_source.dart';
import 'package:portfolio/main/data/local/posts_local_data_source_web.dart';
import 'package:portfolio/main/data/position.dart';
import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/data/remote/positions_remote_data_source.dart';
import 'package:portfolio/main/data/remote/posts_remote_data_source.dart';
import 'package:portfolio/main/data/repository/blog_repository.dart';
import 'package:portfolio/main/data/repository/portfolio_repository.dart';
import 'package:portfolio/main/data/repository/position_repository.dart';
import 'package:portfolio/main/data/typedefs.dart';
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
  }

  // Register DAOs (Data Access Objects)
  locator.registerLazySingleton<PostDao>(
    () => PostDaoImpl(
      remoteDataSource: locator<PostsRemoteDataSource>(),
      localDataSource: locator<PostsLocalDataSource>(),
    ),
  );
  locator.registerLazySingleton<PositionDao>(
    () => PositionDaoImpl(
      remoteDataSource: locator<PositionsRemoteDataSource>(),
      localDataSource: locator<PositionsLocalDataSource>(),
    ),
  );

  // Register individual repositories
  locator.registerLazySingleton<BlogRepository>(
    () => BlogRepository(postDao: locator<PostDao>()),
  );
  locator.registerLazySingleton<PositionRepository>(
    () => PositionRepository(positionDao: locator<PositionDao>()),
  );

  // Register centralized Portfolio Repository
  locator.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepository(
      blogRepository: locator<BlogRepository>(),
      positionRepository: locator<PositionRepository>(),
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
  Future<void> savePositions(positions) => _webImpl.cachePositions(positions);

  @override
  Future<List<Position>> getPositions() => _webImpl.getCachedPositions();
}
