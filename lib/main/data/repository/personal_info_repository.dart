import 'dart:async';

import 'package:portfolio/main/data/local/sqlite/personal_info_local_data_source.dart';
import 'package:portfolio/main/data/remote/personal_info_remote_data_source.dart';
import 'package:portfolio/main/domain/model/personal_info.dart';
import 'package:portfolio/main/domain/repositories/personal_info_repository.dart';

/// Implementation of PersonalInfoRepository
/// Uses a 3-tier caching strategy similar to BaseRepository but for single objects
class PersonalInfoRepositoryImpl implements PersonalInfoRepository {
  PersonalInfoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final PersonalInfoRemoteDataSource remoteDataSource;
  final PersonalInfoLocalDataSource localDataSource;

  // In-memory cache for fastest access
  PersonalInfo? _memoryCache;

  // Stream controller to notify listeners about data updates
  final _dataStreamController = StreamController<PersonalInfo?>.broadcast();

  /// Returns a Stream that emits data from multiple cache layers progressively:
  /// 1. First emits from memory cache if available
  /// 2. Then emits from local storage if available (and different from memory)
  /// 3. Finally emits from remote source (and notifies listeners)
  @override
  Stream<PersonalInfo?> get personalInfoUpdateStream async* {
    bool hasEmittedData = false;

    // 1. Check in-memory cache first (fastest)
    if (_memoryCache != null) {
      print('Emitting personal info from memory cache');
      yield _memoryCache;
      hasEmittedData = true;
    }

    // 2. Check local storage (SQLite/web storage)
    try {
      final localData = await localDataSource.getPersonalInfo();
      if (localData != null) {
        print('Emitting personal info from local storage');
        _memoryCache = localData; // Cache in memory for next time
        yield localData;
        hasEmittedData = true;
      }
    } catch (e) {
      print('Error reading personal info from local storage: $e');
    }

    // 3. Fetch from remote data source (slowest, but most up-to-date)
    try {
      final remoteData = await remoteDataSource.readPersonalInfo();

      if (remoteData != null) {
        print('Emitting personal info from remote source');

        // Cache the remote data in both memory and local storage
        _memoryCache = remoteData;

        try {
          await localDataSource.savePersonalInfo(remoteData);
          print('Cached personal info to local storage');
        } catch (e) {
          print('Warning: Failed to cache personal info locally: $e');
          // Don't fail the operation if caching fails
        }

        // Emit the fresh remote data
        yield remoteData;

        // Notify other listeners about the remote update
        _dataStreamController.add(remoteData);
      } else if (!hasEmittedData) {
        // If nothing was emitted and remote is empty, emit null
        yield null;
      }
    } catch (e) {
      print('Error fetching personal info from remote data source: $e');
      // If everything fails and nothing was emitted, return null
      if (!hasEmittedData) {
        yield null;
      }
    }
  }

  /// Forces a refresh from remote, bypassing all caches
  @override
  Future<PersonalInfo?> refreshPersonalInfo() async {
    await _clearCache();
    return await personalInfoUpdateStream.last;
  }

  /// Clears all caches
  Future<void> _clearCache() async {
    _memoryCache = null;
    try {
      await localDataSource.clearCache();
      print('Personal info caches cleared');
    } catch (e) {
      print('Error clearing personal info local cache: $e');
    }
  }

  /// Dispose the stream controller to prevent memory leaks
  void dispose() {
    _dataStreamController.close();
  }
}
