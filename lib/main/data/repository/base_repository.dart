import 'dart:async';

import 'package:portfolio/core/logger/app_logger.dart';

/// Base repository class that encapsulates common 3-tier caching logic
/// Priority: in-memory cache -> local storage -> remote static_data source
///
/// This repository now supports a Flow/Stream pattern that progressively emits data:
/// 1. First from memory cache (instant, if available)
/// 2. Then from local storage (fast, if available)
/// 3. Finally from remote source (slow but fresh)
///
/// The [dataStream] getter notifies listeners when remote data arrives.
///
/// Type parameters:
/// - [T]: The entity type (e.g., Post, Position)
/// - [RemoteDataSource]: The remote static_data source type
/// - [LocalDataSource]: The local static_data source type
///
/// Usage example:
/// ```dart
/// // Using Stream API (progressive loading)
/// repository.postsUpdateStream.listen((posts) {
///   // Called multiple times: first from cache, then from local, then from remote
///   print('Received ${posts.length} posts');
/// });
///
/// // Using Future API (waits for last emission from all cache layers)
/// final posts = await repository.postsUpdateStream.last;
///
/// // Force refresh from remote, bypassing all caches
/// final freshPosts = await repository.refreshPosts();
/// ```
abstract class BaseRepository<T, RemoteDataSource, LocalDataSource> {
  BaseRepository({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.logger,
  });

  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final AppLogger logger;

  // In-memory cache for fastest access
  List<T>? _memoryCache;

  // Stream controller to notify listeners about data updates
  final _dataStreamController = StreamController<List<T>>.broadcast();

  /// Returns a Stream that emits data from multiple cache layers progressively:
  /// 1. First emits from memory cache if available
  /// 2. Then emits from local storage if available (and different from memory)
  /// 3. Finally emits from remote source (and notifies listeners)
  ///
  /// The stream will emit multiple times as data becomes available from different sources.
  Stream<List<T>> fetchWithCache({
    required String entityName,
  }) async* {
    bool hasEmittedData = false;

    // 1. Check in-memory cache first (fastest)
    if (_memoryCache != null && _memoryCache!.isNotEmpty) {
      logger.debug('Emitting ${_memoryCache!.length} $entityName from memory cache', 'BaseRepository');
      yield _memoryCache!;
      hasEmittedData = true;
    }

    // 2. Check local storage (SQLite/web storage)
    try {
      final localData = await fetchFromLocal();
      if (localData.isNotEmpty) {
        logger.debug('Emitting ${localData.length} $entityName from local storage', 'BaseRepository');
        _memoryCache = localData; // Cache in memory for next time
        yield localData;
        hasEmittedData = true;
      }
    } catch (e, stackTrace) {
      logger.error('Error reading $entityName from local storage', e, stackTrace, 'BaseRepository');
    }

    // 3. Fetch from remote static_data source (slowest, but most up-to-date)
    try {
      final remoteData = await fetchFromRemote();

      if (remoteData.isNotEmpty) {
        logger.debug('Emitting ${remoteData.length} $entityName from remote source', 'BaseRepository');

        // Cache the remote static_data in both memory and local storage
        _memoryCache = remoteData;

        try {
          await saveToLocal(remoteData);
          logger.debug('Cached ${remoteData.length} $entityName to local storage', 'BaseRepository');
        } catch (e, stackTrace) {
          logger.warning('Failed to cache $entityName locally', 'BaseRepository');
          logger.error('Cache failure details', e, stackTrace, 'BaseRepository');
          // Don't fail the operation if caching fails
        }

        // Emit the fresh remote data
        yield remoteData;

        // Notify other listeners about the remote update
        _dataStreamController.add(remoteData);
      } else if (!hasEmittedData) {
        // If nothing was emitted and remote is empty, emit empty list
        yield [];
      }
    } catch (e, stackTrace) {
      logger.error('Error fetching $entityName from remote static_data source', e, stackTrace, 'BaseRepository');
      // If everything fails and nothing was emitted, return empty list
      if (!hasEmittedData) {
        yield [];
      }
    }
  }

  /// Returns a stream that listens to data updates from remote source
  /// This is useful for UI that wants to be notified when fresh data arrives
  Stream<List<T>> get dataStream => _dataStreamController.stream;

  /// Clears all caches (useful for refresh scenarios)
  Future<void> clearCache() async {
    _memoryCache = null;
    try {
      await clearLocalCache();
      logger.debug('All caches cleared', 'BaseRepository');
    } catch (e, stackTrace) {
      logger.error('Error clearing local cache', e, stackTrace, 'BaseRepository');
    }
  }

  /// Forces a refresh from remote, bypassing all caches
  /// Returns a Stream that will emit the fresh data from remote
  Stream<List<T>> refresh({required String entityName}) async* {
    await clearCache();
    yield* fetchWithCache(entityName: entityName);
  }

  /// Dispose the stream controller to prevent memory leaks
  void dispose() {
    _dataStreamController.close();
  }

  /// Updates memory cache with a new item
  void updateMemoryCacheWithItem(T item) {
    if (_memoryCache != null) {
      _memoryCache!.add(item);
    }
  }

  // Abstract methods that subclasses must implement

  /// Fetches static_data from remote static_data source
  Future<List<T>> fetchFromRemote();

  /// Fetches static_data from local static_data source
  Future<List<T>> fetchFromLocal();

  /// Saves static_data to local static_data source
  Future<void> saveToLocal(List<T> items);

  /// Clears local cache
  Future<void> clearLocalCache();
}
