import 'package:portfolio/main/data/mapper/firebase_raw_data_mapper.dart';
import 'package:portfolio/main/data/mapper/post_remote_model_mapper.dart';
import 'package:portfolio/main/data/utils/typedefs.dart';
import 'package:portfolio/main/domain/model/post.dart';
import 'package:portfolio/core/logger/app_logger.dart';

/// Remote static_data source for Posts
/// Handles all Firebase Realtime Database operations for posts
abstract class PostsRemoteDataSource {
  Future<void> addPost(Post post);

  Future<List<Post>> readPosts();
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  PostsRemoteDataSourceImpl({
    required this.firebaseDatabaseReference,
    required this.logger,
  });

  final FirebaseDatabaseReference firebaseDatabaseReference;
  final AppLogger logger;
  static const String _collectionName = 'posts';

  @override
  Future<void> addPost(Post post) async {
    final postsCollection = firebaseDatabaseReference.child(_collectionName);

    try {
      final model = postRemoteModelFromDomain(post);
      await postsCollection.push().set(model.toJson());
      logger.debug(
          'Post added successfully to Firebase', 'PostsRemoteDataSource');
    } catch (e, stackTrace) {
      logger.error('Error adding post to Firebase', e, stackTrace,
          'PostsRemoteDataSource');
      rethrow;
    }
  }

  @override
  Future<List<Post>> readPosts() async {
    final postsCollection = firebaseDatabaseReference.child(_collectionName);
    final event = await postsCollection.once();

    final rawData = event.snapshot.value;
    if (rawData == null) return [];

    try {
      final posts = firebaseRawToJsonMaps(rawData)
          .map(postRemoteModelFromJson)
          .map((m) => m.toDomain())
          .toList();

      logger.debug('Loaded ${posts.length} posts from Firebase',
          'PostsRemoteDataSource');
      return posts;
    } catch (e, stackTrace) {
      logger.error('Error parsing posts from Firebase', e, stackTrace,
          'PostsRemoteDataSource');
      rethrow;
    }
  }
}
