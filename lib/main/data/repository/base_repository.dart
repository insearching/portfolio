/// Base repository class that encapsulates common 3-tier caching logic
/// Priority: in-memory cache -> local storage -> remote static_data source
///
/// Type parameters:
/// - [T]: The entity type (e.g., Post, Position)
/// - [RemoteDataSource]: The remote static_data source type
/// - [LocalDataSource]: The local static_data source type
abstract class BaseRepository<T, RemoteDataSource, LocalDataSource> {
  BaseRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  // In-memory cache for fastest access
  List<T>? _memoryCache;

  /// Template method that implements the 3-tier caching strategy
  /// Subclasses must provide the specific static_data source method calls
  Future<List<T>> fetchWithCache({
    required String entityName,
  }) async {
    // 1. Check in-memory cache first (fastest)
    if (_memoryCache != null && _memoryCache!.isNotEmpty) {
      print('Returning ${_memoryCache!.length} $entityName from memory cache');
      return _memoryCache!;
    }

    // 2. Check local storage (SQLite/web storage)
    try {
      final localData = await fetchFromLocal();
      if (localData.isNotEmpty) {
        print('Returning ${localData.length} $entityName from local storage');
        _memoryCache = localData; // Cache in memory for next time
        return localData;
      }
    } catch (e) {
      print('Error reading $entityName from local storage: $e');
    }

    // 3. Fetch from remote static_data source (slowest, but most up-to-date)
    try {
      final remoteData = await fetchFromRemote();

      if (remoteData.isNotEmpty) {
        // Cache the remote static_data in both memory and local storage
        _memoryCache = remoteData;

        try {
          await saveToLocal(remoteData);
          print('Cached ${remoteData.length} $entityName to local storage');
        } catch (e) {
          print('Warning: Failed to cache $entityName locally: $e');
          // Don't fail the operation if caching fails
        }
      }

      return remoteData;
    } catch (e) {
      print('Error fetching $entityName from remote static_data source: $e');
      // If everything fails, return empty list
      return [];
    }
  }

  /// Clears all caches (useful for refresh scenarios)
  Future<void> clearCache() async {
    _memoryCache = null;
    try {
      await clearLocalCache();
      print('All caches cleared');
    } catch (e) {
      print('Error clearing local cache: $e');
    }
  }

  /// Forces a refresh from remote, bypassing all caches
  Future<List<T>> refresh({required String entityName}) async {
    await clearCache();
    return await fetchWithCache(entityName: entityName);
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
